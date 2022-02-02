#!/bin/bash

if $# -ne 1
then
	echo Installation will be done assuming this repo is located in the user home directory.
	folder=".."
else
	folder="/home/$1"
	echo Installation will be done on the home directory $folder.
fi

# update and upgrade packages
sudo apt update
yes | sudo apt upgrade # yes outputs "y" to all the inputs of the piped command

# fish; fish config depencencies
yes | sudo apt install fish
yes | sudo apt install lolcat
yes | sudo apt install neofetch

echo
echo "🗿🗿🗿 Finished installing dependencies 🗿🗿🗿"
echo

echo_ex() {
	echo "$@"
	sh -c "$@"
}

# creating links for the config files
echo_ex "ln -s $PWD/.vimrc $folder/.vimrc"
echo_ex "ln -s $PWD/.gitconfig $folder/.gitconfig"
echo_ex "mkdir $folder/.config/"
echo_ex "mkdir $folder/.config/fish/"
echo_ex "mkdir $folder/.config/fish/functions/"
echo_ex "ln -s $PWD/fish/config.fish $folder/.config/fish/config.fish"
echo_ex "ln -s $PWD/fish/fish_prompt.fish $folder/.config/fish/functions/fish_prompt.fish"
