#!/bin/bash
# Dotfiles installation script

IGNORED_FILES=(. .. .git .gitignore .github test Makefile .shellcheckrc)

# Check if a value exists in an array
contains_element() {
    local element="$1"
    shift
    for item in "$@"; do
        [[ "$item" == "$element" ]] && return 0
    done
    return 1
}

# Create symlinks for dotfiles
for file in .*; do
    if contains_element "$file" "${IGNORED_FILES[@]}"; then
        echo "Skipping: $file"
    else
        link_from="$(pwd)/$file"
        link_to="$HOME/$file"
        ln -sf "$link_from" "$link_to"
        echo "Linked: $file"
    fi
done

source ~/.bash_profile

# ============================================================================
# Ghostty Configuration
# ============================================================================
GHOSTTY_CONFIG_DIR="$HOME/.config/ghostty"
GHOSTTY_SOURCE_DIR="$(pwd)/.config/ghostty"

if [ -d "$GHOSTTY_SOURCE_DIR" ]; then
    echo "Setting up Ghostty configuration..."
    mkdir -p "$HOME/.config"
    if [ -L "$GHOSTTY_CONFIG_DIR" ]; then
        echo "Ghostty config symlink already exists, skipping..."
    elif [ -d "$GHOSTTY_CONFIG_DIR" ]; then
        echo "Ghostty config directory exists, backing up to $GHOSTTY_CONFIG_DIR.backup"
        mv "$GHOSTTY_CONFIG_DIR" "$GHOSTTY_CONFIG_DIR.backup"
        ln -s "$GHOSTTY_SOURCE_DIR" "$GHOSTTY_CONFIG_DIR"
        echo "Ghostty config linked successfully"
    else
        ln -s "$GHOSTTY_SOURCE_DIR" "$GHOSTTY_CONFIG_DIR"
        echo "Ghostty config linked successfully"
    fi
fi

# ============================================================================
# Xcode Snippets
# ============================================================================
SNIPPETS_URL="https://github.com/JaviLorbada/JLXcode-Snippets.git"
XCODE_SNIPPETS_DIR="${HOME}/Library/Developer/Xcode/UserData/CodeSnippets/"
REPONAME="${SNIPPETS_URL##*/}"
REPONAME="${REPONAME%.git}"

cd .. || exit 1

if [ ! -d "${REPONAME}" ]; then
    git clone "$SNIPPETS_URL" "$REPONAME"
    cd "$REPONAME" || exit 1
else
    cd "$REPONAME" || exit 1
    git pull origin master
fi

# Make sure Xcode snippets dir exists
if [ ! -d "${XCODE_SNIPPETS_DIR}" ]; then
    mkdir -p "${XCODE_SNIPPETS_DIR}"
fi

for file in *.codesnippet; do
    [ -e "$file" ] || continue  # Handle case where no files match
    echo "Linking $file"
    ln -sf "$file" "${XCODE_SNIPPETS_DIR}"
done
