#!/usr/bin/env bats
# Syntax validation tests for dotfiles

load test_helper

# =============================================================================
# Zsh Syntax Validation
# =============================================================================

@test "zshrc has valid zsh syntax" {
  if ! command -v zsh &> /dev/null; then
    skip "zsh not installed"
  fi
  run zsh -n "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

# =============================================================================
# Bash Syntax Validation
# =============================================================================

@test "install.sh has valid bash syntax" {
  run bash -n "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

@test "bin/devclean has valid syntax for the bash that ships with macOS" {
  run /bin/bash -n "${DOTFILES_DIR}/bin/devclean"
  [ "$status" -eq 0 ]
}

@test "bin/devclean is executable" {
  [ -x "${DOTFILES_DIR}/bin/devclean" ]
}

# =============================================================================
# ShellCheck Static Analysis
# =============================================================================

@test "shellcheck passes on install.sh" {
  if ! command -v shellcheck &> /dev/null; then
    skip "shellcheck not installed"
  fi
  run shellcheck "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

@test "shellcheck passes on bin/devclean" {
  if ! command -v shellcheck &> /dev/null; then
    skip "shellcheck not installed"
  fi
  run shellcheck "${DOTFILES_DIR}/bin/devclean"
  [ "$status" -eq 0 ]
}
