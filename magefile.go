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
	mg.Deps(Bin, Git, Vim, XFCE, Zsh)
}

func Bin() error {
	dst := filepath.Join(home, "bin")
	if err := os.MkdirAll(dst, 0755); err != nil {
		return err
	}

	files, err := filepath.Glob("bin/*")
	if err != nil {
		return err
	}

	return ntos.Cp(dst, files...)
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
