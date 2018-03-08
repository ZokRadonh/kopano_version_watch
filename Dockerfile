FROM docker:17.12

LABEL maintainer=az@zok.xyz \
      version="1.0"

#RUN apt-get update && apt-get install -y --no-install-recommends \
#    lynx \
#    curl \
#    cron \
#    ca-certificates \
#    && rm -rf /var/cache/apt /var/lib/apt/lists

RUN apk add --update --no-cache \
    ca-certificates \
    curl \
    bash \
    git \
    binutils \
    tar

RUN mkdir -p /kopanowatch/ /kopanowatch/archive

COPY check_and_fetch.sh build.sh crontab.tmp /kopanowatch/

RUN crontab /kopanowatch/crontab.tmp && \
    chmod a+x /kopanowatch/*.sh 

CMD ["/usr/sbin/crond", "-f", "-d", "0"]