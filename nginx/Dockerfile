# https://hub.docker.com/_/nginx/
FROM nginx:1.19.2-alpine

COPY templates /opt/templates
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["-g", "daemon off;"]
