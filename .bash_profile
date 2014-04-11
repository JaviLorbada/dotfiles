export PATH=/usr/local/bin:$PATH
export EDITOR="vim"
export ANDROID_HOME=/Applications/Android\ Studio.app/sdk/
export GRADLE_HOME=/usr/bin/gradle
export PATH=$PATH:$GRADLE_HOME/bin

# Load ~/.bash_prompt and ~/.aliases 
for file in ~/.{bash_prompt,aliases,profile}; do
        [ -r "$file" ] && source "$file"
done

unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Prefer US English and use UTF-8
export LC_ALL="en_US.UTF-8"
export LANG="en_US"

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

# Display Git Branch or Tag Names in your Bash Prompt
source ~/.bash/git-prompt
PS1="$GREEN\$(date +%H:%M) \w$RED \$(parse_git_branch_or_tag)$GREEN\$ "

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
