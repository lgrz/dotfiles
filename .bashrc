# If not running interactively don't do anything
[[ $- != *i* ]] && return

alias l='ls -lahG'
alias ll='ls -lahG'
alias lr='ls -lahrt'
alias cdl='cd $HOME/Downloads'
alias cdd='cd $HOME/doc'
alias cdb='cd $HOME/books'

# Allow ctrl-s to pass through to vim
stty -ixon

# When set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

export LANG="en_US.utf8"
export LC_PAPER="en_AU.utf8"
export LC_MEASUREMENT="en_AU.utf8"

export PATH="$HOME/bin:$PATH"
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/bin:$PATH

export EDITOR=vim

# doesn't work, use alias instead
# export GREP_COLOR=red
# export GREP_OPTIONS="--color"
alias grep='grep --color'

# better history
declare -x HISTSIZE=50000
declare -x HISTFILESIZE=50000
# don't put duplicate lines or lines starting with space in the history
HISTCONTROL=ignoreboth

# tab completion for sudo, man
complete -cf sudo
complete -cf man

# git completion
source /usr/local/etc/bash_completion.d/git-completion.bash
source /usr/local/etc/bash_completion.d/git-prompt.sh

# git prompt
export PS1='\h:\W\[\033[32m\]$(__git_ps1) \[\033[0m\]$ '

# virtualenvwrapper
# export WORKON_HOME=$HOME/.virtualenvs
# export PROJECT_HOME=$HOME/src
# source /usr/local/bin/virtualenvwrapper.sh

# gem path
export GEM_HOME="$HOME/.gem"
export PATH="$HOME/.gem/bin:$PATH"

# rbenv
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

# Switch projects
function p() {
    proj=$(ls ~/proj | selecta)
    if [[ -n "$proj" ]]; then
        cd ~/proj/$proj
    fi
}

# fc the last 10 commands from history
function fcl() {
    fc $(history 10 | sed -n -e 1p -e \$p \
        | awk 'NR == 1 { printf $1 } NR == 2 { print "", $1 }')
}

export MARKPATH=$HOME/.marks
function j {
    cd -P "$MARKPATH/$1" 2>/dev/null || echo "No such mark: $1"
}
function mark {
    mkdir -p "$MARKPATH"; ln -s "$(pwd)" "$MARKPATH/$1"
}
function unmark {
    rm -i "$MARKPATH/$1"
}
function marks {
    ls -l "$MARKPATH" | tail -n +2 | sed 's/  / /g' | cut -d' ' -f9- | awk -F ' -> ' '{printf "%-10s -> %s\n", $1, $2}'
}
alias m='marks'
_completemarks() {
    local curw=${COMP_WORDS[COMP_CWORD]}
    local wordlist=$(find $MARKPATH -type l -exec basename {} \;)
    COMPREPLY=($(compgen -W '${wordlist[@]}' -- "$curw"))
    return 0
}
complete -F _completemarks j unmark

if [ -f "$HOME/.local/anaconda3/etc/profile.d/conda.sh" ]; then
    . "$HOME/.local/anaconda3/etc/profile.d/conda.sh"
fi

if [ -d "$HOME/.local/swift/usr/bin" ]; then
    export PATH="$HOME/.local/swift/usr/bin":$PATH
fi
