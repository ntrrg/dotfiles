binaries := $(shell find bin -type f -executable -exec echo '{}' \+)
templatesDir := $(shell xdg-user-dir "TEMPLATES")

.PHONY: all
all: gui

.PHONY: bin
bin:
	mkdir -p "$$HOME/.local/bin"
	cp -pf $(binaries) "$$HOME/.local/bin/"

.PHONY: git
git:
	cp -rpf git/.gitconfig "$$HOME/"

.PHONY: gui
gui: xdg bin git templates vim xfce zsh

.PHONY: templates
templates:
	mkdir -p "$(templatesDir)"
	find templates -type f -exec cp -f '{}' "$(templatesDir)" \;

.PHONY: tui
tui: bin git vim zsh

.PHONY: vim
vim:
	cp -rpf vim/.vim vim/.vimrc "$$HOME/"

.PHONY: xdg
xdg:
	mkdir -p "$$HOME/.config"
	cp -pf xdg/user-dirs.dirs xdg/user-dirs.locale "$$HOME/.config/"

.PHONY: xfce
xfce:
	mkdir -p "$$HOME/.config"
	cp -rpf xfce/xfce4 "$$HOME/.config/"

.PHONY: zsh
zsh:
	cp -rpf zsh/.zshenv zsh/.zshrc "$$HOME/"

# Development

pish := $(shell find . -maxdepth 1 -name "post-install*.sh" -exec echo '{}' \+)

.PHONY: ci
ci: lint

.PHONY: lint
lint:
	shellcheck -s sh $(binaries) $(pish)

