# configs / startup
neofetch
set fish_greeting
set EDITOR "vim"

# vim
function fish_user_key_bindings
  fish_vi_key_bindings
end

# aliases
alias py="python3"
alias ..="cdl .."
alias ...="cdl ../.."
alias clear="clear; echo; echo; seq 1 (tput cols) | sort -R | spark | lolcat; echo; echo"
alias edcf="vim ~/.config/fish/config.fish"
alias gst="git status"
alias gaa="git add ."

# functions
function cdl
	cd $argv
	la
end

function md
	mkdir $argv
	cdl $argv
end

### SPARK ###
complete --command spark --exclusive --long min --description "Minimum range"
complete --command spark --exclusive --long max --description "Maximum range"
complete --command spark --exclusive --long version --description "Print version"
complete --command spark --exclusive --long help --description "Print this help message"
function spark --description Sparklines
    argparse --ignore-unknown --name=spark v/version h/help m/min= M/max= -- $argv || return
    if set --query _flag_version[1]
        echo "spark, version 1.1.0"
    else if set --query _flag_help[1]
        echo "Usage: spark <numbers ...>"
        echo "       stdin | spark"
        echo "Options:"
        echo "       --min=<number>   Minimum range"
        echo "       --max=<number>   Maximum range"
        echo "       -v or --version  Print version"
        echo "       -h or --help     Print this help message"
        echo "Examples:"
        echo "       spark 1 1 2 5 14 42"
        echo "       seq 64 | sort --random-sort | spark"
    else if set --query argv[1]
        printf "%s\n" $argv | spark --min="$_flag_min" --max="$_flag_max"
    else
        command awk -v min="$_flag_min" -v max="$_flag_max" '
            {
                m = min == "" ? m == "" ? $0 : m > $0 ? $0 : m : min
                M = max == "" ? M == "" ? $0 : M < $0 ? $0 : M : max
                nums[NR] = $0
            }
            END {
                n = split("▁ ▂ ▃ ▄ ▅ ▆ ▇ █", sparks, " ") - 1
                while (++i <= NR) 
                    printf("%s", sparks[(M == m) ? 3 : sprintf("%.f", (1 + (nums[i] - m) * n / (M - m)))])
            }
        ' && echo
    end
end
### SPARK ###

