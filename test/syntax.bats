#!/usr/bin/env bats
# Syntax validation tests for dotfiles

load test_helper

# =============================================================================
# Bash Syntax Validation
# =============================================================================

@test "bash_profile has valid bash syntax" {
  run bash -n "${DOTFILES_DIR}/.bash_profile"
  [ "$status" -eq 0 ]
}

@test "bashrc has valid bash syntax" {
  run bash -n "${DOTFILES_DIR}/.bashrc"
  [ "$status" -eq 0 ]
}

@test "bash_prompt has valid bash syntax" {
  run bash -n "${DOTFILES_DIR}/.bash_prompt"
  [ "$status" -eq 0 ]
}

@test "git-prompt has valid bash syntax" {
  run bash -n "${DOTFILES_DIR}/.bash/git-prompt"
  [ "$status" -eq 0 ]
}

@test "install.sh has valid bash syntax" {
  run bash -n "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

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
# ShellCheck Static Analysis
# =============================================================================

@test "shellcheck passes on .bash_profile" {
  if ! command -v shellcheck &> /dev/null; then
    skip "shellcheck not installed"
  fi
  run shellcheck "${DOTFILES_DIR}/.bash_profile"
  [ "$status" -eq 0 ]
}

@test "shellcheck passes on .bash_prompt" {
  if ! command -v shellcheck &> /dev/null; then
    skip "shellcheck not installed"
  fi
  run shellcheck "${DOTFILES_DIR}/.bash_prompt"
  [ "$status" -eq 0 ]
}

@test "shellcheck passes on install.sh" {
  if ! command -v shellcheck &> /dev/null; then
    skip "shellcheck not installed"
  fi
  run shellcheck "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

@test "shellcheck passes on .bash/git-prompt" {
  if ! command -v shellcheck &> /dev/null; then
    skip "shellcheck not installed"
  fi
  run shellcheck "${DOTFILES_DIR}/.bash/git-prompt"
  [ "$status" -eq 0 ]
}
