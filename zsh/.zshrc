hostinfo() {
  local DATE="$(date "+%Y/%m/%d %H:%M:%S %z | w%V")"
  local HOSTNAME="$(hostname) ($(uname -m))"

  local CPU="$(cat /proc/cpuinfo | grep '^model name')"

  if [ -z "$CPU" ]; then
    CPU="$(cat /proc/cpuinfo | grep '^Processor')"
  fi

  CPU="$(echo $CPU | tail -n 1 | sed "s/.*: *//" | tr -s ' ' ' ')"

  local RAM=$(busybox free -b | grep "Mem" | tr -s " ")
  local TRAM=$(echo $RAM | cut -d ' ' -f 2)
  local FRAM=$(echo $RAM | cut -d ' ' -f 7)

  local SWAP=$(busybox free -b | grep "Swap" | tr -s " ")
  local TSWAP=$(echo $SWAP | cut -d ' ' -f 2)
  local FSWAP=$(echo $SWAP | cut -d ' ' -f 4)

  local IP=$(ip a | grep "inet " | sed "s/ *inet *//" | sed "s/\/.*//" | xargs)

  echo "
 ▗██▖  ▗██▖
 █\e[32m▐▌\e[0m█  █▐▌█   $DATE
 ▝██\e[42m▘\e[0;32m▙\e[0m ▝██▘   $HOSTNAME
  ▐▌\e[32m▝█▙\e[0m ▐▌    CPU: $CPU
 ▗██▖\e[32m▝█\e[0;42m▗\e[0m██▖   RAM: $(human_measure $FRAM)/$(human_measure $TRAM)
 █▐▌█  █\e[32m▐▌\e[0m█   Swap: $(human_measure $FSWAP)/$(human_measure $TSWAP)
 ▝██▘  ▝██▘   IP: $IP
"
}

human_measure() {
  local AMOUNT=$1
  local MEASURE=("B" "KB" "MB" "GB" "TB" "PB")
  local I=1

  while true; do
    if [ $(printf "%.0f" $AMOUNT) -lt 1024 ]; then
      printf "%.2f%s" $AMOUNT $MEASURE[$I]
      return
    fi

    AMOUNT=$(($AMOUNT / 1024.0))
    I=$(($I + 1))
  done

  return 1
}

hostinfo
zle -N hostinfo

setopt autocd
setopt interactivecomments
# setopt noclobber

# PROMPT

autoload -U promptinit
promptinit

setopt promptsubst

function precmd() {
  vcs_info
}

PS1='%B%(?..%F{red}(%?%)%f )%n %(!.%F{red}☢%f.%F{green}☮%f)›%b '
RPS1='%B$vcs_info_msg_0_╞ %F{green}%1~%f ╡%b'

# PROMPT - Git

autoload -U vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{green} ✔%f'
zstyle ':vcs_info:*' unstagedstr '%F{red} ✘%f'
zstyle ':vcs_info:*' formats '╞ %b%c%u ╡'

# History

HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

setopt histignorealldups
setopt histignorespace
setopt histreduceblanks
setopt sharehistory

# Colors

LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.dz=01;31:*.gz=01;31:*.lz=01;31:*.xz=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.axv=01;35:*.anx=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.axa=00;36:*.oga=00;36:*.spx=00;36:*.xspf=00;36:'

export LS_COLORS
alias ls="ls --color=auto"

# Autocompletion

autoload -U compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%BCoincidences:%b'
zstyle ':completion:*:warnings' format '%BNot found..%b'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# setopt correctall
setopt extendedglob
setopt globdots
setopt listrowsfirst
setopt globcomplete
# setopt nocaseglob

# Keyboard shortcuts

bindkey "5D" backward-word
bindkey "5C" forward-word
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "^F" history-incremental-search-forward
bindkey "^U" backward-kill-line
bindkey "${terminfo[kpp]}" up-line-or-search
bindkey "${terminfo[knp]}" down-line-or-search

# Alias

