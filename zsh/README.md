```text
▗██▖  ▗██▖             ▗▄▄▄▄▄▖     ▗▖
█▐▌█  █▐▌█         ▐▌  ▝▀▀▀▜▛▘     ▐▌
▝██▘▙ ▝██▘   ▐▙██▖▐███    ▗▛  ▗▟██▖▐▙██▖
 ▐▌▝█▙ ▐▌    ▐▛ ▐▌ ▐▌    ▗▛   ▐▙▄▖▘▐▛ ▐▌
▗██▖▝█▗██▖   ▐▌ ▐▌ ▐▌   ▗▛     ▀▀█▖▐▌ ▐▌
█▐▌█  █▐▌█   ▐▌ ▐▌ ▐▙▄ ▗█▄▄▄▄▖▐▄▄▟▌▐▌ ▐▌ █  █
▝██▘  ▝██▘   ▝▘ ▝▘  ▀▀ ▝▀▀▀▀▀▘ ▀▀▀ ▝▘ ▝▘ ▀  ▀
```

## Features

* Host information (`hostinfo`).

  <p align="center">
    <img src="screenshots/hostinfo.png"/>
  </p>

* Just type the directory name, `cd` is not needed.

* Simple prompt with Git support.

  <p align="center">
    <img src="screenshots/prompt-single-user.png"/>
    <img src="screenshots/prompt-single-user-exit-code.png"/>
    <img src="screenshots/prompt-super-user.png"/>
  </p>

  1. Last command exit status (none if `0`).
  2. Username.
  3. User permissions.
  4. Git information (repository name, branch, staged files, modified files).
  5. Current directory.

* Exclude commands from history by adding a preceding white space

* Shared history between terminals.

* Extended GLOB support (`^`, `~`, `#`)

* Keyboard shortcuts:

  * `Ctrl` + `←`: Move the cursor one word backwards.
  * `Ctrl` + `→`: Move the cursor one word forwards.
  * `Ctrl` + `F`: Incremental search forwards.
  * `Ctrl` + `U`: Remove all the characters before the cursor.
  * `Alt` + `H`: Open man page for the current command.
  * `Page Up`: Search up in history using the current characters.
  * `Page Down`: Search down in history using the current characters.

## Install

**Requirements:**

* Zsh >= 4.3.17-1

```shell-session
$ wget -O "$HOME/.zshrc" https://raw.githubusercontent.com/ntrrg/dotfiles/master/zsh/.zshrc
```

```shell-session
$ wget -O "$HOME/.zshenv" https://raw.githubusercontent.com/ntrrg/dotfiles/master/zsh/.zshenv
```
