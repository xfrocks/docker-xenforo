# https://hub.docker.com/_/golang/
FROM golang:1.13.5-alpine3.10 as builder

RUN apk add --no-cache git gcc musl-dev

COPY . /opt
RUN /opt/scripts/build.sh

FROM alpine:3.10
COPY --from=builder /install/caddy /usr/bin/caddy

RUN set -ex; \
  apk add --no-cache openssh-client git; \
  /usr/bin/caddy --version; \
  /usr/bin/caddy --plugins

EXPOSE 80 443
VOLUME /root/.caddy /root/cache /var/www/html
WORKDIR /var/www/html

COPY . /opt

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
CMD ["-agree=true", "-log", "stdout"]
