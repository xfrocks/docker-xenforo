FROM golang:1.9.3-alpine3.7 as builder

RUN apk add --no-cache git

COPY scripts/build.sh /usr/bin/build.sh
RUN /bin/sh /usr/bin/build.sh

FROM alpine:3.7
COPY --from=builder /install/caddy /usr/bin/caddy

RUN set -ex; \
  apk add --no-cache openssh-client git; \
  /usr/bin/caddy --version; \
  /usr/bin/caddy --plugins

EXPOSE 80 443
VOLUME /root/.caddy /var/www/html
WORKDIR /var/www/html

COPY . /opt

ENTRYPOINT ["/opt/scripts/entrypoint.sh"]
CMD ["-log", "stdout"]
