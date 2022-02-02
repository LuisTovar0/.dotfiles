#!/bin/bash

if [ $# -ne 1 ]
then
	echo Installation will be done assuming this repo is located in the user home directory.
	folder=".."
else
	folder="/home/$1"
	echo Installation will be done on the home directory $folder.
fi

echo_x() {
	echo "$@"
	sh -c "$@"
}

echo_x "mkdir $folder/.config/"
echo_x "mkdir $folder/.config/fish/"
echo_x "mkdir $folder/.config/fish/functions/"

# update and upgrade packages
echo_x "sudo apt update"
echo_x "yes | sudo apt upgrade" # yes outputs "y" to all the inputs of the piped command

# fish; fish config depencencies
echo_x "yes | sudo apt install fish"
echo_x "yes | sudo apt install lolcat"
echo_x "yes | sudo apt install neofetch"

echo
echo "🗿🗿🗿 Finished installing dependencies 🗿🗿🗿"
echo

# creating links for the config files
echo_x "ln -s $PWD/.vimrc $folder/.vimrc"
echo_x "ln -s $PWD/.gitconfig $folder/.gitconfig"
echo_x "ln -s $PWD/fish/config.fish $folder/.config/fish/config.fish"
echo_x "ln -s $PWD/fish/fish_prompt.fish $folder/.config/fish/functions/fish_prompt.fish"
