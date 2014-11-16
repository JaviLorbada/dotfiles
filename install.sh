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