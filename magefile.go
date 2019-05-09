// +build mage

package main

import (
	"os"
	"path/filepath"
	"strings"

	"github.com/magefile/mage/mg"
	"github.com/magefile/mage/sh"
	ntos "github.com/ntrrg/ntgo/os"
)

var (
	home = os.Getenv("HOME")
)

var Default = All

func All() {
	mg.Deps(Git, Vim, XFCE, Zsh)
}

func Bin() error {
	dst := filepath.Join(home, ".local", "bin")
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

// Development

var (
	shFiles = getShFiles()
)

func CI() {
	mg.SerialDeps(Lint)
}

func Lint() error {
	args := []string{"-e", "SC2039", "-s", "sh"}
	args = append(args, shFiles...)
	return sh.RunV("shellcheck", args...)
}

// Helpers

func getShFiles() []string {
	var shFiles []string

	filepath.Walk("bin", func(path string, info os.FileInfo, err error) error {
		if !strings.HasSuffix(path, ".sh") {
			return nil
		}

		shFiles = append(shFiles, path)
		return nil
	})

	return shFiles
}
