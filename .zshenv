neofetch
export ZDOTDIR="$HOME/.config/zsh"

# For a full list of active aliases, run `alias`.
export py="python3"
export vim=nvim
#export clear="clear; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo"
export edcf="vim $ZDOTDIR/.zshrc"
export gst="git status"
export gaa="git add ."
export la="ls -a"
export ..="cdl .."
export ...="cdl ../.."
export rm=trash

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
