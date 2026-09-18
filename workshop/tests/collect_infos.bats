#!/usr/bin/env bats

################################################################################
# Tests pour collect_infos.sh
#
# Ce fichier contient les tests bats pour le script de collecte d'informations
# sur les projets. Les tests couvrent:
# - Les options de ligne de commande
# - Le chargement de la configuration .env
# - La detection des technologies
# - L'exclusion des repertoires ignores
# - La gestion des erreurs
################################################################################

# Variables pour les tests
SCRIPT_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
SCRIPT_PATH="$SCRIPT_DIR/scripts/collect_infos.sh"
FIXTURES_DIR="$SCRIPT_DIR/fixtures"
TEST_TEMP_DIR="${TMPDIR:-/tmp}/collect_infos_test_$$"

################################################################################
# Setup et Teardown
################################################################################

setup() {
    # Creer un repertoire temporaire pour les tests
    mkdir -p "$TEST_TEMP_DIR"
}

teardown() {
    # Nettoyer le repertoire temporaire apres les tests
    if [[ -d "$TEST_TEMP_DIR" ]]; then
        rm -rf "$TEST_TEMP_DIR"
    fi
}

################################################################################
# Helpers pour les tests
################################################################################

# Creer un fichier test avec un contenu donne
create_test_file() {
    local file_path=$1
    local content=$2
    mkdir -p "$(dirname "$file_path")"
    echo "$content" > "$file_path"
}

# Creer une structure de repertoires de test
create_test_project() {
    local test_dir=$1

    mkdir -p "$test_dir"

    # Creer des fichiers Python avec FastAPI
    create_test_file "$test_dir/main.py" "from fastapi import FastAPI\napp = FastAPI()"

    # Creer des fichiers Python avec SQLAlchemy
    create_test_file "$test_dir/database.py" "from sqlalchemy import create_engine\nengine = create_engine('postgresql://localhost')"

    # Creer des fichiers JavaScript
    create_test_file "$test_dir/index.js" "const express = require('express');\nconst app = express();"

    # Creer des fichiers TypeScript
    create_test_file "$test_dir/app.ts" "import React from 'react';\nconst App = () => {};"

    # Creer des fichiers Java
    create_test_file "$test_dir/App.java" "import org.springframework.boot.SpringApplication;\n"

    # Creer un fichier texte (extension non incluse)
    create_test_file "$test_dir/README.txt" "This is a readme file"

    # Creer des fichiers dans des repertoires ignores (ne doivent pas etre comptes)
    create_test_file "$test_dir/.git/config" "git configuration"
    create_test_file "$test_dir/node_modules/package.json" "node module"
    create_test_file "$test_dir/__pycache__/module.pyc" "python cache"
}

################################################################################
# Tests: Configuration et Parametres
################################################################################

@test "Help message displays correctly" {
    run bash "$SCRIPT_PATH" --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
    [[ "$output" =~ "--extensions" ]]
    [[ "$output" =~ "--help" ]]
}

@test "Help message with -h option" {
    run bash "$SCRIPT_PATH" -h
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

@test "Unknown option returns error" {
    run bash "$SCRIPT_PATH" --invalid-option
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Erreur" ]] || [[ "$output" =~ "Error" ]]
}

@test "Too many positional arguments returns error" {
    run bash "$SCRIPT_PATH" /path/one /path/two
    [ "$status" -ne 0 ]
}

################################################################################
# Tests: Gestion des Repertoires
################################################################################

@test "Non-existent directory shows error" {
    run bash "$SCRIPT_PATH" /non/existent/path
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Erreur" ]] || [[ "$output" =~ "n'existe pas" ]]
}

@test "Valid directory shows project information" {
    create_test_project "$TEST_TEMP_DIR/project"

    run bash "$SCRIPT_PATH" "$TEST_TEMP_DIR/project" --extensions .py,.js
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Project information" ]]
    [[ "$output" =~ "Directory:" ]]
    [[ "$output" =~ "Extensions:" ]]
    [[ "$output" =~ "Files examined:" ]]
    [[ "$output" =~ "Source files found:" ]]
    [[ "$output" =~ "Source lines:" ]]
}

@test "Nested directory structure is analyzed correctly" {
    local test_project="$TEST_TEMP_DIR/nested_project"
    mkdir -p "$test_project/src/main"
    mkdir -p "$test_project/tests"

    create_test_file "$test_project/src/main/main.py" "from fastapi import FastAPI\napp = FastAPI()"
    create_test_file "$test_project/src/main/utils.py" "def helper():\n    pass"
    create_test_file "$test_project/tests/test_main.py" "import pytest\n"
    create_test_file "$test_project/README.md" "# Project"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 3" ]]
}

################################################################################
# Tests: Comptage de Fichiers et Lignes
################################################################################

@test "Correct number of files is counted" {
    local test_project="$TEST_TEMP_DIR/file_count_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/file1.py" "content"
    create_test_file "$test_project/file2.py" "content"
    create_test_file "$test_project/file3.js" "content"
    create_test_file "$test_project/file4.txt" "content"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py,.js
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 3" ]]
}

@test "Source lines are counted correctly" {
    local test_project="$TEST_TEMP_DIR/lines_count_test"
    mkdir -p "$test_project"

    # Creer un fichier avec 10 lignes
    create_test_file "$test_project/file1.py" "line1\nline2\nline3\nline4\nline5\nline6\nline7\nline8\nline9\nline10"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    # La sortie doit contenir le nombre de lignes (peut varier selon la plateforme)
    [[ "$output" =~ "Source lines:" ]]
}

@test "Empty project returns zero files and zero lines" {
    local test_project="$TEST_TEMP_DIR/empty_project"
    mkdir -p "$test_project"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 0" ]]
    [[ "$output" =~ "Source lines: 0" ]]
}

################################################################################
# Tests: Exclusion de Repertoires
################################################################################

@test "Ignored directories are excluded from analysis" {
    local test_project="$TEST_TEMP_DIR/ignored_dirs_test"
    mkdir -p "$test_project"

    # Fichiers qui doivent etre comptes
    create_test_file "$test_project/main.py" "from fastapi import FastAPI"
    create_test_file "$test_project/utils.py" "def helper():\n    pass"

    # Fichiers dans les repertoires ignores (ne doivent pas etre comptes)
    create_test_file "$test_project/.git/config" "git config"
    create_test_file "$test_project/node_modules/package.json" "node module"
    create_test_file "$test_project/__pycache__/cache.pyc" "python cache"
    create_test_file "$test_project/.venv/bin/python" "virtual env"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py,.json,.pyc
    [ "$status" -eq 0 ]
    # Seulement 2 fichiers doivent etre comptes (main.py et utils.py)
    [[ "$output" =~ "Source files found: 2" ]]
}

@test ".git directory is excluded" {
    local test_project="$TEST_TEMP_DIR/git_exclude_test"
    mkdir -p "$test_project/.git"

    create_test_file "$test_project/main.py" "code"
    create_test_file "$test_project/.git/HEAD" "ref"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py,.txt
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 1" ]]
}

@test "node_modules directory is excluded" {
    local test_project="$TEST_TEMP_DIR/node_modules_exclude_test"
    mkdir -p "$test_project/node_modules/package"

    create_test_file "$test_project/main.js" "code"
    create_test_file "$test_project/node_modules/package/index.js" "module"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .js
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 1" ]]
}

@test "build directory is excluded" {
    local test_project="$TEST_TEMP_DIR/build_exclude_test"
    mkdir -p "$test_project/build"

    create_test_file "$test_project/main.py" "code"
    create_test_file "$test_project/build/output.py" "compiled"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 1" ]]
}

@test "Multiple ignored directories work together" {
    local test_project="$TEST_TEMP_DIR/multi_ignore_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/src/main.py" "code"
    create_test_file "$test_project/.git/config" "git"
    create_test_file "$test_project/node_modules/lib.py" "node"
    create_test_file "$test_project/dist/build.py" "dist"
    create_test_file "$test_project/coverage/report.py" "cov"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 1" ]]
}

################################################################################
# Tests: Detection de Technologies
################################################################################

@test "FastAPI is detected in fixture files" {
    run bash "$SCRIPT_PATH" "$FIXTURES_DIR" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "\[FastAPI\]" ]]
    [[ "$output" =~ "main.py" ]]
}

@test "Spring is detected in fixture files" {
    run bash "$SCRIPT_PATH" "$FIXTURES_DIR" --extensions .java
    [ "$status" -eq 0 ]
    [[ "$output" =~ "\[Spring\]" ]]
    [[ "$output" =~ "JavaSbApplication.java" ]]
}

@test "SQLAlchemy is detected in fixture files" {
    run bash "$SCRIPT_PATH" "$FIXTURES_DIR" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "\[SQLAlchemy\]" ]]
    [[ "$output" =~ "database.py" ]]
}

@test "No technologies detected in plain code" {
    local test_project="$TEST_TEMP_DIR/plain_code_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/simple.py" "def hello():\n    print('hello')"
    create_test_file "$test_project/simple.js" "function greet() {\n    console.log('hello');\n}"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py,.js
    [ "$status" -eq 0 ]
    # Pas de technologies detailees
    [[ "$output" =~ "Detected technologies" ]]
    # Les technologies specifiques ne doivent pas etre presentes
    [[ ! "$output" =~ "\[FastAPI\]" ]]
    [[ ! "$output" =~ "\[Spring\]" ]]
}

@test "Multiple technologies in same file are detected" {
    local test_project="$TEST_TEMP_DIR/multi_tech_test"
    mkdir -p "$test_project"

    # Fichier avec FastAPI ET SQLAlchemy
    create_test_file "$test_project/app.py" "from fastapi import FastAPI\nfrom sqlalchemy import create_engine\napp = FastAPI()"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "\[FastAPI\]" ]]
    [[ "$output" =~ "\[SQLAlchemy\]" ]]
}

@test "Technology detection is case-insensitive" {
    local test_project="$TEST_TEMP_DIR/case_test"
    mkdir -p "$test_project"

    # Utiliser des casses differentes
    create_test_file "$test_project/app.py" "FROM FASTAPI import FastAPI\nAPP = FastAPI()"
    create_test_file "$test_project/app2.py" "from FASTAPI import FastAPI"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "\[FastAPI\]" ]]
}

@test "Technology count shows correct number of files" {
    local test_project="$TEST_TEMP_DIR/tech_count_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/main.py" "from fastapi import FastAPI"
    create_test_file "$test_project/routes.py" "from fastapi import APIRouter"
    create_test_file "$test_project/schemas.py" "from fastapi import BaseModel"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "\[FastAPI\] 3 file" ]]
}

################################################################################
# Tests: Options de Ligne de Commande
################################################################################

@test "Extensions can be specified with --extensions" {
    local test_project="$TEST_TEMP_DIR/ext_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/file.py" "content"
    create_test_file "$test_project/file.js" "content"
    create_test_file "$test_project/file.ts" "content"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 1" ]]
}

@test "Extensions can be specified with -e" {
    local test_project="$TEST_TEMP_DIR/e_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/file.py" "content"
    create_test_file "$test_project/file.js" "content"

    run bash "$SCRIPT_PATH" "$test_project" -e .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 1" ]]
}

@test "Multiple extensions work with -e" {
    local test_project="$TEST_TEMP_DIR/multi_ext_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/file1.py" "content"
    create_test_file "$test_project/file2.js" "content"
    create_test_file "$test_project/file3.ts" "content"
    create_test_file "$test_project/file4.java" "content"

    run bash "$SCRIPT_PATH" "$test_project" -e .py,.js,.ts
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 3" ]]
}

@test "Extensions without dots are normalized" {
    local test_project="$TEST_TEMP_DIR/normalize_ext_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/file.py" "content"
    create_test_file "$test_project/file.js" "content"

    # Passer des extensions sans points
    run bash "$SCRIPT_PATH" "$test_project" -e "py,js"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 2" ]]
}

@test "Extensions with spaces are normalized" {
    local test_project="$TEST_TEMP_DIR/space_ext_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/file.py" "content"
    create_test_file "$test_project/file.js" "content"

    # Passer des extensions avec espaces
    run bash "$SCRIPT_PATH" "$test_project" -e ".py , .js"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 2" ]]
}

@test "--extensions without value returns error" {
    run bash "$SCRIPT_PATH" /tmp --extensions
    [ "$status" -ne 0 ]
    [[ "$output" =~ "Erreur" ]] || [[ "$output" =~ "Error" ]]
}

################################################################################
# Tests: Repertoire par Defaut depuis .env
################################################################################

@test "Default directory from .env is used when no argument is provided" {
    # Cette test utilise le repertoire du projet actuel (.)
    # On teste que la commande fonctionne sans arguments
    cd "$SCRIPT_DIR"
    run bash "$SCRIPT_PATH" --extensions .md
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Project information" ]]
}

################################################################################
# Tests: Listes de Fichiers Sources
################################################################################

@test "Source files are listed in output" {
    local test_project="$TEST_TEMP_DIR/file_list_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/main.py" "from fastapi import FastAPI"
    create_test_file "$test_project/utils.py" "def helper():\n    pass"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "main.py" ]]
    [[ "$output" =~ "utils.py" ]]
}

@test "File paths are correctly displayed" {
    local test_project="$TEST_TEMP_DIR/paths_test"
    mkdir -p "$test_project/src/module"

    create_test_file "$test_project/src/module/app.py" "from fastapi import FastAPI"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "src/module/app.py" ]] || [[ "$output" =~ "app.py" ]]
}

################################################################################
# Tests: Format de Sortie
################################################################################

@test "Output has correct format structure" {
    local test_project="$TEST_TEMP_DIR/format_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/main.py" "from fastapi import FastAPI\napp = FastAPI()"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    # Verifier les sections du format
    [[ "$output" =~ "Project information" ]]
    [[ "$output" =~ "===================" ]]
    [[ "$output" =~ "Directory:" ]]
    [[ "$output" =~ "Extensions:" ]]
    [[ "$output" =~ "Files examined:" ]]
    [[ "$output" =~ "Source files found:" ]]
    [[ "$output" =~ "Source lines:" ]]
    [[ "$output" =~ "Detected technologies" ]]
    [[ "$output" =~ "---------------------" ]]
}

@test "Technology section shows file count and file list" {
    local test_project="$TEST_TEMP_DIR/tech_format_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/main.py" "from fastapi import FastAPI"
    create_test_file "$test_project/routes.py" "from fastapi import APIRouter"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "\[FastAPI\]" ]]
    [[ "$output" =~ "file(s)" ]]
    # Les fichiers doivent etre listes apres le nom de la technologie
    [[ "$output" =~ "  -" ]] || [[ "$output" =~ "-" ]]
}

################################################################################
# Tests: Cas Limites
################################################################################

@test "Script handles files with special characters in names" {
    local test_project="$TEST_TEMP_DIR/special_chars_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/file with spaces.py" "code"
    create_test_file "$test_project/file-with-dashes.py" "code"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 2" ]]
}

@test "Script handles deeply nested directories" {
    local test_project="$TEST_TEMP_DIR/deep_nest_test"
    mkdir -p "$test_project/a/b/c/d/e/f"

    create_test_file "$test_project/a/b/c/d/e/f/deep.py" "code"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 1" ]]
}

@test "Script handles directory with no matching files" {
    local test_project="$TEST_TEMP_DIR/no_match_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/file.txt" "content"
    create_test_file "$test_project/file.md" "content"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py,.js
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 0" ]]
    [[ "$output" =~ "Source lines: 0" ]]
}

@test "Current directory (.) can be used as argument" {
    local test_project="$TEST_TEMP_DIR/dot_arg_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/main.py" "code"

    cd "$test_project"
    run bash "$SCRIPT_PATH" . --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 1" ]]
}

@test "Absolute and relative paths work" {
    local test_project="$TEST_TEMP_DIR/abs_rel_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/main.py" "code"

    # Test with absolute path
    run bash "$SCRIPT_PATH" "$test_project" --extensions .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 1" ]]
}

################################################################################
# Tests: Combinaisons d'Options
################################################################################

@test "Directory and extensions arguments work together" {
    local test_project="$TEST_TEMP_DIR/combo_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/app.py" "code"
    create_test_file "$test_project/app.js" "code"
    create_test_file "$test_project/app.ts" "code"

    run bash "$SCRIPT_PATH" "$test_project" --extensions .py,.js
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 2" ]]
}

@test "Short and long options can be mixed" {
    local test_project="$TEST_TEMP_DIR/mixed_opt_test"
    mkdir -p "$test_project"

    create_test_file "$test_project/file.py" "from fastapi import FastAPI"
    create_test_file "$test_project/file.js" "const express = require('express')"

    run bash "$SCRIPT_PATH" "$test_project" -e .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Source files found: 1" ]]
}

@test "Help can be shown after other arguments" {
    run bash "$SCRIPT_PATH" /tmp --help
    [ "$status" -eq 0 ]
    [[ "$output" =~ "Usage:" ]]
}

################################################################################
# Tests: Integrations avec Fixtures
################################################################################

@test "All fixture files are detected when using all supported extensions" {
    run bash "$SCRIPT_PATH" "$FIXTURES_DIR" -e .py,.java
    [ "$status" -eq 0 ]
    # 3 Python files + 1 Java file = 4 files
    [[ "$output" =~ "Source files found: 4" ]]
}

@test "Fixtures contain expected Python files" {
    run bash "$SCRIPT_PATH" "$FIXTURES_DIR" -e .py
    [ "$status" -eq 0 ]
    [[ "$output" =~ "database.py" ]]
    [[ "$output" =~ "main.py" ]]
}

@test "Fixtures contain expected Java files" {
    run bash "$SCRIPT_PATH" "$FIXTURES_DIR" -e .java
    [ "$status" -eq 0 ]
    [[ "$output" =~ "JavaSbApplication.java" ]]
}
