# Automatically installing and configuring an Ubuntu machine

Every good developer must automate the boring procedures that have to be done frequently. This is my automation for installing the apps and tools I always need, as well as the config files that, before creating this, I had to copy by hand to the new OS installs (which I do once in a while with WSL).

I make use of a shell script to do all that, so right after installing Ubuntu I just have to clone this repo and follow the steps below. The script  has comments explaining everything it's doing. Also, the script is for Bash, because I'm assuming that's what comes out of the box with Ubuntu.

I also store my Windows Terminal (that's the interface I use for WSL) configs here.

## Running it

If the repo isn't located in the home directory, the user name should be passed by parameter (this is because `sudo` switches the current user to `root`, which makes the `$HOME` variable become `/root`). To execute the script:

```bash
sudo ./setup.sh [USERNAME]
```

Set fish as default shell (not in the script because this command requires the user password):

```bash
chsh -s /usr/bin/fish
```

Debugging this was weird
