---
allowed-tools: Write(reports/*.xml), Write(reports/*.json) Skill
disallowed-tools: Write(*.sh)
description: write a bash script its bats tests with specified standards
model: haiku
argument-hint: [spec_name]
---

## Your task

2 asynchronous substasks:
  - delegate the execution of bats tests and writing the report in JUnit format to @bash-tester using:
    + bats-testing-patterns skill
    + context7 mcp

  - delegate the execution of shellcheck and writing the report in json format to @bash-quality using:
    + shellcheck-configuration skill
    + context7 mcp