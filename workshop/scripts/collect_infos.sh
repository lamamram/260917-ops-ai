#!/bin/bash

################################################################################
# collect_infos.sh
#
# Script pour collecter des informations sur un projet, detecter les fichiers
# sources, compter les lignes de code et identifier les technologies utilisees.
#
# Usage:
#   bash ./collect_infos.sh                                    # Utiliser la config .env
#   bash ./collect_infos.sh /path/to/project                   # Analyser un dossier
#   bash ./collect_infos.sh /path/to/project --extensions .py  # Limiter aux fichiers .py
#   bash ./collect_infos.sh /path/to/project -e .py,.java      # Utiliser -e pour les extensions
#   bash ./collect_infos.sh --help                              # Afficher l'aide
################################################################################

set -o pipefail

################################################################################
# Variables globales
################################################################################

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)" || {
    echo "Erreur: Impossible de determiner le repertoire du script" >&2
    exit 1
}

ENV_FILE="${SCRIPT_DIR}/.env"
TARGET_DIRECTORY="${TARGET_DIRECTORY:-.}"
EXTENSIONS="${EXTENSIONS:-.py,.js,.ts}"
SHOW_HELP=false

# Dossiers a ignorer
IGNORED_DIRS=(".git" "node_modules" ".venv" "venv" "__pycache__" "dist" "build" "coverage")

# Patterns de detection des technologies
declare -A TECH_PATTERNS=(
    ["FastAPI"]="from fastapi|import fastapi"
    ["Django"]="from django|import django"
    ["Flask"]="from flask|import flask"
    ["SQLAlchemy"]="from sqlalchemy|import sqlalchemy"
    ["Pandas"]="from pandas|import pandas|import pd"
    ["NumPy"]="from numpy|import numpy|import np"
    ["React"]="from react|import React|import.*from.*['\"]react['\"]"
    ["Vue"]="from vue|import Vue|import.*from.*['\"]vue['\"]"
    ["Angular"]="@angular|from.*angular|import.*angular"
    ["Express"]="express|from.*express|import.*express"
    ["Spring"]="org\.springframework|import.*springframework"
    ["Hibernate"]="org\.hibernate|import.*hibernate"
)


################################################################################
# Fonctions utilitaires
################################################################################

# Charge les variables d'environnement depuis le fichier .env
load_env_file() {
    local env_file=$1

    if [[ ! -f "$env_file" ]]; then
        return 0
    fi

    # Charger le fichier .env en ignorant les commentaires et les lignes vides
    while IFS='=' read -r key value || [[ -n "$key" ]]; do
        # Ignorer les commentaires et les lignes vides
        [[ "$key" =~ ^#.*$ ]] && continue
        [[ -z "$key" ]] && continue

        # Enlever les espaces avant/apres
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)

        # Ne pas ecraser les variables deja definies
        if [[ -n "$key" ]]; then
            export "$key=$value"
        fi
    done < "$env_file"
}

# Affiche le message d'aide
show_help() {
    cat << 'EOF'
Usage: bash collect_infos.sh [OPTIONS] [DIRECTORY]

Collecte d'informations sur un projet, analyse des fichiers sources et
detection des technologies utilisees.

OPTIONS:
    -e, --extensions EXT1,EXT2,...  Extensions a analyser (ex: .py,.js)
    -h, --help                      Affiche ce message d'aide

ARGUMENTS:
    DIRECTORY                       Repertoire a analyser (optionnel)
                                    Par defaut: valeur de TARGET_DIRECTORY dans .env

EXEMPLES:
    bash ./collect_infos.sh
    bash ./collect_infos.sh /chemin/vers/projet
    bash ./collect_infos.sh /chemin/vers/projet --extensions .py
    bash ./collect_infos.sh /chemin/vers/projet -e .py,.js

FICHIER DE CONFIGURATION:
    .env - Definit les valeurs par defaut:
        TARGET_DIRECTORY=.
        EXTENSIONS=.py,.js,.ts

Les arguments de ligne de commande prennent precedence sur les valeurs du .env.
EOF
}

# Valide qu'un repertoire existe et est accessible
validate_directory() {
    local dir=$1

    if [[ ! -d "$dir" ]]; then
        echo "Erreur: Le repertoire '$dir' n'existe pas" >&2
        return 1
    fi

    if [[ ! -r "$dir" ]]; then
        echo "Erreur: Le repertoire '$dir' n'est pas lisible" >&2
        return 1
    fi

    return 0
}

# Verifie si un repertoire doit etre ignore
should_ignore_dir() {
    local dir_name=$1
    local ignored_dir

    for ignored_dir in "${IGNORED_DIRS[@]}"; do
        if [[ "$dir_name" == "$ignored_dir" ]]; then
            return 0  # true - ignorer ce repertoire
        fi
    done

    return 1  # false - ne pas ignorer
}

# Normalise les extensions (ajoute un point si manquant, enleve les espaces)
normalize_extensions() {
    local ext_string=$1
    local -a extensions=()
    local ext

    # Diviser par virgule et traiter chaque extension
    IFS=',' read -ra ext_array <<< "$ext_string"

    for ext in "${ext_array[@]}"; do
        ext=$(echo "$ext" | xargs)  # Enlever espaces

        if [[ -z "$ext" ]]; then
            continue
        fi

        # Ajouter un point si absent
        if [[ "$ext" != .* ]]; then
            ext=".$ext"
        fi

        extensions+=("$ext")
    done

    # Retourner comme chaine jointe par des virgules
    (IFS=','; echo "${extensions[*]}")
}

# Construit un pattern find pour les extensions
build_find_extensions_pattern() {
    local extensions=$1
    local -a patterns=()
    local ext
    local first=true

    IFS=',' read -ra ext_array <<< "$extensions"

    for ext in "${ext_array[@]}"; do
        if [[ "$first" == true ]]; then
            patterns+=("(")
            first=false
        else
            patterns+=("-o")
        fi
        patterns+=("-name" "*${ext}")
    done

    patterns+=(")")

    echo "${patterns[@]}"
}

# Compte les fichiers dans un repertoire avec les extensions donnees
count_files() {
    local target_dir=$1
    local extensions=$2
    local count=0

    # Construire la commande find avec exclusion des dossiers ignores
    local -a find_cmd=("find" "$target_dir" "-type" "f")

    # Ajouter les exclusions de dossiers
    local ignored_dir
    for ignored_dir in "${IGNORED_DIRS[@]}"; do
        find_cmd+=("-not" "-path" "*/$ignored_dir/*")
    done

    # Ajouter le pattern d'extensions
    IFS=',' read -ra ext_array <<< "$extensions"
    find_cmd+=("(")
    local first=true
    for ext in "${ext_array[@]}"; do
        if [[ "$first" == false ]]; then
            find_cmd+=("-o")
        fi
        first=false
        find_cmd+=("-name" "*${ext}")
    done
    find_cmd+=(")")

    # Compter les fichiers
    count=$("${find_cmd[@]}" 2>/dev/null | wc -l)
    echo "$count"
}

# Compte le nombre total de fichiers examines (tous types)
count_total_files() {
    local target_dir=$1
    local count=0

    # Construire la commande find avec exclusion des dossiers ignores
    local -a find_cmd=("find" "$target_dir" "-type" "f")

    # Ajouter les exclusions de dossiers
    local ignored_dir
    for ignored_dir in "${IGNORED_DIRS[@]}"; do
        find_cmd+=("-not" "-path" "*/$ignored_dir/*")
    done

    # Compter tous les fichiers
    count=$("${find_cmd[@]}" 2>/dev/null | wc -l)
    echo "$count"
}

# Compte le nombre total de lignes dans les fichiers sources
count_lines() {
    local target_dir=$1
    local extensions=$2
    local count=0

    # Construire la commande find avec exclusion des dossiers ignores
    local -a find_cmd=("find" "$target_dir" "-type" "f")

    # Ajouter les exclusions de dossiers
    local ignored_dir
    for ignored_dir in "${IGNORED_DIRS[@]}"; do
        find_cmd+=("-not" "-path" "*/$ignored_dir/*")
    done

    # Ajouter le pattern d'extensions
    IFS=',' read -ra ext_array <<< "$extensions"
    find_cmd+=("(")
    local first=true
    for ext in "${ext_array[@]}"; do
        if [[ "$first" == false ]]; then
            find_cmd+=("-o")
        fi
        first=false
        find_cmd+=("-name" "*${ext}")
    done
    find_cmd+=(")")

    # Compter les lignes (utiliser -print0 pour xargs avec chemins contenant des espaces)
    count=$("${find_cmd[@]}" -print0 2>/dev/null | xargs -0 wc -l 2>/dev/null | tail -1 | awk '{print $1}')

    # Si aucun fichier trouve, retourner 0
    if [[ -z "$count" ]] || [[ "$count" == "total" ]]; then
        echo "0"
    else
        echo "$count"
    fi
}

# Liste tous les fichiers sources
list_source_files() {
    local target_dir=$1
    local extensions=$2

    # Construire la commande find avec exclusion des dossiers ignores
    local -a find_cmd=("find" "$target_dir" "-type" "f")

    # Ajouter les exclusions de dossiers
    local ignored_dir
    for ignored_dir in "${IGNORED_DIRS[@]}"; do
        find_cmd+=("-not" "-path" "*/$ignored_dir/*")
    done

    # Ajouter le pattern d'extensions
    IFS=',' read -ra ext_array <<< "$extensions"
    find_cmd+=("(")
    local first=true
    for ext in "${ext_array[@]}"; do
        if [[ "$first" == false ]]; then
            find_cmd+=("-o")
        fi
        first=false
        find_cmd+=("-name" "*${ext}")
    done
    find_cmd+=(")")

    # Lister et trier les fichiers
    "${find_cmd[@]}" 2>/dev/null | sort
}

# Detecte les technologies utilisees
detect_technologies() {
    local target_dir=$1
    local extensions=$2
    local -a source_files
    local -A detected_techs_temp
    local file tech pattern

    # Lire la liste des fichiers sources ligne par ligne
    while IFS= read -r file; do
        [[ -z "$file" ]] && continue

        # Parcourir les technologies connues
        for tech in "${!TECH_PATTERNS[@]}"; do
            pattern="${TECH_PATTERNS[$tech]}"

            # Chercher le pattern dans le fichier
            if grep -qEi "$pattern" "$file" 2>/dev/null; then
                # Utiliser un indice numerique pour stocker les fichiers par technologie
                if [[ -z "${detected_techs_temp[$tech]}" ]]; then
                    detected_techs_temp["$tech"]="$file"
                else
                    detected_techs_temp["$tech"]="${detected_techs_temp[$tech]}"$'\n'"$file"
                fi
            fi
        done
    done < <(list_source_files "$target_dir" "$extensions")

    # Afficher les technologies detectees
    if [[ ${#detected_techs_temp[@]} -gt 0 ]]; then
        # Trier les technologies par nom
        local -a sorted_techs=($(printf '%s\n' "${!detected_techs_temp[@]}" | sort))

        for tech in "${sorted_techs[@]}"; do
            local files="${detected_techs_temp[$tech]}"
            local file_count=0

            # Compter les fichiers uniques
            file_count=$(echo "$files" | sort -u | grep -c .)

            if [[ $file_count -eq 0 ]]; then
                file_count=1
            fi

            echo ""
            echo "[$tech] $file_count file(s)"

            # Afficher chaque fichier en retrait
            while IFS= read -r file; do
                [[ -n "$file" ]] && echo "  - $file"
            done < <(echo "$files" | sort -u)
        done
    fi
}

# Affiche un rapport resume
print_report() {
    local target_dir=$1
    local extensions=$2

    # Valider le repertoire
    if ! validate_directory "$target_dir"; then
        exit 1
    fi

    # Normaliser le chemin
    target_dir="$(cd "$target_dir" && pwd)" || {
        echo "Erreur: Impossible d'acceder au repertoire '$target_dir'" >&2
        exit 1
    }

    # Compter les fichiers et les lignes
    local total_files=$(count_total_files "$target_dir")
    local source_files=$(count_files "$target_dir" "$extensions")
    local total_lines=$(count_lines "$target_dir" "$extensions")

    # Afficher le rapport
    echo "Project information"
    echo "==================="
    echo "Directory: $target_dir"
    echo "Extensions: $extensions"
    echo "Files examined: $total_files"
    echo "Source files found: $source_files"
    echo "Source lines: $total_lines"
    echo ""
    echo "Detected technologies"
    echo "---------------------"

    # Detecter et afficher les technologies
    detect_technologies "$target_dir" "$extensions"
}

################################################################################
# Parsing des arguments
################################################################################

parse_arguments() {
    local -a positional_args=()

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -h|--help)
                SHOW_HELP=true
                shift
                ;;
            -e|--extensions)
                if [[ -z "$2" ]]; then
                    echo "Erreur: --extensions requiert une valeur" >&2
                    return 1
                fi
                EXTENSIONS="$2"
                shift 2
                ;;
            -*)
                echo "Erreur: Option inconnue: $1" >&2
                return 1
                ;;
            *)
                positional_args+=("$1")
                shift
                ;;
        esac
    done

    # Traiter les arguments positionnels
    if [[ ${#positional_args[@]} -gt 0 ]]; then
        TARGET_DIRECTORY="${positional_args[0]}"
    fi

    # Si plusieurs arguments positionnels, c'est une erreur
    if [[ ${#positional_args[@]} -gt 1 ]]; then
        echo "Erreur: Trop d'arguments positionnels" >&2
        return 1
    fi

    return 0
}

################################################################################
# Point d'entree principal
################################################################################

main() {
    # Charger les variables d'environnement depuis .env
    load_env_file "$ENV_FILE"

    # Parser les arguments
    if ! parse_arguments "$@"; then
        show_help
        exit 1
    fi

    # Afficher l'aide si demande
    if [[ "$SHOW_HELP" == true ]]; then
        show_help
        exit 0
    fi

    # Normaliser les extensions
    EXTENSIONS=$(normalize_extensions "$EXTENSIONS")

    # Afficher le rapport
    print_report "$TARGET_DIRECTORY" "$EXTENSIONS"
}

# Executer le programme principal
main "$@"
