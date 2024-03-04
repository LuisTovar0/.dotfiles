export ZDOTDIR="$HOME/.config/zsh"

# For a full list of active aliases, run `alias`.
alias py="python3"
#alias clear="clear; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo"
alias edcf="vim $ZDOTDIR/.zshrc"
alias gst="git status"
alias gaa="git add ."
alias la="ls -a"
alias ..="cdl .."
alias ...="cdl ../.."
alias rm=trash

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
