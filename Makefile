scripts := $(shell find bin -name "*.sh")

.PHONY: all
all: gui

.PHONY: bin
bin:
	mkdir -p "$$HOME/.local/bin"
	cp -pf $(scripts) "$$HOME/.local/bin/"
	chmod -R +x "$$HOME/.local/bin"

.PHONY: gui
gui: tui fonts alacritty conky xfce

.PHONY: tui
tui: bin git gpg ssh vim zsh

###########
# Actions #
###########

.PHONY: abuild
abuild:
	cp -rf "alpine/.abuild" "$$HOME/"
	chmod -R a=,u=rwX "$$HOME/.abuild"

.PHONY: git
git:
	cp -rpf "git/.gitconfig" "$$HOME/"

.PHONY: gpg
gpg:
	cp -rf "gpg/.gnupg" "$$HOME/"
	chmod -R a=,u=rwX "$$HOME/.gnupg"

.PHONY: ssh
ssh:
	mkdir -p "$$HOME/.ssh"
	chmod -R a=,u=rwX "$$HOME/.ssh"

.PHONY: vim
vim:
	cp -rpf "vim/.vim" "vim/.vimrc" "$$HOME/"

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
	mkdir -p "$$HOME/.config"
	cp -rpf "gui/alacritty" "$$HOME/.config/"

.PHONY: conky
conky:
	mkdir -p "$$HOME/.config"
	cp -rpf "gui/conky" "$$HOME/.config/"

.PHONY: fonts
fonts:
	mkdir -p "$$HOME/.local/share/"
	cp -rpf "gui/fonts" "$$HOME/.local/share/"
	fc-cache -f

.PHONY: xdg
xdg:
	mkdir -p "$$HOME/Desktop" "$$HOME/Downloads" "$$HOME/Templates" \
		"$$HOME/Public" "$$HOME/Documents" "$$HOME/Music" "$$HOME/Pictures" \
		"$$HOME/Videos"
	mkdir -p "$$HOME/.config"
	cp -pf "gui/xdg/user-dirs.dirs" "gui/xdg/user-dirs.locale" "$$HOME/.config/"

.PHONY: xfce
xfce:
	# XFWM theme
	mkdir -p "$$HOME/.local/share"
	cp -rpf "gui/themes" "$$HOME/.local/share/"
	# XFCE
	mkdir -p "$$HOME/.config"
	cp -rpf "gui/gtk-3.0" "$$HOME/.config/"
	cp -rpf "gui/xfce4" "$$HOME/.config/"

###############
# Development #
###############

pish := $(shell find . -maxdepth 1 -name "post-install*.sh")

.PHONY: ci
ci: lint

.PHONY: lint
lint:
	shfmt -s -p -i 0 -sr -kp -d $(scripts) $(pish)

