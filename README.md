# dotfiles

Sets up a Mac with my Homebrew apps (`Brewfile`) and configs (GNU Stow packages, one directory per tool, mirroring `$HOME`).

## New Mac, one command

```sh
git clone https://github.com/skumar11-ib/dotfiles.git ~/dotfiles && ~/dotfiles/bootstrap.sh
```

If the Xcode Command Line Tools aren't installed yet, the script starts that install and exits; run it again once the install finishes.

## What it does

1. Installs Homebrew if it's missing, then runs `brew bundle --no-upgrade` on the `Brewfile`. It only installs what's missing; use `brew upgrade` to update.
2. Runs `stow` on every package into `$HOME`. Real files it would replace are moved to `~/.dotfiles-backup/<timestamp>/` first.
3. Installs the tmux plugin manager and its plugins, plus the Neovim (LazyVim) plugins.

## Not tracked, on purpose

Secrets and machine-specific setup stay out of the repo: SSH keys, kube/tsh/gh credentials, git identity, shell history, and work-only helpers. Put env vars or secrets in `~/.zshrc.local`, which `.zshrc` sources if the file exists.

## Changing things

The commands below assume the repo lives at `~/dotfiles`. Use your clone's actual path if it's elsewhere (for example `~/Developer/dotfiles`).

Configs in `$HOME` are symlinks into this repo, so editing `~/.zshrc`, `~/.config/tmux/tmux.conf`, etc. edits the repo file directly. Changes take effect right away on the Mac you edited them on.

- **Add an app:** add a `brew`/`cask` line to `Brewfile`. If it comes from a third-party tap, also add the tap to `Brewfile` and to the `brew trust` lines in `bootstrap.sh`.
- **Add a config:** move the file into `<tool>/<path relative to $HOME>`, add `<tool>` to `PACKAGES` in `bootstrap.sh`, then re-run `./bootstrap.sh` to link it.

## Pushing a change

```sh
cd ~/dotfiles
git status                      # review what changed; make sure no secrets slipped in
git add -A
git commit -m "chore: update tmux config"
git push
```

## Pulling changes on another Mac

```sh
git -C ~/dotfiles pull && ~/dotfiles/bootstrap.sh
```

`git pull` alone is enough when you only edited existing config files, because the symlinks already point at them. Re-run `bootstrap.sh` when you added an app or a new config file; it installs anything missing and links new files. It's safe to re-run, and it never upgrades apps you already have.
