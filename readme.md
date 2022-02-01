# Automatically installing and configuring an Ubuntu machine

Every good developer must automate the boring procedures that have to be done frequently. This is my automation for installing the apps and tools I always need, as well as the config files that, before creating this, I had to copy by hand to the new OS installs (which I do once in a while with WSL).

I make use of a shell script to do all that, so right after installing Ubuntu I just have to clone this repo and follow the steps below. The script  has comments explaining everything it's doing.

I also store my Windows Terminal (that's the interface I use for WSL) configs here.

## Running it

This repo must be cloned to the user's home directory in order for the script to work. That's because the `sudo` command makes the current user switch to `root`, which makes the `$HOME` variable be `/root`, so I had to use relative paths.

Execute the script:

```bash
chmod +x setup.sh
sudo ./setup.sh
```

Set fish as default shell (not in the script because this command requires the user password):
```bash
chsh -s /usr/bin/fish
```

Debugging this was weird
