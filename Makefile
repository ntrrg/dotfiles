XDG_LOCAL_HOME ?= $$HOME/.local
XDG_BIN_HOME ?= $(XDG_LOCAL_HOME)/bin
XDG_CONFIG_HOME ?= $(XDG_LOCAL_HOME)/etc
XDG_DATA_HOME ?= $(XDG_LOCAL_HOME)/share
XDG_STATE_HOME ?= $(XDG_LOCAL_HOME)/var
XDG_CACHE_HOME ?= $(XDG_STATE_HOME)/cache

.PHONY: all
all: gui

.PHONY: gui
gui: tui xdg-gui gtk assets
	mkdir -p "$$HOME/Desktop"
	mkdir -p "$$HOME/Documents"
	mkdir -p "$$HOME/Downloads"
	[ -d "$$HOME/Fonts" ] || ln -sf "$(XDG_DATA_HOME)/fonts" "$$HOME/Fonts"
	mkdir -p "$$HOME/Games"
	[ -d "$$HOME/Icons" ] || ln -sf "$(XDG_DATA_HOME)/icons" "$$HOME/Icons"
	mkdir -p "$$HOME/Music"
	mkdir -p "$$HOME/Pictures"
	mkdir -p "$$HOME/Public"
	mkdir -p "$$HOME/Templates"
	[ -d "$$HOME/Themes" ] || ln -sf "$(XDG_DATA_HOME)/themes" "$$HOME/Themes"
	mkdir -p "$$HOME/Videos"

.PHONY: tui
tui: xdg bin git gpg htop ssh vim zsh

pi_scripts := $(shell find . -maxdepth 1 -name "post-install*.sh") firewall.sh

###########
# Actions #
###########

.PHONY: abuild
abuild:
	cp -rf "alpine/.abuild" "$$HOME/"
	chmod -R a=,u=rwX "$$HOME/.abuild"

shell_scripts := $(shell find bin -name "*.sh" -executable)

.PHONY: bin
bin:
	cp -pf $(shell_scripts) "$(XDG_BIN_HOME)/"
	chmod -R +x "$(XDG_BIN_HOME)"

.PHONY: git
git:
	cp -rpf "git" "$(XDG_CONFIG_HOME)/"

.PHONY: gpg
gpg:
	cp -rf "gpg/.gnupg" "$$HOME/"
	chmod -R a=,u=rwX "$$HOME/.gnupg"

.PHONY: htop
htop:
	cp -rpf "htop" "$(XDG_CONFIG_HOME)/"

.PHONY: ssh
ssh:
	cp -rf "ssh/.ssh" "$$HOME/"
	chmod -R a=,u=rwX "$$HOME/.ssh"

.PHONY: templates
templates:
	cp -pf $(shell find templates -mindepth 1 ! -path "templates/.*" | sed 's/ /\\ /g') \
		"$$HOME/Templates"

.PHONY: vim
vim:
	cp -rpf "vim/.vim" "$$HOME/"

xdg_scripts := xdg/setup.sh

.PHONY: xdg
xdg:
	xdg/setup.sh

.PHONY: xdg-gui
xdg-gui:
	cp -pf "xdg/mimeapps.list" "xdg/user-dirs.dirs" "xdg/user-dirs.locale" "$(XDG_CONFIG_HOME)/"
	IS_GUI=1 xdg/setup.sh

.PHONY: zsh
zsh:
	cp -rpf \
		"zsh/.profile" \
		"zsh/.zlogin" \
		"zsh/.zlogout" \
		"zsh/.zprofile" \
		"zsh/.zshenv" \
		"zsh/.zshrc" \
		"$$HOME/"

# GUI

.PHONY: alacritty
alacritty:
	cp -rpf "gui/alacritty" "$(XDG_CONFIG_HOME)/"

.PHONY: assets
assets:
	git rev-parse --verify --quiet assets > "/dev/null" || \
		git fetch --depth 1 origin assets:assets
	git archive --format tar assets | tar -C ~ -x

.PHONY: conky
conky:
	cp -rpf "gui/conky" "$(XDG_CONFIG_HOME)/"

.PHONY: dunst
dunst:
	cp -rpf "gui/dunst" "$(XDG_CONFIG_HOME)/"

.PHONY: foot
foot:
	cp -rpf "gui/foot" "$(XDG_CONFIG_HOME)/"

.PHONY: ghostty
ghostty:
	cp -rpf "gui/ghostty" "$(XDG_CONFIG_HOME)/"

.PHONY: gtk
gtk:
	cp -rpf "gui/gtk-3.0" "$(XDG_CONFIG_HOME)/"

.PHONY: rofi
rofi:
	cp -rpf "gui/rofi" "$(XDG_CONFIG_HOME)/"

waybar_scripts := $(shell find gui/waybar -type f -executable)

.PHONY: waybar
waybar:
	cp -rpf "gui/waybar" "$(XDG_CONFIG_HOME)/"

# GUI - DE

river_scripts := $(shell find gui/river -type f -executable)

.PHONY: river
river:
	cp -rpf "gui/river" "$(XDG_CONFIG_HOME)/"
	@echo "See also: dunst ghostty rofi waybar"

.PHONY: xfce
xfce:
	cp -rpf "gui/xfce4" "$(XDG_CONFIG_HOME)/"
	@echo "See also: alacritty conky dunst"

###############
# Development #
###############

scripts := $(pi_scripts) $(shell_scripts) $(xdg_scripts) $(river_scripts) $(waybar_scripts)

.PHONY: ci
ci: lint

.PHONY: lint
lint:
	shfmt -s -p -i 0 -sr -kp -d $(scripts)
