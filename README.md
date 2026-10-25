# dotfiles

Sets up a Mac with my Homebrew apps (`Brewfile`) and configs (GNU Stow packages, one directory per tool, mirroring `$HOME`).

## New Mac, one command

```sh
git clone https://github.com/skkumarsparsh/dotfiles.git ~/dotfiles && ~/dotfiles/bootstrap.sh
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
- **Add a config:** see below.

### Adding a new config file

Each top-level folder here (`zsh`, `tmux`, `nvim`, ...) is a Stow *package*. Inside a package, files sit at the same path they'd have relative to `$HOME`. Stow then creates a symlink at that path in `$HOME` pointing back into the repo. For example, `tmux/.config/tmux/tmux.conf` becomes `~/.config/tmux/tmux.conf`.

To track a new file, say `~/.config/git/ignore`:

1. **Pick a package name.** Use the tool's name, here `git`. If the file belongs to a tool that already has a package (for example another file under `~/.config/nvim`), use that package and skip step 3.
2. **Move the real file into the repo, keeping its path under `$HOME`:**
   ```sh
   mkdir -p ~/dotfiles/git/.config/git
   mv ~/.config/git/ignore ~/dotfiles/git/.config/git/ignore
   ```
   Move it rather than copy it. If the original stays, `bootstrap.sh` treats it as a conflict and moves it to `~/.dotfiles-backup/`.
3. **Register the package:** add `git` to the `PACKAGES=(...)` list near the top of `bootstrap.sh`.
4. **Check it for secrets** before committing (tokens, emails, hostnames, absolute `/Users/<name>` paths). Anything machine-specific belongs in `~/.zshrc.local` or a similar untracked file instead.
5. **Link it:** re-run `~/dotfiles/bootstrap.sh`, or link just this package with `stow --dir ~/dotfiles --target ~ git`. Confirm with `ls -l ~/.config/git/ignore`; it should show `-> .../dotfiles/git/.config/git/ignore`.
6. **Commit and push** (see below). On the other Mac, pull and re-run `bootstrap.sh` so the new file gets linked there too.

Stow skips some file names by default, including `.gitignore` and `README*`/`LICENSE*` at the top of a package. A file like that won't be linked; rename it or leave it untracked.

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
