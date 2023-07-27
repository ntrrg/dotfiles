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

* Improved Zig and Go syntax highlight.

* Key shortcuts.

  * <kbd>Leader</kbd> is <kbd>\\</kbd> or <kbd>Space</kbd> 

  **Normal mode:**

  * <kbd>[</kbd> + <kbd>q</kbd> -> `:cprev<CR>`
  * <kbd>]</kbd> + <kbd>q</kbd> -> `:cnext<CR>`
  * <kbd>[</kbd> + <kbd>Q</kbd> -> `:cfirst<CR>`
  * <kbd>]</kbd> + <kbd>Q</kbd> -> `:clast<CR>`

  * <kbd>Leader</kbd> + <kbd>s</kbd> -> Find symbol in document.
  * <kbd>Leader</kbd> + <kbd>S</kbd> -> Find symbol.
  * <kbd>Leader</kbd> + <kbd>d</kbd> -> Show definition.
  * <kbd>Leader</kbd> + <kbd>D</kbd> -> Go to definition.
  * <kbd>Leader</kbd> + <kbd>i</kbd> -> Show implemented interface.
  * <kbd>Leader</kbd> + <kbd>I</kbd> -> Go to implemented interface.
  * <kbd>Leader</kbd> + <kbd>t</kbd> -> Show type definition.
  * <kbd>Leader</kbd> + <kbd>T</kbd> -> Go to type definition.
  * <kbd>Leader</kbd> + <kbd>R</kbd> -> Show references.
  * <kbd>Leader</kbd> + <kbd>,</kbd> -> Go to previous references.
  * <kbd>Leader</kbd> + <kbd>.</kbd> -> Go to next references.
  * <kbd>Leader</kbd> + <kbd>!</kbd> -> Go to next diagnostic.

  * <kbd>Leader</kbd> + <kbd>r</kbd> -> Rename symbol.

  * <kbd>K</kbd> -> Show symbol information.
  * <kbd>Ctrl</kbd> + <kbd>n</kbd> -> Scroll down symbol information.
  * <kbd>Ctrl</kbd> + <kbd>p</kbd> -> Scroll up symbol information.
