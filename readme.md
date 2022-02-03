# Automatically installing and configuring an Ubuntu machine

This is my automation for installing the apps and tools I always need, as well as the config files that, before creating this, I had to copy by hand to the new OS installs (which I do once in a while with WSL).

I make use of a Bash script to do all that (because I'm assuming that's what comes out of the box with Ubuntu), so right after installing Ubuntu I just have to clone this repo and follow the steps below. I took a couple ideas from [this video](https://youtu.be/r_MpUP6aKiQ), most importantly the symbolic links for the config files.

I also store my Windows Terminal (that's the interface I use for WSL) configs here.

## Running it

If the repo isn't located in the home directory, the user name should be passed by parameter (this is because `sudo` switches the current user to `root`, which makes the `$HOME` variable become `/root`). To execute the script:

```bash
sudo ./setup.sh [USERNAME]
```

Drop the ultra-secret WakaTime API key into the WT config file:

```bash
echo "KEY" > ../.wakatimecfg
```

Set fish as the default shell (not in the script because this command requires the user password):

```bash
chsh -s /usr/bin/fish
```

Debugging this was weird
