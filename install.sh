IGNORED_FILES=(. .. .git .gitignore)

for file in .*
do
    if [[ "${IGNORED_FILES[@]}" =~ "${file} " || "${IGNORED_FILES[${#IGNORED_FILES[@]}-1]}" == "${file}" ]]; then
        # whatever you want to do when arr contains value
        echo "should not link $file"
    else
        link_from=$(pwd)/$file
        link_to=~/$file
        ln -s $link_from $link_to
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
SNIPPETS_URL=https://github.com/JaviLorbada/JLXcode-Snippets.git
XCODE_SNIPPETS_DIR="${HOME}/Library/Developer/Xcode/UserData/CodeSnippets/"
REPONAME=$(echo $SNIPPETS_URL | awk -F/ '{print $NF}' | sed -e 's/.git$//');

cd ..
if [ ! -d "${REPONAME}" ]; then
    git clone $SNIPPETS_URL $REPONAME;
    cd $REPONAME;
else
    cd $REPONAME;
    git pull origin master
fi

# Make sure xcode snippets dir exists
if [ ! -d "${XCODE_SNIPPETS_DIR}" ]; then
    mkdir -p "${XCODE_SNIPPETS_DIR}"
fi

for file in *.codesnippet
do
    echo "Linking $file"
    ln -s $file "$HOME/Library/Developer/Xcode/UserData/CodeSnippets"
done