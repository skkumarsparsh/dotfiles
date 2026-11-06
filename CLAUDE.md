`bootstrap.sh` stows these packages into `$HOME` on every Mac, replacing each Mac's own files, so
a line dropped here disappears from every machine.

- **Keep every PATH, export and tool-init line unless the user says that tool is gone.** Some
  tools install themselves outside Homebrew (opencode's installer writes `~/.opencode/bin`), so the
  Brewfile isn't the full list. When a tool may not be on every Mac, guard its line with
  `[ -d <dir> ] &&`, as `zsh/.zshrc` does for opencode. In 2026-10, a cleanup dropped the opencode
  line and opencode vanished from the other Mac.
- List every line you remove, with the reason, in the commit message.
