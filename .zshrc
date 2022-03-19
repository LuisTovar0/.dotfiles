export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="random"
# ZSH_THEME_RANDOM_CANDIDATES=( "sorin" "fwalch" "bira" )
zstyle ':omz:update' mode auto # update automatically without asking
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd/mm/yyyy"

plugins=(colored-man-pages colorize vi-mode z)
source $ZSH/oh-my-zsh.sh

# For a full list of active aliases, run `alias`.
alias py="python3"
#alias clear="clear; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo"
alias edcf="vim ~/.zshrc"
alias gst="git status"
alias gaa="git add ."
alias la="ls -la"
alias ..="cdl .."
alias ...="cdl ../.."

cdl() {
	cd $1
	la
}

function md() {
	mkdir $1
	cdl $1
}

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
