import json
import sys


def main() -> None:
    source_path, target_path = sys.argv[1:]

    with open(source_path, encoding="utf-8") as source_file:
        configuration = json.load(source_file)

    configuration.get("mcpServers", {}).pop("mcp-docker", None)
    with open(target_path, "w", encoding="utf-8") as target_file:
        json.dump(configuration, target_file)


if __name__ == "__main__":
    main()