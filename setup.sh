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
echo_x 🚀 💻 "sudo apt update"
echo_x 💥 ⚡️ "yes | sudo apt upgrade" # yes outputs "y" to all the inputs of the piped command
echo_x 🥱 "git config --global credential.helper cache --timeout=3600"

# zsh
echo_x 🦓 🐚 "yes | sudo apt install zsh"

# nvm, node and bun
echo_x 🖖 "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash"
echo_x 🫡 ☁ "nvm ls-remote"
echo_x 🆒 🐴 "nvm install lts"
echo_x 🍞 🥖 "npm i -g bun"

# neovim
echo_x "sudo apt install libfuse2 #why u do dis to me bro?"
echo_x 🤳 🦾 "curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage"
echo_x 🐨 ☄ "chmod u+x nvim.appimage"
echo_x 💰 💹 "sudo mv ./nvim.appimage /usr/bin/nvim"


# fish; fish config depencencies
echo_x 🐠 🎣 "yes | sudo apt install fish"
echo_x 😹 🌈 "yes | sudo apt install lolcat"
echo_x 🆕 📥 "yes | sudo apt install neofetch"

# install wakatime
echo_x 🐍 📦 "yes | sudo apt install python3-pip"
echo_x ⏰ 🔢 "sudo pip install wakatime"
echo_x 🍥 🍉 "touch $folder/.wakatimecfg"

echo -e "\n\n🗿🗿🗿 Finished installing dependencies 🗿🗿🗿\n"

# creating links for the config files
echo_x 🥑 🤖 "ln -s $PWD/.vimrc $folder/.vimrc"
echo_x 🌳 🌊 "ln -s $PWD/.gitconfig $folder/.gitconfig"
echo_x 🎮 🔫 "mkdir -p $folder/.config/fish/functions/"
echo_x 🐟 ⚙️  "ln -s $PWD/fish/config.fish $folder/.config/fish/config.fish"
echo_x 🍣 🐡 "ln -s $PWD/fish/fish_prompt.fish $folder/.config/fish/functions/fish_prompt.fish"
echo_x 🫥 😶‍🌫 "ln -s $PWD/nvim $folder/.config/nvim"

# grant the user ownership of his own home directory, and its subdirectories
echo_x 👑 📂 "chown -R $username:$username $folder"
