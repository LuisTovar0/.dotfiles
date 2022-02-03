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
	#emojis=(🦞 🦑 🌳 🐚 🪐 🍉 🥑 🥕 🥥 🍕 🍥 🍪 🎱 🎸 🎲)
	#echo -e "\n${emojis[$(($RANDOM % ${#emojis[@]}))]} $@ ${emojis[$(($RANDOM % ${#emojis[@]}))]}"
	#sh -c "$@"

	echo -e "\n$1 $3 $2\n"
	sh -c "$3"
}


# update and upgrade packages
echo_x 🚀 💻 "sudo apt update"
echo_x 🌊 ⚡️ "yes | sudo apt upgrade" # yes outputs "y" to all the inputs of the piped command

# fish; fish config depencencies
echo_x 💥 🌵 "yes | sudo apt install fish"
echo_x 🍂 🌱 "yes | sudo apt install lolcat"
echo_x 🎮 🔫 "yes | sudo apt install neofetch"

echo -e "\n\n🗿🗿🗿 Finished installing dependencies 🗿🗿🗿\n"

# creating links for the config files
echo_x 🦠 🔱 "ln -s $PWD/.vimrc $folder/.vimrc"
echo_x 💭 🍞 "ln -s $PWD/.gitconfig $folder/.gitconfig"
echo_x 👽 🤖 "mkdir -p $folder/.config/fish/functions/"
echo_x 🎃 🦾 "ln -s $PWD/fish/config.fish $folder/.config/fish/config.fish"
echo_x 👑 🥽 "ln -s $PWD/fish/fish_prompt.fish $folder/.config/fish/functions/fish_prompt.fish"

# grant the user ownership of his own home directory, and its subdirectories
echo_x 🐞 🦀 "chown -R $username:$username $folder"
