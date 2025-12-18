# Path to your oh-my-zsh installation.
export ZSH="/Users/javilorbada/.oh-my-zsh"

# For oh-my-zsh configuration options, see:
# https://github.com/ohmyzsh/ohmyzsh/wiki

ZSH_THEME=robbyrussell

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Note: zsh-syntax-highlighting must be last
plugins=(
  git
  docker
  kubectl
  npm
  macos
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# Autosuggestions configuration (prevent conflicts)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

source $ZSH/oh-my-zsh.sh

# ============================================================================
# History Configuration
# ============================================================================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY          # Write timestamp
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicates first
setopt HIST_IGNORE_DUPS          # Ignore duplicates
setopt HIST_IGNORE_SPACE         # Ignore commands starting with space
setopt HIST_VERIFY               # Show command with history expansion before running
setopt SHARE_HISTORY             # Share history between sessions

# ============================================================================
# Directory Navigation
# ============================================================================
setopt AUTO_PUSHD                # Push directories onto stack
setopt PUSHD_IGNORE_DUPS         # Don't push duplicates
setopt PUSHD_SILENT              # Don't print directory stack

# ============================================================================
# Completion Enhancements
# ============================================================================
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"     # Colored completion
zstyle ':completion:*' group-name ''                        # Group completions
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# ============================================================================
# Aliases
# ============================================================================

# Directory Navigation
alias ..="cd .."
alias ...="cd ../.."
alias d='dirs -v'  # Show directory stack
alias cdg="cd \$(git rev-parse --show-toplevel 2>/dev/null)"  # Go to git root

# Modern ls (eza) with fallback to traditional ls
if command -v eza &> /dev/null; then
  alias l="eza -l --git --icons"
  alias la="eza -la --git --icons"
  alias lt="eza -l --tree --level=2 --git --icons"
  alias lsd="eza -lD --git --icons"
else
  alias l="ls -Gl"
  alias la="ls -Glah"
  alias lsd='ls -l | grep "^d"'
fi
alias v="vim"
alias o="open"
alias op="open ."
alias ops="op -a 'Sublime Text'"
alias dt="cd ~/Desktop"
alias sudo='sudo ' # Enable aliases to be sudo'ed
alias rl="source ~/.zshrc"  # Reload zsh config
alias rmdd="rm -rf ~/Library/Developer/Xcode/DerivedData/"

# Modern tool replacements
command -v bat &> /dev/null && alias cat="bat --style=plain --paging=never"
command -v fd &> /dev/null && alias find="fd"
command -v rg &> /dev/null && alias grep="rg"
command -v zoxide &> /dev/null && alias cd="z"

# System Utilities
alias tu='top -o cpu'  # Processes sorted by CPU
alias tm='top -o vsize'  # Processes sorted by Memory
alias ports="lsof -i -P | grep LISTEN"  # Show listening ports
alias flush="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"  # Flush DNS cache

# macOS Finder
alias show="defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder"
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
alias glog="git log --graph --oneline --decorate --all"

# Functions
openx(){ 
  if test -n "$(find . -maxdepth 1 -name '*.xcworkspace' -print -quit)"
  then
    echo "Opening workspace"
    open *.xcworkspace
    return
  else
    if test -n "$(find . -maxdepth 1 -name '*.xcodeproj' -print -quit)"
    then
      echo "Opening project"
      open *.xcodeproj
      return  
    else
      echo "Nothing found"
    fi
  fi
}

# ============================================================================
# PATH Configuration
# ============================================================================
export PATH=/opt/homebrew/bin:${PATH}
export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# ============================================================================
# Version Managers & Modern Tools
# ============================================================================
# Ruby version manager
eval "$(rbenv init - zsh)" 2>/dev/null

# Modern CLI tools
eval "$(fzf --zsh)" 2>/dev/null           # Fuzzy finder
eval "$(zoxide init zsh)" 2>/dev/null     # Smart cd replacement
eval "$(fnm env --use-on-cd)" 2>/dev/null # Fast Node version manager

# ============================================================================
# External Sources
# ============================================================================
[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && builtin source "$HOME/fig-export/dotfiles/dotfile.zsh"

# Load local secrets and machine-specific config (not tracked in git)
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
