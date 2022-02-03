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

echo_x() {
	emojis=(🚀 💻 🌊 ⚡️ 💥 🌵 🍂 🌱 🎮 🔫 🦠 🔱 💭 🍞 👽 🤖 🎃 🦾 👑 🥽 🐞 🦀 🦞 🦑 🌳 🐚 🪐 🍉 🥑 🥕 🥥 🍕 🍥 🍪 🎱 🎸 🎲)
	echo -e "\n${emojis[$(($RANDOM % ${#emojis[@]}))]} $@ ${emojis[$(($RANDOM % ${#emojis[@]}))]}"
	sh -c "$@"
}


# update and upgrade packages
echo_x "sudo apt update"
echo_x "yes | sudo apt upgrade" # yes outputs "y" to all the inputs of the piped command

# fish; fish config depencencies
echo_x "yes | sudo apt install fish"
echo_x "yes | sudo apt install lolcat"
echo_x "yes | sudo apt install neofetch"

# install wakatime
echo_x "yes | sudo apt install python3-pip"
echo_x "sudo pip install wakatime"
echo_x "touch $folder/.wakatimecfg"

echo -e "\n\n🗿🗿🗿 Finished installing dependencies 🗿🗿🗿\n"

# creating links for the config files
echo_x "ln -s $PWD/.vimrc $folder/.vimrc"
echo_x "ln -s $PWD/.gitconfig $folder/.gitconfig"
echo_x "mkdir -p $folder/.config/fish/functions/"
echo_x "ln -s $PWD/fish/config.fish $folder/.config/fish/config.fish"
echo_x "ln -s $PWD/fish/fish_prompt.fish $folder/.config/fish/functions/fish_prompt.fish"

# grant the user ownership of the newly-created .config folder and subfolder
echo_x "chown -R $username:$username $folder/.config"
