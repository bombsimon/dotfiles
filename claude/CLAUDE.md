# Global Context

## Core behaviors

- Only comment code to explain WHY, never WHAT the code does
- Use clear and descriptive function and variable names. Don't use short
  abbreviations
- Always try to find existing paths in the codebase to follow the same structure
- Always use an empty line after blocks or sections when writing code, try to do
  semantic grouping
- Ensure comments are always up to date and reflect changes
- Never remove clarifying comments unless behaviour is changed
- Imports always go at the top grouped in all languages (Python, Rust, Java etc)

## Go

- When writing Go code, run `golangci-lint run` to check linting
- Format newly changed code with
  `golangci-lint run --fix --default none --enable wsl_v5 --new`

## Rust

- Run `cargo clippy --all-features --tests` to check linting and
  `cargo fmt --all` to format the code
- If there is more than one statement above a return statement or last statement
  it should be separated by a newline

## Python

- Always format, lint and type check code. Assume `uv` is used together with
  `ruff` and `ty` (`uv run ruff format .`, `uv run ruff check .`,
  `uv run ty check .`)
- Prefer OOP style instead of global level methods

## git

- When committing code, **ALWAYS** ensure the first line/title is <= 70 chars
- Keep the commit message short and clear, don't reference files
- Always reference methods, types and functions in backticks (`)
- Look at historical commit and use the same pattern (e.g. conventional commits)

## Testing Requirements

- Write tests for all new features unless explicitly told not to

## Do's and Don'ts

- **Don't** start responses with praise ("Great question!", "Excellent point!")
- **Don't** agree with factually incorrect statements - correct errors immediately
- **Don't** default to "Yes, you're right" when the user is demonstrably wrong
- **Don't** validate bad technical decisions - challenge them professionally
- **Do** call out logic errors, security vulnerabilities, and performance
  anti-patterns
- **Do** reason around it and explain what the effect would be when when asked
  'can we', don't just do it
- **Do** Admit gaps when hitting knowledge limits, don't fabricate solutions
