import json
import os
import sys


def main() -> None:
    inventory_path, plugin_root = sys.argv[1:]

    with open(inventory_path, encoding="utf-8") as inventory_file:
        inventory = json.load(inventory_file)

    plugin_directories = set()
    for plugin_id, installations in inventory.get("plugins", {}).items():
        plugin_name, marketplace = plugin_id.rsplit("@", 1)
        for installation in installations:
            if installation.get("scope") != "user":
                continue

            plugin_path = os.path.join(
                plugin_root,
                "cache",
                marketplace,
                plugin_name,
                installation["version"],
            )
            if not os.path.isdir(plugin_path):
                raise SystemExit(f"Plugin cache is missing: {plugin_path}")
            plugin_directories.add(plugin_path)

    for plugin_path in sorted(plugin_directories):
        print(plugin_path)


if __name__ == "__main__":
    main()