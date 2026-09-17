#!/usr/bin/env sh
set -eu

cat /ssh-keys/id_ed25519.pub > /home/sandbox/.ssh/authorized_keys
chmod 700 /home/sandbox/.ssh
chmod 600 /home/sandbox/.ssh/authorized_keys
chown -R sandbox:sandbox /home/sandbox/.ssh

exec /usr/sbin/sshd -D -e -p 2222