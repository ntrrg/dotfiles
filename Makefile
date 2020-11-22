binaries := $(shell find bin -type f -executable -exec echo '{}' \+)
templatesDir := $(shell xdg-user-dir "TEMPLATES")

.PHONY: all
all: gui

.PHONY: bin
bin:
	mkdir -p "$$HOME/.local/bin/"
	cp -pf $(binaries) "$$HOME/.local/bin/"

.PHONY: fonts
fonts:
	mkdir -p "$$HOME/.local/share/"
	cp -rpf fonts "$$HOME/.local/share/"
	fc-cache -f

.PHONY: git
git:
	cp -rpf git/.gitconfig "$$HOME/"

.PHONY: gpg
gpg:
	cp -rpf gpg/.gnupg "$$HOME/"

.PHONY: gui
gui: xdg bin git gpg templates vim xfce zsh

.PHONY: templates
templates:
	mkdir -p "$(templatesDir)"
	find templates -type f -exec cp -f '{}' "$(templatesDir)" \;

.PHONY: tui
tui: bin git gpg vim zsh

.PHONY: vim
vim:
	cp -rpf vim/.vim vim/.vimrc "$$HOME/"

.PHONY: xdg
xdg:
	mkdir -p "$$HOME/.config/"
	cp -pf xdg/user-dirs.dirs xdg/user-dirs.locale "$$HOME/.config/"

.PHONY: xfce
xfce:
	mkdir -p "$$HOME/.config/"
	cp -rpf xfce/xfce4 "$$HOME/.config/"
	mkdir -p "$$HOME/.local/share/"
	cp -rpf xfce/themes "$$HOME/.local/share/"

.PHONY: zsh
zsh:
	cp -rpf zsh/.zprofile zsh/.zshenv zsh/.zshrc "$$HOME/"

# Development

pish := $(shell find . -maxdepth 1 -name "post-install*.sh" -exec echo '{}' \+)

.PHONY: ci
ci: lint

.PHONY: lint
lint:
	shellcheck -s sh $(binaries) $(pish)

