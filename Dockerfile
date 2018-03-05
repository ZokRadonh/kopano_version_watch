FROM alpine:3.7

LABEL maintainer=az@zok.xyz \
      version="1.0"

RUN apk add --update \
    lynx \
    curl \
    bash \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /kopanowatch/ /kopanowatch/archive

COPY check_and_fetch.sh /kopanowatch/check_and_fetch.sh
COPY crontab.tmp /kopanowatch/crontab.tmp

RUN crontab /kopanowatch/crontab.tmp

CMD [/usr/sbin/crond, -f, -d, 0]