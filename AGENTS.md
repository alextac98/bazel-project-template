# AGENTS.md - AI Coding Agent Guidelines

This document provides guidelines for AI coding agents working in this repository.

## Project Overview

This is a **hermetic Bazel polyglot repository** for cross-compilation builds:
- **C++**: C++20 standard, LLVM/Clang 19.1.0 toolchain
- **Rust**: Edition 2024, version 1.85.0
- **Python**: Version 3.12

Build system: **Bazel 8.5.0** with Bzlmod module system.

## Build Commands

```bash
# Build all targets
bazel build //...

# Build specific targets
bazel build //examples/cpp:hello_cpp
bazel build //examples/rust:hello_rust
bazel build //examples/python:hello_python

# Run targets
bazel run //examples/cpp:hello_cpp
bazel run //examples/rust:hello_rust
bazel run //examples/python:hello_python

# Cross-compilation
bazel build --config=linux-x86_64 //...    # Linux x86_64
bazel build --config=linux-aarch64 //...   # Linux ARM64
bazel build --config=macos-aarch64 //...   # macOS Apple Silicon
```

## Test Commands

```bash
# Run all tests
bazel test //...

# Run a single test
bazel test //path/to:test_target

# Run with verbose output
bazel test --test_output=all //path/to:test_target

# Run all tests under a package
bazel test //path/to/...
```

## Lint & Format Commands

This repository uses `aspect_rules_lint` for Bazel-native linting and formatting.

### Formatting

```bash
# Format all files in the repository
bazel run //:format

# Format specific file(s)
bazel run //:format -- path/to/file.py path/to/other.cc

# Check formatting without applying changes (for CI)
bazel run //bazel/format:format.check
```

### Linting

```bash
# Lint all targets (warnings only)
bazel build --config=lint //...

# Lint specific package
bazel build --config=lint //examples/cpp/...

# Lint with failure on violations (for CI pipelines)
bazel build --config=lint-strict //...
```

### Supported Linters

| Language | Formatter | Linter | Config File |
|----------|-----------|--------|-------------|
| C++ | clang-format | clang-tidy | `.clang-format`, `.clang-tidy` |
| Python | ruff format | ruff check | `ruff.toml` |
| Rust | rustfmt | (clippy via rustc) | `rustfmt.toml` |
| Starlark | buildifier | - | - |

### Ignoring Lint

- Add `tags = ["no-lint"]` to a target to skip linting for that target
- Use inline comments for language-specific suppressions (e.g., `# noqa` for Python)

## Code Style Guidelines

### C++ Style
- **Standard**: C++20 (configured in `.bazelrc`)
- **Includes**: Angle brackets for system headers, quotes for local headers
- **Naming**: Functions `snake_case`, Classes `PascalCase`, Constants `UPPER_SNAKE_CASE`
- **Error Handling**: Prefer `std::optional`/`std::expected` or exceptions

### Rust Style
- **Edition**: 2024, **Version**: 1.85.0
- **Naming**: Functions/variables `snake_case`, Types/traits `PascalCase`, Constants `UPPER_SNAKE_CASE`
- **Error Handling**: Use `Result<T, E>`, avoid `unwrap()` in library code
- **Imports**: Group std, external crates, and local modules separately

### Python Style
- **Version**: 3.12, follow PEP 8
- **Naming**: Functions/variables `snake_case`, Classes `PascalCase`, Constants `UPPER_SNAKE_CASE`
- **Entry Point**: Always use `if __name__ == "__main__":` guard
- **Type Hints**: Use type annotations for function signatures
- **Imports**: Order as standard library, third-party, local

### Bazel/Starlark Style
- **BUILD Files**: Use `BUILD.bazel` extension (not `BUILD`)
- **Load Statements**: Place at top of file
- **Target Naming**: Use `snake_case`
- **Dependencies**: List `deps` alphabetically

## Project Structure

```
/
├── MODULE.bazel          # Bazel module definition (dependencies, toolchains)
├── MODULE.bazel.lock     # Dependency lockfile (do not edit manually)
├── .bazelrc              # Bazel configuration (C++ flags, platforms, lint)
├── .bazelversion         # Bazel version pinning (8.5.0)
├── BUILD.bazel           # Root BUILD file
├── .clang-format         # C++ formatting config
├── .clang-tidy           # C++ linting config
├── ruff.toml             # Python linting/formatting config
├── rustfmt.toml          # Rust formatting config
├── bazel/                # Bazel build infrastructure
│   ├── lint/             # Linter aspects and configs
│   └── format/           # Formatter targets
├── tools/                # Project-specific tools (scripts, built utilities)
└── examples/
    ├── cpp/              # C++ examples (*.cc, BUILD.bazel)
    ├── rust/             # Rust examples (*.rs, BUILD.bazel)
    └── python/           # Python examples (*.py, BUILD.bazel)
```

## Adding New Targets

### C++ Binary
```python
cc_binary(
    name = "my_binary",
    srcs = ["main.cc"],
    deps = [],
)
```

### Rust Binary
```python
load("@rules_rust//rust:defs.bzl", "rust_binary")

rust_binary(
    name = "my_binary",
    srcs = ["main.rs"],
    edition = "2024",
    deps = [],
)
```

### Python Binary
```python
load("@rules_python//python:py_binary.bzl", "py_binary")

py_binary(
    name = "my_binary",
    srcs = ["main.py"],
    main = "main.py",
    deps = [],
)
```

## Important Notes

1. **Hermeticity**: Uses `--incompatible_strict_action_env` for reproducible builds.

2. **Cross-compilation**: LLVM toolchain supports Linux x86_64, Linux aarch64, and macOS aarch64.

3. **Bzlmod**: Uses modern Bzlmod (not WORKSPACE). Add dependencies in `MODULE.bazel`.

4. **Lock File**: Never manually edit `MODULE.bazel.lock`. Run `bazel mod deps` to update.

5. **Bazel Symlinks**: The `bazel-*` directories are build output symlinks (gitignored).
