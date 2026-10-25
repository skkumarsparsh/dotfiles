# dotfiles

Sets up a Mac with my Homebrew apps (`Brewfile`) and configs (GNU Stow packages, one directory per tool, mirroring `$HOME`).

## New Mac, one command

```sh
git clone https://github.com/skumar11-ib/dotfiles.git ~/dotfiles && ~/dotfiles/bootstrap.sh
```

The repo is private, so `git clone` asks for your GitHub username and a personal access token as the password (or use the SSH URL if the Mac already has a key). If the Xcode Command Line Tools aren't installed yet, the script starts that install and exits; run it again once the install finishes.

## What it does

1. Installs Homebrew if it's missing, then runs `brew bundle` on the `Brewfile`.
2. Runs `stow` on every package into `$HOME`. Real files it would replace are moved to `~/.dotfiles-backup/<timestamp>/` first.
3. Installs the tmux plugin manager and its plugins, plus the Neovim (LazyVim) plugins.

## Not tracked, on purpose

Secrets and machine-specific setup stay out of the repo: SSH keys, kube/tsh/gh credentials, git identity, shell history, and work-only helpers. Put env vars or secrets in `~/.zshrc.local`, which `.zshrc` sources if the file exists.

## Changing things

- Edit a config here, and on this Mac it takes effect right away, since the files are symlinked.
- Add an app: add it to `Brewfile`, then run `brew bundle --file ~/dotfiles/Brewfile`.
- Add a config: create `<tool>/<path relative to $HOME>`, add `<tool>` to `PACKAGES` in `bootstrap.sh`, then re-run the script.
