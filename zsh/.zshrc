hostinfo() {
  local DATE="$(date "+%Y/%m/%d %H:%M:%S %z | w%V")"
  local DEVICE="$(hostname) ($(uname -m))"
  local OS="$(uname -r)"
  local CPU=""
  local URAM=""
  local TRAM=""
  local USWAP=""
  local TSWAP=""
  local IP=""

  case "$(uname -s)" in
    Darwin* )
      CPU="$(sysctl -n machdep.cpu.brand_string)"

      local RAM="$(top -l 1 | grep "PhysMem:" | tr -s " ")"
      local FRAM="$(echo $RAM | cut -d ' ' -f 6)"
      TRAM="$(echo $RAM | cut -d ' ' -f 2)"
      URAM="$(echo "$TRAM - $FRAM" | sed "s/[a-zA-Z]//g" | bc)"

      TSWAP="0B"
      USWAP="0B"

      IP="$(ifconfig | grep "inet " | cut -d " " -f 2 | xargs)"
      ;;

    * )
      if [ -e /sys/class/dmi/id/product_name ]; then
        DEVICE="$(cat /sys/class/dmi/id/sys_vendor | sed "s/ Inc\.//g") $(cat /sys/class/dmi/id/product_name) ($(uname -m))"
      elif cat /proc/cpuinfo | grep -q "Raspberry"; then
        DEVICE="$(cat /proc/cpuinfo | grep "Raspberry" | tail -n 1 | sed "s/.*: *//" | tr -s ' ' ' ') ($(uname -m))"
      elif which getprop > /dev/null; then
        DEVICE="$(getprop ro.product.manufacturer) $(getprop ro.product.model) ($(uname -m))"
      fi

      if [ -e /etc/os-release ]; then
        OS="$OS - $(source /etc/os-release; echo $PRETTY_NAME)"
      elif which getprop > /dev/null; then
        OS="$OS - Android $(getprop ro.build.version.release)"
      fi

      CPU="$(lscpu | grep '^Model name')"

      if [ -z "$CPU" ]; then
        CPU="$(cat /proc/cpuinfo | grep '^Processor')"
      fi

      CPU="$(echo $CPU | tail -n 1 | sed "s/.*: *//" | tr -s ' ' ' ')"

      local RAM="$(free -b | grep "Mem" | tr -s " ")"
      local FRAM="$(echo $RAM | cut -d ' ' -f 7)"
      TRAM="$(echo $RAM | cut -d ' ' -f 2)"
      URAM="$(echo "$TRAM - $FRAM" | bc | hm.sh)"
      TRAM="$(echo "$TRAM" | hm.sh)"

      local SWAP="$(free -b | grep "Swap" | tr -s " ")"
      TSWAP="$(echo $SWAP | cut -d ' ' -f 2 | hm.sh)"
      USWAP="$(echo $SWAP | cut -d ' ' -f 3 | hm.sh)"

      IP="$(ip a | grep "inet " | sed "s/ *inet *//" | sed "s/\/.*//" | xargs)"
      ;;
  esac

  echo "
 ▗██▖  ▗██▖
 █\e[32m▐▌\e[0m█  █▐▌█   $DATE
 ▝██\e[42m▘\e[0;32m▙\e[0m ▝██▘   $DEVICE
  ▐▌\e[32m▝█▙▖\e[0m▐▌    \033[1mOS:\033[0m $OS
 ▗██▖\e[32m▝█\e[0;42m▗\e[0m██▖   \033[1mCPU:\033[0m $CPU
 █▐▌█  █\e[32m▐▌\e[0m█   \033[1mRAM:\033[0m $URAM/$TRAM $([ $TSWAP != "0B" ] && echo "\033[1mSwap:\033[0m $USWAP/$TSWAP")
 ▝██▘  ▝██▘   \033[1mNET:\033[0m $(hostname) - $IP
"
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

PS1='%B%(?..%F{red}(%?%)%f )%n %(!.%F{red}#%f.%F{green}$%f)%b '
RPS1='%B$vcs_info_msg_0_╞ %F{green}%1~%f ╡%b'

## Git

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

if echo "$(uname -s)" | grep -q "Darwin"; then
  alias ls="ls -G"
else
  alias ls="ls --color=auto"
fi

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

bindkey '^?' backward-delete-char
bindkey '' backward-delete-char

bindkey "^[[2~" overwrite-mode
bindkey "[2~" overwrite-mode

bindkey "^[[3~" delete-char
bindkey "[3~" delete-char

bindkey "5D" backward-word
bindkey "5C" forward-word
bindkey "[1;5D" backward-word
bindkey "[1;5C" forward-word

bindkey "[1~" beginning-of-line
bindkey "[4~" end-of-line

bindkey "[5~" up-line-or-search
bindkey "[6~" down-line-or-search

bindkey "^R" history-incremental-pattern-search-backward
bindkey "^F" history-incremental-pattern-search-forward

bindkey "[Z" reverse-menu-complete

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

## Vim mode

bindkey -v

PS1_ORIG="$PS1"

function zle-line-init zle-keymap-select {
  VIM_NORMAL='%F{green}N'
  VIM_INSERT='%F{yellow}I'
  VIM_MODE="[${${KEYMAP/vicmd/$VIM_NORMAL}/(main|viins)/$VIM_INSERT}%f]"
  PS1="$VIM_MODE $PS1_ORIG"
  zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Alias

