.PHONY: all
all: bin git templates vim xfce zsh

.PHONY: bin
bin:
	mkdir -p "$$HOME/.local/bin"
	cp -pf $(shell find bin -type f -executable) "$$HOME/.local/bin/"

.PHONY: git
git:
	cp -rpf git/.gitconfig "$$HOME/"

.PHONY: templates
templates:
	mkdir -p "$$HOME/Templates"
	cp -pf $(shell find templates -type f) "$$HOME/Templates/"

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

# Development

.PHONY: ci
ci: lint

.PHONY: lint
lint:
	shellcheck -e "SC2039" -s sh $$(find bin/ -name "*.sh" -exec echo {} +)

