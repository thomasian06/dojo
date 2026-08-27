# This file is loaded after .zshenv and before .zshrc

eval "$(/opt/homebrew/bin/brew shellenv)"
# zoxide: skip under Claude Code so agent shells keep a vanilla `cd` (no chpwd hook / doctor spam)
[[ -z "$CLAUDECODE" ]] && eval "$(zoxide init zsh)"

[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Zsh editor
autoload edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
