// +build mage

package main

import (
	"os"
	"path/filepath"

	"github.com/magefile/mage/mg"
	ntos "github.com/ntrrg/ntgo/os"
)

var (
	home = os.Getenv("HOME")
)

var Default = All

func All() {
	mg.Deps(Git, Vim, XFCE, Zsh)
}

func Git() error {
	return ntos.Cp(home, "git/.gitconfig")
}

func Vim() error {
	return ntos.Cp(home, "vim/.vim", "vim/.vimrc")
}

func XFCE() error {
	return ntos.Cp(filepath.Join(home, ".config"), "xfce/xfce4")
}

func Zsh() error {
	return ntos.Cp(home, "zsh/.zshenv", "zsh/.zshrc")
}
