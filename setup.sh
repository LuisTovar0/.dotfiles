# update and upgrade packages
sudo apt update
yes | sudo apt upgrade # yes outputs "y" to all the inputs

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
echo_ex "ln -s $PWD/.vimrc ../.vimrc"
echo_ex "ln -s $PWD/.gitconfig ../.gitconfig"
echo_ex "mkdir ../.config/"
echo_ex "mkdir ../.config/fish/"
echo_ex "mkdir ../.config/fish/functions/"
echo_ex "ln -s $PWD/fish/config.fish ../.config/fish/config.fish"
echo_ex "ln -s $PWD/fish/fish_prompt.fish ../.config/fish/functions/fish_prompt.fish"
