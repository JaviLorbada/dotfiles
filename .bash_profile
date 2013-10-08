# Colors
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"

# Terminal Aliases
alias la="ls -lah"
alias op="open ."

# Git
# enable the git bash completion commands, should have homebrew
if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
fi

alias gcl="git clone --recursive"
alias gco="git co"
alias gcb="git co -b"
alias gb="git br"
alias gh="git hist"
alias gp="git push"
alias gl="git pull"
alias gs="git status -sb"
alias gst="git status"
alias gm="git merge"
alias gt="git tag"

gc() {
  git add .
  git commit -am "$*"
}

# wo = workspace
wo() {
  code_dir=~/Desktop/JaviLorbada/StashRepos/
  # code_dir=~/Desktop/JaviLorbada/Workspace/
  cd $(find $code_dir -type d -maxdepth 3 | grep -i $* | grep -v /Pods --max-count=1)
}

# Display Git Branch or Tag Names in your Bash Prompt
source ~/.bash/git-prompt
PS1="$GREEN\$(date +%H:%M) \w$RED \$(parse_git_branch_or_tag)$GREEN\$ "

