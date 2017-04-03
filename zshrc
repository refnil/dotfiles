# Path to your oh-my-zsh installation.
export dotfiles=$(dirname $(readlink $HOME/.zshrc))
export ZSH=$dotfiles/oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="robbyrussell"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
plugins=(git gitignore ubuntu cabal nix)

source $ZSH/oh-my-zsh.sh

export EDITOR='vim'

# Alias
alias tupm="tup monitor -f -a -j4"
alias open="xdg-open"

# Unset unwanted alias
unalias ag

export PYTHONSTARTUP=~/.pythonrc

concat_path () {
    prefix=$1; shift
    paths=($prefix$^@[@])
    concat=$(IFS=: ; echo "${paths[*]}")
    echo "$concat"
}

homepath=(".cabal/bin" ".anaconda3/bin" ".local/bin")

BIN_HOME_PATH=$(concat_path $HOME/ $homepath)

if ! [[ "$PATH" =~ "$BIN_HOME_PATH" ]]
then
    export PATH="$BIN_HOME_PATH:$PATH"
fi

