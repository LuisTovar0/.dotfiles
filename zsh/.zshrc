ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="dd/mm/yyyy"
HISTFILE="$ZDOTDIR/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY # share history in every terminal session
setopt append_history # append rather then overwrite
setopt extended_history # save timestamp
setopt inc_append_history # add history immediately after typing a command
setopt HIST_IGNORE_ALL_DUPS # Do not save duplicate commands to history
setopt HIST_FIND_NO_DUPS # Do not find duplicate command when searching

source "$ZDOTDIR/zsh_prompt"
source "$ZDOTDIR/zsh_vi_mode"

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)
