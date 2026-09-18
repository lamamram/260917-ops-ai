---
allowed-tools: Write(*.sh), Skill
disallowed-tools: Bash(bats *), Bash(shellcheck *)
description: write a bash script its bats tests with specified standards
model: haiku
argument-hint: [spec_name]
---

## Your task

- $1 is not specified, or `$1.md` doesn't exist in the specs, end this command
- read the spec with name `$1.md`
- delegate the implementation of bats tests using fixtures and then the script of this spec to @shell-scripting:bash-pro with usage of 
  + the bash-defensive-patterns skill
  + bats-testing-patterns skill
  + context7 mcp

- DO NOT execute tests, tests are executed elsewhere.
- DO NOT execute quality analysis, thoses are executed elsewhere