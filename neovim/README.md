## Requirements

- [Neovim](https://neovim.io/) >= 0.12

## Features

- Relative line numbers.

- Soft tabs of 2 spaces by default (but some file types are adjusted).

- Simple status line.

  1. Status bar icon.
  2. Buffer number.
  3. File base name.
  4. Modified tag, `[+]` if modified or none if all changes were saved.
  5. Line number, column number (byte count) and virtual column number
     (Unicode codepoint count).
  6. Percentage through file.
  7. File format (`dos` -> `\r\n`, `mac` -> `\r`, `unix` -> `\n`).
  8. File encoding.
  9. Tab style and size.
  10. File type.

- Key shortcuts.

  - Leader is <kbd>Space</kbd>

  **Normal mode:**

  - <kbd>K</kbd> -> Show symbol information.

  - <kbd>Leader</kbd> + <kbd>!</kbd> -> List workspace diagnostics.
  - <kbd>Leader</kbd> + <kbd>D</kbd> -> Go to definition.
  - <kbd>Leader</kbd> + <kbd>f</kbd> -> Format buffer.
  - <kbd>Leader</kbd> + <kbd>i</kbd> -> Show implemented interfaces.
  - <kbd>Leader</kbd> + <kbd>r</kbd> -> Rename symbol.
  - <kbd>Leader</kbd> + <kbd>R</kbd> -> Show references.
  - <kbd>Leader</kbd> + <kbd>s</kbd> -> Find symbol in document.
  - <kbd>Leader</kbd> + <kbd>S</kbd> -> Find symbol.
  - <kbd>Leader</kbd> + <kbd>T</kbd> -> Go to type definition.
