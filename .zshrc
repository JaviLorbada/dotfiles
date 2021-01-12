
PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

# Terminal Aliases
alias ..="cd .."
alias ...="cd ../.."
alias l="ls -Gl" # All files colorized.
alias la="ls -Glah" # All files colorized, including dot files.
alias lsd='ls -l | grep "^d"' # Only all directories.
alias v="vim"
alias o="open"
alias op="open ."
alias ops="op -a 'Sublime Text'"
alias d="cd ~/Dropbox"
alias b="cd ~/Box\ Sync/"
alias dt="cd ~/Desktop"
alias sudo='sudo ' # Enable aliases to be sudo’ed
alias rl="source ~/.bash_profile"
alias rmdd="rm -rf ~/Library/Developer/Xcode/DerivedData/"

# Processes
alias tu='top -o cpu' # processes sorted by CPU
alias tm='top -o vsize' # processes sorted by Memory

# Show/hide hidden files in Finder
alias show="defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Git Aliases
alias g="git"
alias gcl="git clone --recursive"
alias gco="git co"
alias go="git co"
alias gcb="git co -b"
alias gb="git br"
alias gba="git br -a"
alias gh="git hist"
alias gp="git push"
alias gl="git pull"
alias gs="git status -sb"
alias gst="git status"
alias gm="git merge"
alias gt="git tag"
alias grst="git reset --hard"
alias grv="git remote -v"
alias gd='git diff'
alias gr='git rebase'
alias gf='git flow'
alias gfi='git flow init'
alias gfs='git flow feature start'
alias gff='git flow feature finish'
alias gpr='git remote prune origin'
