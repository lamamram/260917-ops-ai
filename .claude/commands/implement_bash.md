---
allowed-tools: Write(*.sh), Skill
description: write a bash script with specified standards
model: haiku
argument-hint: [spec_name]
---

## Your task

- $1 is not specified, or `$1.md` doesn't exist in the specs, end this command
- read the spec with name `$1.md`
- delegate the implementation of this spec to @shell-scripting:bash-pro with usage of 
  + the bash-defensive-patterns skill
  + context7 mcp

- DO NOT test, tests are executed elsewhere.
- DO NOT execute quality analysis, thoses are executed elsewhere