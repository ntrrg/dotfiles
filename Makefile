XDG_LOCAL_HOME ?= $$HOME/.local
XDG_BIN_HOME ?= $(XDG_LOCAL_HOME)/bin
XDG_CONFIG_HOME ?= $(XDG_LOCAL_HOME)/etc
XDG_DATA_HOME ?= $(XDG_LOCAL_HOME)/share
XDG_STATE_HOME ?= $(XDG_LOCAL_HOME)/var
XDG_CACHE_HOME ?= $(XDG_STATE_HOME)/cache

.PHONY: all
all: gui

.PHONY: gui
gui: tui gtk

.PHONY: tui
tui: xdg bin git gpg htop ssh vim zsh

pi_scripts := $(shell find . -maxdepth 1 -name "post-install*.sh")

###########
# Actions #
###########

.PHONY: abuild
abuild:
	cp -rf "alpine/.abuild" "$$HOME/"
	chmod -R a=,u=rwX "$$HOME/.abuild"

shell_scripts := $(shell find bin -name "*.sh")

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

.PHONY: vim
vim:
	cp -rpf "vim/.vim" "$$HOME/"

xdg_scripts := xdg/setup.sh

.PHONY: xdg
xdg:
	mkdir -p "$$HOME/Bookmarks"
	mkdir -p "$$HOME/Desktop"
	mkdir -p "$$HOME/Documents"
	mkdir -p "$$HOME/Downloads"
	mkdir -p "$$HOME/Fonts"
	mkdir -p "$$HOME/Games"
	mkdir -p "$$HOME/Music"
	mkdir -p "$$HOME/Pictures"
	mkdir -p "$$HOME/Public"
	mkdir -p "$$HOME/Templates"
	mkdir -p "$$HOME/Videos"
	xdg/setup.sh
	cp -pf "xdg/mimeapps.list" "xdg/user-dirs.dirs" "xdg/user-dirs.locale" "$(XDG_CONFIG_HOME)/"

.PHONY: zsh
zsh:
	cp -rpf \
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
	cp -rpf "gui/themes" "$(XDG_DATA_HOME)/"
	cp -rpf "gui/gtk-3.0" "$(XDG_CONFIG_HOME)/"

waybar_scripts := $(shell find gui/waybar -type f -executable)

.PHONY: waybar
waybar:
	cp -rpf "gui/waybar" "$(XDG_CONFIG_HOME)/"

.PHONY: wofi
wofi:
	cp -rpf "gui/wofi" "$(XDG_CONFIG_HOME)/"

# GUI - DE

river_scripts := $(shell find gui/river -type f -executable)

.PHONY: river
river: dunst foot ghostty waybar wofi
	cp -rpf "gui/river" "$(XDG_CONFIG_HOME)/"

.PHONY: xfce
xfce: alacritty conky dunst
	cp -rpf "gui/xfce4" "$(XDG_CONFIG_HOME)/"

###############
# Development #
###############

scripts := $(pi_scripts) $(shell_scripts) $(xdg_scripts) $(river_scripts) $(waybar_scripts)

.PHONY: ci
ci: lint

.PHONY: lint
lint:
	shfmt -s -p -i 0 -sr -kp -d $(scripts)
