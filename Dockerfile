FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
    git \
    zip \
    tini \
    vim \
    curl \
    htop \
    cron \
    sudo \
    wget \
    unzip \
    rsyslog \
    openssl \
    supervisor \
    ca-certificates \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*
    && mkdir -p /var/run/sshd

COPY entrypoint.sh /usr/local/bin/init.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisor.conf
RUN chmod +x /usr/local/bin/init.sh

EXPOSE 22

ENTRYPOINT ["tini", "--", "/usr/local/bin/init.sh"]
