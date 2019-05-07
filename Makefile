.PHONY: all
all: git vim xfce zsh

.PHONY: bin
bin:
	mkdir -p "$$HOME/bin"
	cp -pf $(shell find bin -name "*.sh") "$$HOME/bin/"

.PHONY: git
git:
	cp -rpf git/.gitconfig "$$HOME/"

.PHONY: vim
vim:
	cp -rpf vim/.vim vim/.vimrc "$$HOME/"

.PHONY: xfce
xfce:
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

