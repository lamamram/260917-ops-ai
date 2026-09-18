# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains utilities and administration scripts for workshop servers (collections, log rotations, etc.). The deliverables are bash scripts

**Language**: French (French documentation and comments expected)

## Project Goal

collect generic utilities to 
- gather information about a codebase
- manage logs and rotations

## structure

```text
workshop/
├── specs/
├── tests/
├── scripts/
├── reports/
├── fixtures/
├── .env
└── README.md
```

* the `specs/` directory contains the requirements and specifications for the workshop server scripts

* the `tests/` directory contains bats unit tests for the scripts

* the `scripts/` directory contains the bash scripts themselves

* the `reports/` directory contains test reports in JUnit format

* the `fixtures/` directory contains sample data for feeding bats unit tests

## Configuration

Settings are managed via `.env` file with command-line overrides:

```dotenv
TARGET_DIRECTORY=.
EXTENSIONS=.py,.js,.ts,.tsx,.jsx,.java,.go,.rb,.php,.cs,.sh
```

Configuration priority (highest to lowest):
1. Command-line arguments
2. `.env` file
3. Script defaults


### Environment Compatibility

- **Bash 4+** required (uses Bash-specific features)
- **Unix tools required**: `find`, `grep`, `wc`, `sed`
- **Windows**: Run via Git Bash or WSL

## Implementation Notes

### Ignored Directories

Always exclude these from scanning:
- `.git`, `node_modules`, `.venv`, `venv`, `__pycache__`, `dist`, `build`, `coverage`

### Technology Detection

Detection is intentionally simple, based on regex patterns in import statements. It's meant to illustrate initial information gathering, not comprehensive analysis.

Common frameworks to detect (add patterns as needed):
- Python: FastAPI, Django, Flask, Pandas, NumPy, etc.
- JavaScript/TypeScript: React, Vue, Angular, Express, etc.
- Java: Spring, Hibernate, etc.
- Go: standard library patterns, etc.

## Key Considerations

- **Error handling**: Graceful handling of missing directories, permission issues
- **Performance**: Should complete quickly even on large codebases
- **Portability**: Use POSIX-compatible Bash; test on both Linux and Windows (via Git Bash/WSL)
- **Clarity**: Output should be readable by humans and parseable by scripts
