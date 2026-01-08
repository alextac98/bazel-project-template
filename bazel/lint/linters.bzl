"""Linter aspect definitions for the repository.

This file defines linter aspects that can be applied to targets to check
code quality. These aspects are used by the `--config=lint` bazel option.

Usage:
    bazel build --config=lint //...
    bazel build --config=lint-ci //...  # Fail on violations (for CI)
"""

load("@aspect_rules_lint//lint:clang_tidy.bzl", "lint_clang_tidy_aspect")
load("@aspect_rules_lint//lint:ruff.bzl", "lint_ruff_aspect")

# C++ linting with clang-tidy
# Uses the LLVM toolchain's clang-tidy and the .clang-tidy config at repo root
clang_tidy = lint_clang_tidy_aspect(
    binary = Label("@llvm_toolchain//:clang-tidy"),
    configs = [
        Label("@@//:.clang-tidy"),
    ],
    lint_target_headers = True,
    angle_includes_are_system = True,
    verbose = False,
)

# Python linting with ruff
# Uses the ruff binary provided by rules_lint and the ruff.toml config at repo root
ruff = lint_ruff_aspect(
    binary = Label("@aspect_rules_lint//lint:ruff_bin"),
    configs = [
        Label("@@//:ruff.toml"),
    ],
)
