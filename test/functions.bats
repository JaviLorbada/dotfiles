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

@test "openx function is defined in .zshrc" {
  run grep -q "^openx()" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
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

# =============================================================================
# wo() Workspace Function
# =============================================================================

@test "wo function is defined in .zshrc" {
  run grep -q "^wo()" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

@test "wo function uses Documents/Workspace path" {
  run grep "Documents/Workspace" "${DOTFILES_DIR}/.zshrc"
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
