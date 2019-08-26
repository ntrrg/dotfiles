# Contributing Guide

## Requirements

* [Shellcheck](https://shellcheck.org/dl/) >= 0.4.7

## Guidelines

* **Git commit messages:** <https://chris.beams.io/posts/git-commit/>;
  additionally any commit must be scoped to the package where changes were
  made, which is prefixing the message with the package name, e.g.
  `zsh: Do something`.

## Instructions

1. Create a new branch with a short name that describes the changes that you
   intend to do. If you don't have permissions to create branches, fork the
   project and do the same in your forked copy.

2. Do any change you need to do and add the respective tests.

3. (Optional) Run `make ci` in the project root folder to verify that
   everything is working.

4. Create a [pull request](https://github.com/ntrrg/dotfiles/compare) to the
   `master` branch.

