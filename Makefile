.PHONY: all
all: bin git vim xfce zsh

.PHONY: bin
bin:
	mkdir -p "$$HOME/.local/bin"
	cp -pf $(shell find bin -name "*.sh") "$$HOME/.local/bin/"

.PHONY: git
git:
	cp -rpf git/.gitconfig "$$HOME/"

.PHONY: templates
templates:
	mkdir -p "$$HOME/Templates"
	cp -pf $(shell find templates) "$$HOME/Templates/"

.PHONY: vim
vim:
	cp -rpf vim/.vim vim/.vimrc "$$HOME/"

.PHONY: xfce
xfce:
	mkdir -p "$$HOME/.config"
	cp -rpf xfce/xfce4 "$$HOME/.config/"

.PHONY: zsh
zsh:
	cp -rpf zsh/.zshenv zsh/.zshrc "$$HOME/"

.PHONY: zsh-mac
zsh-mac:
	cp -rpf zsh/.zshenv zsh/.zshrc-mac "$$HOME/"

# Development

.PHONY: ci
ci: lint

.PHONY: lint
lint:
	shellcheck -e "SC2039" -s sh $$(find bin/ -name "*.sh" -exec echo {} +)

