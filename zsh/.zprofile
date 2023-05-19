# This file is sourced on login shells after .zshenv and before .zshrc.

fpath=($HOME/.local/share/zsh/vendor-functions $HOME/.local/share/zsh/vendor-completions $fpath)

export PATH="$HOME/go/bin:$HOME/bin:$HOME/.local/bin:$PATH"
