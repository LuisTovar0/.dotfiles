#!/bin/bash

if [ $# -ne 1 ]
then
	echo Installation will be done assuming this repo is located in the user home directory.
	folder=$(dirname $PWD)
	username=$(basename $folder)
else
	username=$1
	folder="/home/$1"
	echo Installation will be done on the home directory $folder.
fi

echo_x() { # echo and execute
	case $# in
		3 ) echo -e "\n$1 $3 $2"; command=$3 ;;
		2 ) echo -e "\n$1 $2"; command=$2 ;;
		1 ) echo -e "\n$1"; command=$1 ;;
	esac
	sh -c "$command"
}


# update and upgrade packages
echo_x š š» "sudo apt update"
echo_x š„ ā”ļø "yes | sudo apt upgrade" # yes outputs "y" to all the inputs of the piped command
echo_x š„± "git config --global credential.helper cache --timeout=3600"

# zsh
echo_x š¦ š "yes | sudo apt install zsh"

# nvm and node
echo_x š "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash"
echo_x š "nvm install 16 --lts" š“


# fish; fish config depencencies
echo_x š  š£ "yes | sudo apt install fish"
echo_x š¹ š "yes | sudo apt install lolcat"
echo_x š š„ "yes | sudo apt install neofetch"

# install wakatime
echo_x š š¦ "yes | sudo apt install python3-pip"
echo_x ā° š¢ "sudo pip install wakatime"
echo_x š„ š "touch $folder/.wakatimecfg"

echo -e "\n\nšæšæšæ Finished installing dependencies šæšæšæ\n"

# creating links for the config files
echo_x š„ š¤ "ln -s $PWD/.vimrc $folder/.vimrc"
echo_x š³ š "ln -s $PWD/.gitconfig $folder/.gitconfig"
echo_x š® š« "mkdir -p $folder/.config/fish/functions/"
echo_x š āļø  "ln -s $PWD/fish/config.fish $folder/.config/fish/config.fish"
echo_x š£ š” "ln -s $PWD/fish/fish_prompt.fish $folder/.config/fish/functions/fish_prompt.fish"

# grant the user ownership of his own home directory, and its subdirectories
echo_x š š "chown -R $username:$username $folder"
