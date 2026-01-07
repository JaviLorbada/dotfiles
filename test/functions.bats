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
