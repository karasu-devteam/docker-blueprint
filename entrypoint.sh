#!/bin/bash
set -e

PORT=${PORT:-22}

if [ -n "$PASSWD" ]; then
    echo "root:$PASSWD" | chpasswd
fi

if [ -n "$SSH_KEY" ]; then
    mkdir -p /root/.ssh
    chmod 700 /root/.ssh
    echo "$SSH_KEY" >> /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

sed -i "s/^#\?Port .*/Port $PORT/" /etc/ssh/sshd_config
sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?KbdInteractiveAuthentication.*/KbdInteractiveAuthentication yes/' /etc/ssh/sshd_config

if [ "$INSTALL_PYTHON" = "true" ]; then
    apt-get update -y && apt-get install -y --no-install-recommends \
    python3 \
    python3-pip \
    python3-venv
fi

if [ "$INSTALL_NODE" = "true" ]; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get install -y --no-install-recommends \
    nodejs
fi

apt-get clean && rm -rf /var/lib/apt/lists/*
ssh-keygen -A
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
