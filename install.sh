#!/bin/bash
# Dotfiles installation script

IGNORED_FILES=(. .. .git .gitignore .github test Makefile)

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

# Xcode Code Snippets setup
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
