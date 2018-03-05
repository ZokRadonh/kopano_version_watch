FROM debian:stretch

LABEL maintainer=az@zok.xyz \
      version="1.0"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    lynx \
    curl \
    cron \
    ca-certificates \
    && rm -rf /var/cache/apt /var/lib/apt/lists

RUN mkdir -p /kopanowatch/ /kopanowatch/archive

COPY check_and_fetch.sh /kopanowatch/check_and_fetch.sh
COPY crontab.tmp /kopanowatch/crontab.tmp

RUN crontab /kopanowatch/crontab.tmp && \
    chmod a+x /kopanowatch/check_and_fetch.sh

CMD ["/usr/sbin/cron", "-f"]