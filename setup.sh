# update and upgrade packages
sudo apt update
yes | sudo apt upgrade # yes outputs "y" to all the inputs

# fish; fish config depencencies
yes | sudo apt install fish
yes | sudo apt install lolcat
yes | sudo apt install neofetch

# creating links for the config files
ln -s .vimrc ~/.vimrc
ln -s .gitconfig ~/.gitconfig
ln -s fish/config.fish ~/.config/fish/config.fish
mkdir ~/.config/fish/functions
ln -s fish/functions/fish_prompt.fish ~/.config/fish/functions/fish_prompt.fish
