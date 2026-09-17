FROM debian:13-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends openssh-server python3 sudo \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --uid 1000 --create-home --shell /bin/bash sandbox \
    && echo 'sandbox ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/sandbox \
    && chmod 0440 /etc/sudoers.d/sandbox \
    && mkdir -p /run/sshd /home/sandbox/.ssh

COPY entrypoint.sh /usr/local/bin/target-entrypoint
RUN chmod 0755 /usr/local/bin/target-entrypoint

EXPOSE 2222
ENTRYPOINT ["/usr/local/bin/target-entrypoint"]