#!/bin/bash

folder="/home/$USER"
echo_ex() {
	echo "$@"
	sh -c "$@"
}

echo_ex "mkdir $folder/.config/"
echo_ex "mkdir $folder/.config/fish/"
echo_ex "mkdir $folder/.config/fish/functions/"

# update and upgrade packages
echo_ex "sudo apt update"
echo_ex "yes | sudo apt upgrade" # yes outputs "y" to all the inputs of the piped command

# fish; fish config depencencies
echo_ex "yes | sudo apt install fish"
echo_ex "yes | sudo apt install lolcat"
echo_ex "yes | sudo apt install neofetch"

echo
echo "🗿🗿🗿 Finished installing dependencies 🗿🗿🗿"
echo

# creating links for the config files
echo_ex "ln -s $PWD/.vimrc $folder/.vimrc"
echo_ex "ln -s $PWD/.gitconfig $folder/.gitconfig"
echo_ex "ln -s $PWD/fish/config.fish $folder/.config/fish/config.fish"
echo_ex "ln -s $PWD/fish/fish_prompt.fish $folder/.config/fish/functions/fish_prompt.fish"
