#!/usr/bin/env sh
set -eu

key_dir=/ssh-keys
if [ ! -f "$key_dir/id_ed25519" ]; then
    ssh-keygen -q -t ed25519 -N '' -f "$key_dir/id_ed25519"
fi

mkdir -p /run/sshd /home/sandbox/.ssh
chown 1000:1000 "$key_dir/id_ed25519" "$key_dir/id_ed25519.pub"
cat "$key_dir/id_ed25519.pub" > /home/sandbox/.ssh/authorized_keys
chmod 700 /home/sandbox/.ssh
chmod 600 /home/sandbox/.ssh/authorized_keys
chown -R sandbox:sandbox /home/sandbox/.ssh

exec /usr/sbin/sshd -D -e -p 2222