FROM golang:1.9.2-alpine3.6 as builder

RUN apk add --no-cache git

COPY scripts/build.sh /usr/bin/build.sh
RUN /bin/sh /usr/bin/build.sh

FROM alpine:3.6

RUN apk add --no-cache ca-certificates

COPY --from=builder /install/caddy /usr/bin/caddy

# validate install
RUN /usr/bin/caddy -version
RUN /usr/bin/caddy -plugins

EXPOSE 80 443
VOLUME /root/.caddy /var/www/html
WORKDIR /var/www/html

COPY templates /opt/templates
COPY scripts /opt/scripts
RUN chmod +x /opt/scripts/*.sh

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
CMD ["-log", "stdout"]
