# Load ~/.bash_prompt and ~/.aliases 
for file in ~/.{bash_prompt,aliases}; do
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

# Display Git Branch or Tag Names in your Bash Prompt
source ~/.bash/git-prompt
PS1="$GREEN\$(date +%H:%M) \w$RED \$(parse_git_branch_or_tag)$GREEN\$ "