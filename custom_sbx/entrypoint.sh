#!/usr/bin/env bash

set -euo pipefail

export HOME=/home/agent
plugin_root="${HOME}/.claude/plugins"
plugin_inventory_path="${plugin_root}/installed_plugins.json"
declare -a plugin_arguments=()
declare -a mcp_arguments=()

if [[ -f "$plugin_inventory_path" ]]; then
	mapfile -t plugin_directories < <(
		python3 /usr/local/lib/claude-compose/load-plugins.py \
			"$plugin_inventory_path" "$plugin_root"
	)

	for plugin_directory in "${plugin_directories[@]}"; do
		plugin_arguments+=(--plugin-dir "$plugin_directory")
	done
fi

if [[ -f /workspace/.mcp.json ]]; then
	compose_mcp_config=/tmp/claude-compose-mcp.json
	python3 /usr/local/lib/claude-compose/without-mcp-docker.py \
		/workspace/.mcp.json "$compose_mcp_config"
	mcp_arguments=(--strict-mcp-config --mcp-config "$compose_mcp_config")
fi

if [[ "$(id -u)" == "0" ]]; then
	mkdir -p /home/agent/.claude /home/agent/.ssh
	chown agent:agent /home/agent /home/agent/.claude /home/agent/.ssh
	exec runuser -u agent -- claude "${mcp_arguments[@]}" "${plugin_arguments[@]}" "$@"
fi

exec claude "${mcp_arguments[@]}" "${plugin_arguments[@]}" "$@"

