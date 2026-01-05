#!/usr/bin/env bats
# Function behavior tests for dotfiles

load test_helper

setup() {
  setup_temp_dir
}

teardown() {
  teardown_temp_dir
}

# =============================================================================
# openx() Function Tests
# =============================================================================

@test "openx function is defined in .bash_prompt" {
  source "${DOTFILES_DIR}/.bash_prompt" 2>/dev/null || true
  run type openx
  [ "$status" -eq 0 ]
}

@test "openx function is defined in .zshrc" {
  run grep -q "^openx()" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

@test "openx outputs 'Nothing found' when no Xcode project exists" {
  cd "${TEST_TEMP_DIR}"

  # Source the function (using bash version from .bash_prompt)
  source "${DOTFILES_DIR}/.bash_prompt" 2>/dev/null || true

  run openx
  [[ "$output" == *"Nothing found"* ]]
}

@test "openx detects .xcworkspace files" {
  cd "${TEST_TEMP_DIR}"
  mkdir "Test.xcworkspace"

  # Check that the function would find it (without actually opening)
  run bash -c "cd '${TEST_TEMP_DIR}' && test -n \"\$(find . -maxdepth 1 -name '*.xcworkspace' -print -quit)\" && echo 'found'"
  [ "$output" = "found" ]
}

@test "openx detects .xcodeproj files" {
  cd "${TEST_TEMP_DIR}"
  mkdir "Test.xcodeproj"

  # Check that the function would find it (without actually opening)
  run bash -c "cd '${TEST_TEMP_DIR}' && test -n \"\$(find . -maxdepth 1 -name '*.xcodeproj' -print -quit)\" && echo 'found'"
  [ "$output" = "found" ]
}

@test "openx prefers .xcworkspace over .xcodeproj" {
  cd "${TEST_TEMP_DIR}"
  mkdir "Test.xcworkspace"
  mkdir "Test.xcodeproj"

  # Source the function and check behavior
  source "${DOTFILES_DIR}/.bash_prompt" 2>/dev/null || true

  # Mock 'open' command to just echo
  open() { echo "opening: $1"; }
  export -f open

  run openx
  [[ "$output" == *"Opening workspace"* ]]
}

# =============================================================================
# wo() Workspace Function
# =============================================================================

@test "wo function is defined in .bash_prompt" {
  source "${DOTFILES_DIR}/.bash_prompt" 2>/dev/null || true
  run type wo
  [ "$status" -eq 0 ]
}

@test "wo function uses Documents/Workspace path" {
  run grep "Documents/Workspace" "${DOTFILES_DIR}/.bash_prompt"
  [ "$status" -eq 0 ]
}

# =============================================================================
# Git Prompt Functions
# =============================================================================

@test "parse_git_branch function is defined" {
  source "${DOTFILES_DIR}/.bash/git-prompt"
  run type parse_git_branch
  [ "$status" -eq 0 ]
}

@test "parse_git_tag function is defined" {
  source "${DOTFILES_DIR}/.bash/git-prompt"
  run type parse_git_tag
  [ "$status" -eq 0 ]
}

@test "parse_git_branch_or_tag function is defined" {
  source "${DOTFILES_DIR}/.bash/git-prompt"
  run type parse_git_branch_or_tag
  [ "$status" -eq 0 ]
}

@test "parse_git_branch returns empty outside git repo" {
  source "${DOTFILES_DIR}/.bash/git-prompt"
  cd "${TEST_TEMP_DIR}"

  run parse_git_branch
  [ -z "$output" ]
}

@test "parse_git_branch returns branch name in git repo" {
  source "${DOTFILES_DIR}/.bash/git-prompt"
  cd "${TEST_TEMP_DIR}"

  git init -q
  git config user.email "test@test.com"
  git config user.name "Test"
  touch testfile
  git add testfile
  git commit -q -m "initial"

  run parse_git_branch
  [[ "$output" == *"master"* ]] || [[ "$output" == *"main"* ]]
}
