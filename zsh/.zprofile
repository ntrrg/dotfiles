# This file is sourced on login shells after .zshenv and before .zshrc.

if [ -z "$_ZSH_PROFILE" ]; then
  export XDG_LOCAL_HOME="$HOME/.local"
  export XDG_BIN_HOME="$XDG_LOCAL_HOME/bin"
  export XDG_CONFIG_HOME="$XDG_LOCAL_HOME/etc"
  export XDG_DATA_HOME="$XDG_LOCAL_HOME/share"
  export XDG_STATE_HOME="$XDG_LOCAL_HOME/var"
  export XDG_CACHE_HOME="$XDG_STATE_HOME/cache"
  export PATH="$HOME/bin:$XDG_BIN_HOME:$PATH"

  fpath=($XDG_DATA_HOME/zsh/vendor-functions $XDG_DATA_HOME/zsh/vendor-completions $fpath)

  export _ZSH_PROFILE=1
fi
