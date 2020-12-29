binaries := $(shell find bin -type f -executable -exec echo '{}' \+)

.PHONY: all
all: gui

.PHONY: abuild
abuild:
	cp -rf alpine/.abuild "$$HOME/"
	chmod -R a=,u=rwX "$$HOME/.abuild"

.PHONY: bin
bin:
	mkdir -p "$$HOME/.local/bin"
	cp -pf $(binaries) "$$HOME/.local/bin/"

.PHONY: git
git:
	cp -rpf git/.gitconfig "$$HOME/"

.PHONY: gpg
gpg:
	cp -rf gpg/.gnupg "$$HOME/"
	chmod -R a=,u=rwX "$$HOME/.gnupg"

.PHONY: ssh
ssh:
	mkdir -p "$$HOME/.ssh"
	chmod -R a=,u=rwX "$$HOME/.ssh"

.PHONY: tui
tui: bin git gpg ssh vim zsh

.PHONY: vim
vim:
	cp -rpf vim/.vim vim/.vimrc "$$HOME/"

.PHONY: zsh
zsh:
	cp -rpf zsh/.zprofile zsh/.zshenv zsh/.zshrc "$$HOME/"

# GUI

.PHONY: conky
conky:
	mkdir -p "$$HOME/.config"
	cp -rpf desktop/conky "$$HOME/.config/"

.PHONY: fonts
fonts:
	mkdir -p "$$HOME/.local/share/"
	cp -rpf desktop/fonts "$$HOME/.local/share/"
	fc-cache -f

.PHONY: gui
gui: tui fonts conky xfce

.PHONY: xdg
xdg:
	mkdir -p "$$HOME/Desktop" "$$HOME/Downloads" "$$HOME/Templates" \
		"$$HOME/Public" "$$HOME/Documents" "$$HOME/Music" "$$HOME/Pictures" \
		"$$HOME/Videos"
	mkdir -p "$$HOME/.config"
	cp -pf desktop/xdg/user-dirs.dirs desktop/xdg/user-dirs.locale \
		"$$HOME/.config/"

.PHONY: xfce
xfce:
	# XFWM theme
	mkdir -p "$$HOME/.local/share"
	cp -rpf desktop/themes "$$HOME/.local/share/"
	# XFCE
	mkdir -p "$$HOME/.config"
	cp -rpf desktop/xfce4 "$$HOME/.config/"

###############
# Development #
###############

pish := $(shell find . -maxdepth 1 -name "post-install*.sh" -exec echo '{}' \+)

.PHONY: ci
ci: lint

.PHONY: lint
lint:
	shfmt -s -p -i 0 -sr -kp -d $(binaries) $(pish)

