# Global Context

## Core behaviors

- Only comment code to explain WHY, never WHAT the code does
- Use clear and descriptive function and variable names. Don't use short
  abbreviations
- Always try to find existing paths in the codebase to follow the same structure
- Use semantic newlines in new code you fully own (a new function, block, or
  file - e.g. a file written from scratch): always a blank line after a
  block (if/for/while/try/etc.) before the next statement, and always a
  blank line before a `return` when two or more plain statements (not
  counting a preceding block, already covered above) come directly before
  it - one statement then `return` needs no blank line. Don't retrofit
  this onto existing code you're only editing in part - match that file's
  existing style there instead
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
- **NEVER** `git push` or create a pull request (`gh pr create`) without being
  explicitly asked to do so in that specific instance. This is a hard rule,
  no exceptions - committing locally does not imply permission to push or
  open a PR

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
