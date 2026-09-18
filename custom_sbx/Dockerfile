FROM node:22-bookworm

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		ansible \
		ca-certificates \
		git \
		openssh-client \
		python3 \
		python3-pip \
		python3-venv \
		util-linux \
		shellcheck \
		bats \
	&& rm -rf /var/lib/apt/lists/* \
	&& npm install -g @anthropic-ai/claude-code \
	&& curl --proto '=https' --tlsv1.2 -LsSf https://astral.sh/uv/install.sh | sh \
	&& install -m 0755 /root/.local/bin/uv /usr/local/bin/uv \
	&& install -m 0755 /root/.local/bin/uvx /usr/local/bin/uvx \
	&& useradd --uid 1000 --create-home --shell /bin/bash agent

COPY entrypoint.sh /usr/local/bin/claude-compose-entrypoint
COPY load-plugins.py /usr/local/lib/claude-compose/load-plugins.py
COPY without-mcp-docker.py /usr/local/lib/claude-compose/without-mcp-docker.py
RUN chmod 0755 /usr/local/bin/claude-compose-entrypoint

WORKDIR /workspace
ENTRYPOINT ["/usr/local/bin/claude-compose-entrypoint"]
