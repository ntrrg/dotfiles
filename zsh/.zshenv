if [ -n "$_ZSH_ENV" ]; then
  export _ZSH_ENV=1

  fpath=($HOME/.local/share/zsh/vendor-functions $HOME/.local/share/zsh/vendor-completions $fpath)

  export PATH="$HOME/go/bin:$HOME/bin:$HOME/.local/bin:$PATH"

  export CHARSET="UTF-8"
  export LANGUAGE="en_US"
  export LC_ALL="en_US.UTF-8"
  export LANG="en_US.UTF-8"

  export BROWSER="firefox"
  export EDITOR="vim -e"
  export PAGER="less"
  export VISUAL="vim"
fi

