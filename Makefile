.PHONY: all
all: git vim xfce zsh

.PHONY: chrome
chrome:
	cp -rf chrome/.chrome-remote-desktop-session "$$HOME/"

.PHONY: git
git:
	cp -rf git/.gitconfig "$$HOME/"

.PHONY: vim
vim:
	cp -rf vim/.vim vim/.vimrc "$$HOME/"

.PHONY: xfce
xfce:
	cp -rf xfce/xfce4 "$$HOME/.config/"

.PHONY: zsh
zsh:
	cp -rf zsh/.zshenv zsh/.zshrc "$$HOME/"
