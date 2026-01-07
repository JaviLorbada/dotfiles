#!/usr/bin/env bash
# Test helper functions for BATS tests

# Get the dotfiles directory (parent of test directory)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# List of shell files to test
SHELL_FILES=(
  ".zshrc"
  "install.sh"
)

# Create a temporary directory for tests
setup_temp_dir() {
  TEST_TEMP_DIR="$(mktemp -d)"
  export TEST_TEMP_DIR
}

# Clean up temporary directory
teardown_temp_dir() {
  if [[ -n "${TEST_TEMP_DIR:-}" && -d "${TEST_TEMP_DIR}" ]]; then
    rm -rf "${TEST_TEMP_DIR}"
  fi
}

# Check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Source a file in a subshell and check for errors
source_file_safely() {
  local file="$1"
  # We use bash -n for syntax checking, not actual sourcing
  # because many dotfiles depend on external tools
  bash -n "$file" 2>&1
}

# Get the full path to a dotfile
dotfile_path() {
  echo "${DOTFILES_DIR}/$1"
}
