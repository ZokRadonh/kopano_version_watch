FROM debian:stretch-slim

LABEL maintainer=az@zok.xyz \
      version="1.0"

RUN mkdir -p /kopanowatch/download/ /kopanowatch/archive && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        lynx \
        git \
        apt-utils \
        tar \
        cron \
    && rm -rf /var/cache/apt /var/lib/apt/lists

RUN curl -s https://download.docker.com/linux/static/stable/x86_64/docker-17.12.1-ce.tgz > /kopanowatch/download/docker.tgz

COPY check_and_fetch.sh build.sh crontab.tmp /kopanowatch/

RUN tar xzf /kopanowatch/download/docker.tgz -C /kopanowatch/download/ && \
    cp /kopanowatch/download/docker/docker /usr/local/bin && \
    rm /kopanowatch/download/docker.tgz \
        /kopanowatch/download/docker/dockerd \
        /kopanowatch/download/docker/docker-containerd \
        /kopanowatch/download/docker/docker-containerd-ctr \
        /kopanowatch/download/docker/docker-containerd-shim && \
    crontab /kopanowatch/crontab.tmp && \
    chmod a+x /kopanowatch/*.sh

CMD ["/usr/sbin/cron", "-f", "-L", "4"]