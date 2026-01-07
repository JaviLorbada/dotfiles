export PATH=/usr/local/bin:$PATH
export EDITOR="vim"
export ANDROID_HOME=/Applications/Android\ Studio.app/sdk/
export GRADLE_HOME=/usr/bin/gradle
export PATH=$PATH:$GRADLE_HOME/bin

# Colors for bash prompt
RED="\[\033[0;31m\]"
GREEN="\[\033[0;32m\]"

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

if command -v brew &>/dev/null && [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    # shellcheck source=/dev/null
    . "$(brew --prefix)/etc/bash_completion"
fi

# Display Git Branch or Tag Names in your Bash Prompt
source ~/.bash/git-prompt
PS1="$GREEN\$(date +%H:%M) \w$RED \$(parse_git_branch_or_tag)$GREEN\$ "

# Swift version manager (optional)
if command -v swiftenv > /dev/null; then eval "$(swiftenv init -)"; fi
