# Hermetic Bazel Repository Example

A minimal, hermetic Bazel repository demonstrating cross-compilation for C++, Rust, and Python.

## Features

- **Hermetic builds** - Reproducible across machines using pinned toolchains
- **Cross-compilation** - Build for Linux x86_64, Linux aarch64, and macOS aarch64
- **Bazel-native linting** - Integrated clang-tidy (C++) and ruff (Python)
- **Formatting** - clang-format, rustfmt, ruff, and buildifier

## Toolchains

| Language | Version | Toolchain |
|----------|---------|-----------|
| C++ | C++20 | LLVM/Clang 19.1.0 |
| Rust | 1.85.0 | rules_rust (Edition 2024) |
| Python | 3.12 | rules_python |

## Quick Start

```bash
# Build all
bazel build //...

# Run examples
bazel run //examples/cpp:hello_cpp
bazel run //examples/rust:hello_rust
bazel run //examples/python:hello_python

# Cross-compile
bazel build --config=linux-aarch64 //...

# Lint
bazel build --config=lint //...

# Format
bazel run //:format
```

## Project Structure

```
bazel/          # Bazel infrastructure (lint, format)
examples/       # Example targets (cpp, rust, python)
tools/          # Project-specific tooling
```
