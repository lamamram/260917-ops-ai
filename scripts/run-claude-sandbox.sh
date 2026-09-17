#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
repository_root="$(cd -- "$script_dir/.." && pwd -P)"
sandbox_name="claude-admin-lab"
workspace_path="$repository_root"
kit_path="$repository_root/kit"
plugin_root="${HOME}/.claude/plugins"
plugin_inventory_path="${plugin_root}/installed_plugins.json"
dry_run=false
declare -a claude_arguments=()

usage() {
    cat <<'EOF'
Usage: run-claude-sandbox.sh [options] [-- CLAUDE_ARGUMENT...]

Options:
  -n, --name NAME        Sandbox name (default: claude-admin-lab)
  -w, --workspace PATH   Workspace to expose to Claude Code
  -k, --kit PATH         sbx kit directory (default: ../kit)
  -p, --plugins PATH     Claude Code plugin cache (default: ~/.claude/plugins)
      --dry-run          Print the sbx command without starting a sandbox
  -h, --help             Show this help
EOF
}

while (($#)); do
    case "$1" in
        -n|--name)
            sandbox_name="$2"
            shift 2
            ;;
        -w|--workspace)
            workspace_path="$2"
            shift 2
            ;;
        -k|--kit)
            kit_path="$2"
            shift 2
            ;;
        -p|--plugins)
            plugin_root="$2"
            plugin_inventory_path="${plugin_root}/installed_plugins.json"
            shift 2
            ;;
        --dry-run)
            dry_run=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            shift
            claude_arguments=("$@")
            break
            ;;
        *)
            printf 'Unknown option: %s\n' "$1" >&2
            usage >&2
            exit 2
            ;;
    esac
done

workspace_path="$(realpath -- "$workspace_path")"
kit_path="$(realpath -- "$kit_path")"
plugin_root="$(realpath -- "$plugin_root")"

if [[ ! -f "$plugin_inventory_path" ]]; then
    printf 'Claude Code plugin inventory not found: %s\n' "$plugin_inventory_path" >&2
    exit 1
fi

mapfile -t plugin_directories < <(
    python3 - "$plugin_inventory_path" "$plugin_root" <<'PY'
import json
import os
import sys

inventory_path, plugin_root = sys.argv[1:]
plugin_root = os.path.realpath(plugin_root)

with open(inventory_path, encoding="utf-8") as inventory_file:
    inventory = json.load(inventory_file)

directories = set()
for name, installations in inventory.get("plugins", {}).items():
    for installation in installations:
        if installation.get("scope") != "user":
            continue

        install_path = os.path.realpath(installation["installPath"])
        if os.path.commonpath((plugin_root, install_path)) != plugin_root:
            raise SystemExit(
                f"Plugin {name} is outside the mounted plugin cache: {install_path}"
            )
        if not os.path.isdir(install_path):
            raise SystemExit(f"Plugin {name} is missing: {install_path}")
        directories.add(install_path)

for directory in sorted(directories):
    print(directory)
PY
)

if ((${#plugin_directories[@]} == 0)); then
    printf 'No user-scope Claude Code plugins were found in the inventory.\n' >&2
    exit 1
fi

declare -a plugin_arguments=()
for plugin_directory in "${plugin_directories[@]}"; do
    plugin_arguments+=(--plugin-dir "$plugin_directory")
done

run_arguments=(
    run
    claude
    --name "$sandbox_name"
    --kit "$kit_path"
    "$workspace_path"
    "${plugin_root}:ro"
    --
    "${plugin_arguments[@]}"
    "${claude_arguments[@]}"
)

printf 'Loading %d user-scope Claude Code plugin(s) from %s\n' \
    "${#plugin_directories[@]}" "$plugin_root"

if "$dry_run"; then
    printf 'sbx'
    printf ' %q' "${run_arguments[@]}"
    printf '\n'
else
    sbx "${run_arguments[@]}"
fi