# This file is sourced on login shells after .zshenv and before .zshrc.

. "$HOME/.profile"

fpath=($XDG_DATA_HOME/zsh/vendor-functions $XDG_DATA_HOME/zsh/vendor-completions $fpath)

################
# Applications #
################

export BROWSER="firefox"
export EDITOR="vim"
export PAGER="less"
export VISUAL="vim"
