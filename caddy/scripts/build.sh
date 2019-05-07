#!/bin/sh

# https://github.com/mholt/caddy/releases
# https://github.com/abiosoft/caddy-docker/blob/master/builder/builder.sh
PLUGINS='cache cloudflare cors expires realip'
TELEMETRY='true'
VERSION='v1.0.0'

stage() {
    STAGE="$1"
    echo
    echo starting stage: $STAGE
}

end_stage() {
    if [ $? -ne 0 ]; then
        >&2 echo error at \'$STAGE\'
        exit 1
    fi
    echo finished stage: $STAGE ✓
    echo
}

get_package() {
    GO111MODULE=off GOOS=linux GOARCH=amd64 caddyplug package $1 2> /dev/null
}

plugins() {
    mkdir -p /plugins
    for plugin in $(echo $PLUGINS | tr "," " "); do \
        import_package=$(get_package $plugin)
        $go_mod || go get -v "$import_package" ; # not needed for modules
        $go_mod && package="main" || package="caddyhttp"
        printf "package $package\nimport _ \"$import_package\"" > \
            /plugins/$plugin.go ; \
    done
}

module() {
    mkdir -p /caddy
    cd /caddy # build dir

    # setup module
    go mod init caddy
    go get -v github.com/mholt/caddy@$VERSION

    # plugins
    cp -r /plugins/. .

    # main and telemetry
    cat > main.go <<EOF
    package main
    import "github.com/mholt/caddy/caddy/caddymain"
    import "os"
    func main() {
        switch os.Getenv("ENABLE_TELEMETRY") {
        case "0", "false":
            caddymain.EnableTelemetry = false
        case "1", "true":
            caddymain.EnableTelemetry = true
        default:
            caddymain.EnableTelemetry = $TELEMETRY
        }
        caddymain.Run()
    }
EOF
}

legacy() {
    cd /go/src/github.com/mholt/caddy/caddy # build dir

    # plugins
    cp -r /plugins/. ../caddyhttp

    # telemetry
    run_file="/go/src/github.com/mholt/caddy/caddy/caddymain/run.go"
    if [ "$TELEMETRY" = "false" ]; then
        cat > "$run_file.disablestats.go" <<EOF
        package caddymain
        import "os"
        func init() {
            switch os.Getenv("ENABLE_TELEMETRY") {
            case "0", "false":
                EnableTelemetry = false
            case "1", "true":
                EnableTelemetry = true
            default:
                EnableTelemetry = false
            }
        }
EOF
    fi
}

# caddy source
stage "fetching caddy source"
git clone https://github.com/mholt/caddy -b "$VERSION" /go/src/github.com/mholt/caddy \
    && cd /go/src/github.com/mholt/caddy
end_stage

# plugin helper
stage "installing plugin helper"
GOOS=linux GOARCH=amd64 go get -v github.com/abiosoft/caddyplug/caddyplug
end_stage

# check for modules support
go_mod=false
[ -f /go/src/github.com/mholt/caddy/go.mod ] && export GO111MODULE=on && go_mod=true

# generate plugins
stage "generating plugins"
plugins
end_stage

# add plugins and telemetry
stage "customising plugins and telemetry"
if $go_mod; then module; else legacy; fi
end_stage

# build
stage "building caddy"
CGO_ENABLED=0 go build -o caddy
end_stage

# copy binary
stage "copying binary"
mkdir -p /install \
    && mv caddy /install \
    && /install/caddy -version
end_stage

echo "installed caddy version $VERSION at /install/caddy"
