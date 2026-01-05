#!/usr/bin/env bats
# Install script tests for dotfiles

load test_helper

setup() {
  setup_temp_dir
}

teardown() {
  teardown_temp_dir
}

# =============================================================================
# Install Script Validation
# =============================================================================

@test "install.sh exists and is readable" {
  [ -f "${DOTFILES_DIR}/install.sh" ]
  [ -r "${DOTFILES_DIR}/install.sh" ]
}

@test "install.sh has valid bash syntax" {
  run bash -n "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

@test "install.sh defines IGNORED_FILES array" {
  run grep -E "^IGNORED_FILES=" "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

@test "install.sh ignores .git directory" {
  run grep "IGNORED_FILES" "${DOTFILES_DIR}/install.sh"
  [[ "$output" == *".git"* ]]
}

@test "install.sh ignores .gitignore file" {
  run grep "IGNORED_FILES" "${DOTFILES_DIR}/install.sh"
  [[ "$output" == *".gitignore"* ]]
}

# =============================================================================
# Xcode Snippets Configuration
# =============================================================================

@test "install.sh references Xcode snippets repository" {
  run grep "SNIPPETS_URL" "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"JLXcode-Snippets"* ]]
}

@test "install.sh defines correct Xcode snippets directory" {
  run grep "XCODE_SNIPPETS_DIR" "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Library/Developer/Xcode/UserData/CodeSnippets"* ]]
}

# =============================================================================
# Symlink Logic Tests
# =============================================================================

@test "install.sh creates symlinks to home directory" {
  run grep "ln -sf" "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

@test "install.sh links to home directory correctly" {
  run grep 'link_to="\$HOME/' "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

@test "install.sh defines contains_element helper function" {
  run grep "contains_element()" "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

# =============================================================================
# Required Files Exist
# =============================================================================

@test "all expected dotfiles exist" {
  local required_files=(
    ".zshrc"
    ".bash_profile"
    ".bash_prompt"
    ".gitconfig"
    ".gitignore_global"
  )

  for file in "${required_files[@]}"; do
    [ -f "${DOTFILES_DIR}/${file}" ]
  done
}

@test ".zshrc.local.template exists for secrets" {
  [ -f "${DOTFILES_DIR}/.zshrc.local.template" ]
}

@test ".bash/git-prompt exists" {
  [ -f "${DOTFILES_DIR}/.bash/git-prompt" ]
}

# =============================================================================
# Ghostty Configuration Tests
# =============================================================================

@test "Ghostty config directory exists" {
  [ -d "${DOTFILES_DIR}/.config/ghostty" ]
}

@test "Ghostty config file exists" {
  [ -f "${DOTFILES_DIR}/.config/ghostty/config" ]
}

@test "install.sh handles Ghostty configuration" {
  run grep "GHOSTTY_CONFIG_DIR" "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

@test "install.sh creates Ghostty symlink" {
  run grep -E "ln -s.*GHOSTTY" "${DOTFILES_DIR}/install.sh"
  [ "$status" -eq 0 ]
}

@test "Ghostty config specifies font-family" {
  run grep "font-family" "${DOTFILES_DIR}/.config/ghostty/config"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Nerd Font"* ]]
}

@test "Ghostty config enables shell integration" {
  run grep "shell-integration" "${DOTFILES_DIR}/.config/ghostty/config"
  [ "$status" -eq 0 ]
}
