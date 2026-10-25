#!/usr/bin/env bash
# Set up a new Mac: Homebrew, apps from the Brewfile, and dotfiles via GNU Stow.
# Safe to re-run. Existing files that would be replaced get moved to ~/.dotfiles-backup/<timestamp>/.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(zsh ohmyposh atuin tmux nvim aerospace borders btop zed)
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

log() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

if ! xcode-select -p >/dev/null 2>&1; then
  log "Installing Xcode Command Line Tools (finish the dialog, then re-run this script)"
  xcode-select --install
  exit 1
fi

if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ]; then
  log "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

log "Trusting third-party tap packages"
# Homebrew skips formulae/casks from non-official taps until they are trusted
for tap in felixkratz/formulae jandedobbeleer/oh-my-posh nikitabobko/tap oven-sh/bun; do brew tap "$tap"; done
brew trust --formula felixkratz/formulae/borders jandedobbeleer/oh-my-posh/oh-my-posh oven-sh/bun/bun
brew trust --cask nikitabobko/tap/aerospace

log "Installing apps from Brewfile"
brew bundle --file="$DOTFILES/Brewfile"

log "Linking dotfiles with stow"
for pkg in "${PACKAGES[@]}"; do
  # Move aside real files (not our symlinks) that would block stow
  while IFS= read -r -d '' src; do
    rel="${src#"$DOTFILES/$pkg/"}"
    target="$HOME/$rel"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
      mkdir -p "$BACKUP/$(dirname "$rel")"
      mv "$target" "$BACKUP/$rel"
      echo "backed up ~/$rel"
    fi
  done < <(find "$DOTFILES/$pkg" -type f -print0)
  stow --dir="$DOTFILES" --target="$HOME" --restow "$pkg"
done

log "Installing tmux plugin manager"
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone --depth 1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi
"$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null || true

mkdir -p "$HOME/.nvm"

log "Installing Neovim plugins"
nvim --headless "+Lazy! restore" +qa >/dev/null 2>&1 || echo "nvim plugin restore failed; open nvim to finish"

log "Done"
cat <<'EOF'
Next steps:
  - Open a new terminal (or run: exec zsh)
  - Put machine-specific env vars and secrets in ~/.zshrc.local (not tracked)
  - Configure git identity: git config --global user.name "..." && git config --global user.email "..."
  - Sign in: gh auth login, 1Password, Docker Desktop, Raycast
  - Launch AeroSpace once and grant Accessibility permission
EOF
if [ -d "$BACKUP" ]; then echo "Replaced files were saved to $BACKUP"; fi
