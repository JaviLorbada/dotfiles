#!/usr/bin/env bats
# Alias definition tests for dotfiles

load test_helper

# =============================================================================
# ZSH Alias Tests
# =============================================================================

@test ".zshrc defines directory navigation alias '..'" {
  run grep -E 'alias \.\.=' "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

@test ".zshrc defines 'cdg' alias for git root" {
  run grep -E 'alias cdg=' "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

@test ".zshrc defines 'rmdd' alias for DerivedData cleanup" {
  run grep -E 'alias rmdd=' "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

@test "rmdd alias targets correct DerivedData path" {
  run grep 'rmdd' "${DOTFILES_DIR}/.zshrc"
  [[ "$output" == *"Library/Developer/Xcode/DerivedData"* ]]
}

@test ".zshrc defines 'rl' alias for reload" {
  run grep -E "alias rl=" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

# =============================================================================
# Modern Tool Fallback Tests
# =============================================================================

@test ".zshrc has eza fallback to ls" {
  run grep -A5 "command -v eza" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
  [[ "$output" == *"else"* ]]
}

@test ".zshrc has conditional bat alias" {
  run grep "command -v bat" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

@test ".zshrc has conditional fd alias" {
  run grep "command -v fd" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

@test ".zshrc has conditional rg alias" {
  run grep "command -v rg" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

@test ".zshrc has conditional zoxide alias" {
  run grep "command -v zoxide" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

# =============================================================================
# Git Alias Tests
# =============================================================================

@test ".zshrc defines common git aliases" {
  local git_aliases=("gs" "gst" "gp" "gl" "gd" "gco")

  for alias in "${git_aliases[@]}"; do
    run grep -E "alias ${alias}=" "${DOTFILES_DIR}/.zshrc"
    [ "$status" -eq 0 ]
  done
}

@test ".zshrc defines git flow aliases" {
  run grep -E "alias gf=" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

# =============================================================================
# macOS Specific Aliases
# =============================================================================

@test ".zshrc defines show/hide aliases for Finder" {
  run grep -E "alias show=" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]

  run grep -E "alias hide=" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

@test ".zshrc defines desktop toggle aliases" {
  run grep -E "alias hidedesktop=" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]

  run grep -E "alias showdesktop=" "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
}

@test "flush alias uses correct DNS cache command" {
  run grep 'alias flush=' "${DOTFILES_DIR}/.zshrc"
  [ "$status" -eq 0 ]
  [[ "$output" == *"dscacheutil"* ]]
  [[ "$output" == *"mDNSResponder"* ]]
}
