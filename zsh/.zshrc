eval "$(/opt/homebrew/bin/brew shellenv)"

export PATH="$HOME/.local/bin:$(go env GOPATH)/bin:/opt/homebrew/opt/curl/bin:$PATH"

# opencode (installed by its own script into ~/.opencode)
[ -d "$HOME/.opencode/bin" ] && export PATH="$HOME/.opencode/bin:$PATH"

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/zen.toml)"

source <(fzf --zsh)

eval "$(zoxide init zsh)"

alias ls='lsd'
alias cd='z'

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

eval "$(atuin init zsh)"

if [ "$TERM" = xterm ]; then TERM=xterm-256color; fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# nvm (installed via Homebrew)
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Claude Code Bash tool: unmatched globs pass through literally (bash behaviour) instead of erroring
[[ -n $CLAUDECODE ]] && setopt NO_NOMATCH

# Machine-specific settings and secrets live here, never in the repo
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
