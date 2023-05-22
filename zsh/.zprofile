# This file is sourced on login shells after .zshenv and before .zshrc.

if [ -z "$_ZSH_PROFILE" ]; then
  fpath=($HOME/.local/share/zsh/vendor-functions $HOME/.local/share/zsh/vendor-completions $fpath)

  export PATH="$HOME/go/bin:$HOME/bin:$HOME/.local/bin:$PATH"
  export _ZSH_PROFILE=1
fi
