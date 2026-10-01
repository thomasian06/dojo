# Loaded for login shells, after .zshenv and before .zshrc (which also sources it).
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
# The system profile (/etc/zprofile) can reset or reorder PATH after .zshenv:
# put ~/.local/bin first again, without duplicates.
typeset -U path
path=("$HOME/.local/bin" $path)

# zoxide: skip under Claude Code so agent shells keep a vanilla `cd` (no chpwd hook / doctor spam)
[[ -z "$CLAUDECODE" ]] && command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# nvm (Homebrew)
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Edit the command line in $EDITOR with Ctrl-X Ctrl-E
autoload edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
