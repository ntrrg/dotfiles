## Requirements

* [Vim](https://www.vim.org/) >= 8.2

## Features

* Relative line numbers.

* Soft tabs of 2 spaces by default (but some file types are adjusted).

* Simple status line.

  <p align="center">
    <img src="screenshots/statusline.png"/>
  </p>

  1. Status bar icon.
  2. Buffer number.
  3. File base name.
  4. Modified tag, `[+]` if modified, `[-]` if file can't be modified or none
     if all changes were saved.
  5. Line number, column number (byte count) and virtual column number
     (Unicode point count).
  6. Percentage through file.
  7. Terminal in use.
  8. File format (`dos` -> `\r\n`, `mac` -> `\r`, `unix` -> `\n`).
  9. File encoding.
  10. Tab style and size.
  11. File type.

* Monokai-like color scheme

* Improved Go and V syntax hightlight.

* Key shortcuts.

  **Normal mode:**

  * <kbd>[</kbd> + <kbd>q</kbd> -> `:cprev<CR>`
  * <kbd>]</kbd> + <kbd>q</kbd> -> `:cnext<CR>`
  * <kbd>[</kbd> + <kbd>Q</kbd> -> `:cfirst<CR>`
  * <kbd>]</kbd> + <kbd>Q</kbd> -> `:clast<CR>`

