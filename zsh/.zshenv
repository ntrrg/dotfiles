fpath=($HOME/.local/share/zsh/vendor-functions $HOME/.local/share/zsh/vendor-completions $fpath)

if [ -d "$HOME/go/bin" ]; then
  PATH="$HOME/go/bin:$PATH"
fi

export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"

