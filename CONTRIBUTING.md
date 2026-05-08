# Contribution guide

Thank you for your interest in this project! This document contains the coding conventions and commit message guidelines used in this repository.

## Coding conventions

## Functions & variables

- Use **camelCase**.
- Applies to:
  - Local functions
  - Local variables
  - Exported functions
  - Exported variables

**Example:**

```luau
local myVar = 1

local function greatFunction()
end
```

### Module exports

When exporting functions and variables from a module, use local definitions, and return a newly created table from the module.

**Example:**

```luau
local function exportedFunction() end

return {
    exportedFunction = exportedFunction
}
```

**Exception:**

An exception is made if you need to preserve some state in the modul, that should be accessible to other modules.

In this case, only store the exported values in the table, the rest can be defined locally.

```luau
local Module = {}

Module.someValue = 0

return Module
```

### Constants

- Use **UPPER_SNAKE_CASE**

**Example:**

```luau
local VERY_IMPORTANT_VALUE = 100
```

### File names

- Use **snake_case**.

### File imports

- Use **PascalCase**.

**Example:**

```luau
local OtherModule = require("./other_module")
```

## Commit message conventions

This project follows the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) style.

Try to commit your work in small chunks, with descriptive and clear names.

**Examples:**

```
feat: add datastore call retries on failure
```

```
fix: fix `Collection:Update()` delaying after being aborted
```

```
chore: update package version
```

```
refactor: reorder variables
```

```
style: fix indentation
```

```
docs: update README.md
```

## Pull request guidelines

> **IMPORTANT:** Pull requests will be declined if the commit message conventions were not followed.

- Include a clear description of changes.
- Reference related issues (if applicable).
- Ensure your code follows the conventions above.
- Test your changes before submitting.

## Pull request checklist

- [ ] All tests are passing
- [ ] Changes tested manually
- [ ] Tests are updated according to your changes
- [ ] Code follows the conventions mentioned above
- [ ] Code is formatted using StyLua
- [ ] Commit messages follow the conventions mentioned above
