#!/usr/bin/env bash

# Demonstration: collect source-file statistics and common technology usage.
# Usage: ./collect_project_info.sh [directory] [--extensions .py,.js,.ts]

set -euo pipefail

readonly DEFAULT_EXTENSIONS=".py,.js,.ts,.tsx,.jsx,.java,.go,.rb,.php,.cs,.sh"
readonly EXCLUDED_DIRECTORIES=(.git .svn .hg node_modules .venv venv __pycache__ dist build coverage)

load_environment() {
    local script_directory
    local env_file

    script_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    env_file="$script_directory/.env"

    if [[ -f "$env_file" ]]; then
        set -a
        source "$env_file"
        set +a
    fi
}

load_environment

TARGET_DIRECTORY="${TARGET_DIRECTORY:-.}"
EXTENSIONS="${EXTENSIONS:-$DEFAULT_EXTENSIONS}"

usage() {
    cat <<'EOF'
Usage: collect_project_info.sh [directory] [--extensions .py,.js,.ts]

Scans a directory recursively, lists matching source files, and identifies
technologies from their imports, dependencies, and configuration files.
EOF
}

die() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                usage
                exit 0
                ;;
            -e|--extensions)
                [[ $# -ge 2 ]] || die "--extensions expects a comma-separated value."
                EXTENSIONS="$2"
                shift 2
                ;;
            --extensions=*)
                EXTENSIONS="${1#*=}"
                shift
                ;;
            -*)
                die "Unknown option: $1"
                ;;
            *)
                [[ "$TARGET_DIRECTORY" == "." ]] || die "Only one target directory is allowed."
                TARGET_DIRECTORY="$1"
                shift
                ;;
        esac
    done
}

matches_extension() {
    local file_path="$1"
    local extension
    IFS=',' read -r -a extension_list <<< "$EXTENSIONS"

    for extension in "${extension_list[@]}"; do
        extension="${extension//[[:space:]]/}"
        [[ "$extension" == .* ]] || extension=".$extension"
        [[ "$file_path" == *"$extension" ]] && return 0
    done

    return 1
}

count_lines() {
    local file_path="$1"
    wc -l < "$file_path" | tr -d '[:space:]'
}

detect_technology() {
    local label="$1"
    local pattern="$2"
    shift 2
    local matched_files=()
    local file_path

    for file_path in "$@"; do
        if grep -Eqi -- "$pattern" "$file_path"; then
            matched_files+=("$file_path")
        fi
    done

    if [[ ${#matched_files[@]} -gt 0 ]]; then
        printf '\n[%s] %s file(s)\n' "$label" "${#matched_files[@]}"
        printf '%s\n' "${matched_files[@]}" | sed 's/^/  - /'
    fi
}

main() {
    parse_arguments "$@"
    [[ -d "$TARGET_DIRECTORY" ]] || die "Directory not found: $TARGET_DIRECTORY"

    TARGET_DIRECTORY="$(cd "$TARGET_DIRECTORY" && pwd)"
    local collector_script
    collector_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/$(basename "${BASH_SOURCE[0]}")"
    local find_arguments=("$TARGET_DIRECTORY" '(' -type d '(')
    local excluded_directory
    for excluded_directory in "${EXCLUDED_DIRECTORIES[@]}"; do
        find_arguments+=(-name "$excluded_directory" -o)
    done
    find_arguments+=(-false ')' -prune ')' -o -type f -print0)
    local all_files=()
    local detection_files=()
    local source_files=()
    local file_path
    local total_lines=0
    local file_lines

    while IFS= read -r -d '' file_path; do
        all_files+=("$file_path")
        if [[ "$file_path" != "$collector_script" ]]; then
            detection_files+=("$file_path")
        fi
        if matches_extension "$file_path"; then
            source_files+=("$file_path")
            file_lines="$(count_lines "$file_path")"
            total_lines=$((total_lines + file_lines))
        fi
    done < <(find "${find_arguments[@]}")

    printf 'Project information\n'
    printf '===================\n'
    printf 'Directory: %s\n' "$TARGET_DIRECTORY"
    printf 'Extensions: %s\n' "$EXTENSIONS"
    printf 'Files examined: %s\n' "${#all_files[@]}"
    printf 'Source files found: %s\n' "${#source_files[@]}"
    printf 'Source lines: %s\n' "$total_lines"

    if [[ ${#source_files[@]} -eq 0 ]]; then
        printf '\nNo source files match the requested extensions.\n'
        return
    fi

    printf '\nSource files\n------------\n'
    printf '%s\n' "${source_files[@]#$TARGET_DIRECTORY/}" | sort | sed 's/^/  - /'

    printf '\nDetected technologies\n---------------------\n'
    detect_technology "FastAPI" '(^|[^[:alnum:]_])fastapi([^[:alnum:]_]|$)|from[[:space:]]+fastapi[[:space:]]+import' "${detection_files[@]}"
    detect_technology "SQLAlchemy" '(^|[^[:alnum:]_])sqlalchemy([^[:alnum:]_]|$)|from[[:space:]]+sqlalchemy[[:space:]]+import' "${detection_files[@]}"
    detect_technology "Django" '(^|[^[:alnum:]_])django([^[:alnum:]_]|$)|from[[:space:]]+django[[:space:]]+import' "${detection_files[@]}"
    detect_technology "Flask" '(^|[^[:alnum:]_])flask([^[:alnum:]_]|$)|from[[:space:]]+flask[[:space:]]+import' "${detection_files[@]}"
    detect_technology "React" "from[[:space:]]+['\"]react['\"]|require\\(['\"]react['\"]\\)|react-dom" "${detection_files[@]}"
    detect_technology "Express" "from[[:space:]]+['\"]express['\"]|require\\(['\"]express['\"]\\)" "${detection_files[@]}"
    detect_technology "Spring" 'org\.springframework|spring-boot-starter' "${detection_files[@]}"
    detect_technology "Docker" 'FROM[[:space:]]+|docker-compose|services:' "${detection_files[@]}"
}

main "$@"