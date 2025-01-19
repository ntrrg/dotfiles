_clean_text() {
  local _text="${1:-""}"

  if [ -z "$_text" ]; then
    _text="$(cat -)"
  fi

  echo "$_text" |
    sed 's/[^[:print:]]//' |
    tr -s ' ' ' ' |
    sed 's/^\s\+//' |
    sed 's/\s\+$//'
}

_get_word_size() {
  case "$(uname -m)" in
  x86_64 | amd64 | armv8* | arm64 | aarch64 )
    echo "64-Bit"
    ;;

  x86 | i386 | i486 | i686 | armv7* | armv6* )
    echo "32-Bit"
    ;;

  * )
    echo "0-Bit"
    ;;
  esac
}

_get_os() {
  local _os

  case "$(uname -s)" in
    Darwin* )
      _os="MacOS"
      ;;

    CYGWIN* )
      _os="Cygwin"
      ;;

    MINGW* )
      _os="MinGw"
      ;;

    FreeBSD* )
      _os="FreeBSD"
      ;;

    * )
      if uname -r | grep -q '\-Microsoft$'; then
        _os="Windows"
      elif command -v termux-info > /dev/null; then
        _os="Termux"
      elif command -v getprop > /dev/null; then
        _os="Android"
      else
        _os="Linux"
      fi
      ;;
  esac

  echo "$_os"
}

hostinfo() {
  local _date="$(date "+%Y/%m/%d %H:%M:%S %z | w%V")"
  local _dev="$(hostname) ($(uname -m))"
  local _os="$(_get_os)"
  local _cpu=""
  local _word="$(_get_word_size)"
  local _tram="0B"
  local _uram="0B"
  local _tswap="0B"
  local _uswap="0B"
  local _host="$(hostname)"
  local _ip=""

  case "$_os" in
    Android | Termux )
      # Device

      _dev="$(getprop ro.product.manufacturer) $(getprop ro.product.model)"

      # OS

      _os="Android $(getprop ro.build.version.release) ($(uname -r))"

      # CPU

      _cpu=""

      if command -v lscpu > /dev/null; then
        _cpu="$(lscpu | grep -i '^\s*Model name')"
      fi

      if [ -z "$_cpu" ]; then
        _cpu="$(cat /proc/cpuinfo | grep -i '^Hardware')"
      fi

      if [ -z "$_cpu" ]; then
        _cpu="$(cat /proc/cpuinfo | grep -i '^Model name')"
      fi

      if [ -z "$_cpu" ]; then
        _cpu="$(cat /proc/cpuinfo | grep -i '^Processor')"
      fi

      _cpu="$(echo "$_cpu" | tail -n 1 | sed 's/.*: *//' | _clean_text)"
      _cpu="$_cpu ($(uname -m) $(_get_word_size))"

      # Memory

      local _ram="$(free -b | grep 'Mem' | tr -s ' ')"
      local _fram="$(echo $_ram | cut -d ' ' -f 7)"
      _tram="$(echo $_ram | cut -d ' ' -f 2)"
      _uram="$(echo "$_tram - $_fram" | bc | hm.sh)"
      _tram="$(echo "$_tram" | hm.sh)"

      local _swap="$(free -b | grep 'Swap' | tr -s ' ')"
      _tswap="$(echo $_swap | cut -d ' ' -f 2 | hm.sh)"
      _uswap="$(echo $_swap | cut -d ' ' -f 3 | hm.sh)"

      # Network

      _ip="$(ip a | grep 'inet ' | sed 's/ *inet *//' | sed 's/\/.*//' | xargs)"
      ;;

    MacOS )
      # Device
      # OS

      # CPU

      _cpu="$(sysctl -n machdep.cpu.brand_string)"

      # Memory

      local _ram="$(top -l 1 | grep 'PhysMem:' | tr -s ' ')"
      local _fram="$(echo $_ram | cut -d ' ' -f 6)"
      _tram="$(echo $_ram | cut -d ' ' -f 2)"
      _uram="$(echo "$_tram - $_fram" | sed 's/[a-zA-Z]//g' | bc)"

      # Network

      _ip="$(ifconfig | grep 'inet ' | cut -d ' ' -f 2 | xargs)"
      ;;

    Windows )
      # Device

      _dev="Windows Subsystem for Linux"

      if command -v powershell.exe > /dev/null; then
        local _dev_info="$(powershell.exe -Command '$oldProgressPreference = $progressPreference; $progressPreference = "SilentlyContinue"; Get-ComputerInfo; $progressPrefereqnce = $oldProgressPreferenc')"
        local _brand="$(echo "$_dev_info" | grep CsManufacturer | cut -d ':' -f 2 | sed 's/ Inc\.//' | _clean_text)"
        local _model="$(echo "$_dev_info" | grep CsModel | cut -d ':' -f 2 | _clean_text)"

        _dev="$_brand $_model"
      fi

      # OS

      if [ -e /etc/os-release ]; then
        _os="$_os - $(source /etc/os-release; echo $PRETTY_NAME)"
      fi

      _os="$_os ($(uname -r))"

      # CPU

      _cpu="$(cat /proc/cpuinfo | grep -i '^Hardware')"

      if [ -z "$_cpu" ]; then
        _cpu="$(cat /proc/cpuinfo | grep -i '^Model name')"
      fi

      if [ -z "$_cpu" ]; then
        _cpu="$(cat /proc/cpuinfo | grep -i '^Processor')"
      fi

      _cpu="$(echo "$_cpu" | tail -n 1 | sed 's/.*: *//' | _clean_text)"
      _cpu="$_cpu ($(uname -m) $(_get_word_size))"

      # Memory

      local _ram="$(free -b | grep 'Mem' | tr -s ' ')"
      local _fram="$(echo $_ram | cut -d ' ' -f 4)"
      _tram="$(echo $_ram | cut -d ' ' -f 2)"
      _uram="$(echo "$_tram - $_fram" | bc | hm.sh)"
      _tram="$(echo "$_tram" | hm.sh)"

      local _swap="$(free -b | grep 'Swap' | tr -s ' ')"
      _tswap="$(echo $_swap | cut -d ' ' -f 2 | hm.sh)"
      _uswap="$(echo $_swap | cut -d ' ' -f 3 | hm.sh)"

      # Network

      _ip="$(ip a 2> /dev/null | grep 'inet ' | sed 's/ *inet *//' | sed 's/\/.*//' | xargs)"
      ;;

    * ) # Linux
      # Device

      if [ -e /sys/class/dmi/id/product_name ]; then
        _dev="$(cat /sys/class/dmi/id/sys_vendor | sed 's/ Inc\.//') $(cat /sys/class/dmi/id/product_name)"
      elif cat /proc/cpuinfo | grep -q "Raspberry"; then
        _dev="$(cat /proc/cpuinfo | grep "Raspberry" | tail -n 1 | sed 's/.*: *//' | tr -s ' ' ' ')"
      fi

      # OS

      if [ -e /etc/os-release ]; then
        _os="$(source /etc/os-release; echo $PRETTY_NAME)"
      fi

      _os="$_os ($(uname -r))"

      # CPU

      _cpu=""

      if command -v lscpu > /dev/null; then
        _cpu="$(lscpu | grep -i '^\s*Model name')"
      fi

      if [ -z "$_cpu" ]; then
        _cpu="$(cat /proc/cpuinfo | grep -i '^Hardware')"
      fi

      if [ -z "$_cpu" ]; then
        _cpu="$(cat /proc/cpuinfo | grep -i '^Model name')"
      fi

      if [ -z "$_cpu" ]; then
        _cpu="$(cat /proc/cpuinfo | grep -i '^Processor')"
      fi

      _cpu="$(echo "$_cpu" | tail -n 1 | sed 's/.*: *//' | _clean_text)"
      _cpu="$_cpu ($(uname -m) $(_get_word_size))"

      # Memory

      local _ram="$(free -b | grep 'Mem' | tr -s ' ')"
      local _fram="$(echo $_ram | cut -d ' ' -f 7)"
      _tram="$(echo $_ram | cut -d ' ' -f 2)"
      _uram="$(echo "$_tram - $_fram" | bc | hm.sh)"
      _tram="$(echo "$_tram" | hm.sh)"

      local _swap="$(free -b | grep 'Swap' | tr -s ' ')"
      _tswap="$(echo $_swap | cut -d ' ' -f 2 | hm.sh)"
      _uswap="$(echo $_swap | cut -d ' ' -f 3 | hm.sh)"

      # Network

      _ip="$(ip a | grep "inet " | sed 's/ *inet *//' | sed 's/\/.*//' | xargs)"
      ;;
  esac

  echo "
 ▗██▖  ▗██▖    \e[0;30m▀\e[0;90m▄\e[0m\e[0;31m▀\e[0;91m▄\e[0m\e[0;32m▀\e[0;92m▄\e[0m\e[0;33m▀\e[0;93m▄\e[0m\e[0;34m▀\e[0;94m▄\e[0m\e[0;35m▀\e[0;95m▄\e[0m\e[0;36m▀\e[0;96m▄\e[0m\e[0;37m▀\e[0;97m▄\e[0m
 █\e[32m▐▌\e[0m█  █▐▌█   $_date
 ▝██\e[42m▘\e[0;32m▙\e[0m ▝██▘   $_dev
  ▐▌\e[32m▝█▙▖\e[0m▐▌    \033[1mOS:\033[0m $_os
 ▗██▖\e[32m▝█\e[0;42m▗\e[0m██▖   \033[1mCPU:\033[0m $_cpu
 █▐▌█  █\e[32m▐▌\e[0m█   \033[1mRAM:\033[0m $_uram/$_tram $([ $_tswap != "0B" ] && echo "\033[1mSwap:\033[0m $_uswap/$_tswap")
 ▝██▘  ▝██▘   \033[1mNET:\033[0m $_host - $_ip
"
}

#. "$HOME/.zprofile"
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

