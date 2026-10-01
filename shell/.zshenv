# Loaded by every zsh (scripts too). Machine-specific settings and secrets go
# in ~/.zshenv_private, which is never committed.

# Path (login shells set it again in .zprofile, after the system profile)
typeset -U path
[[ -d /opt/homebrew/bin ]] && path=(/opt/homebrew/bin $path)
path=("$HOME/.local/bin" $path)

# Editor
if command -v nvim >/dev/null; then export EDITOR="nvim"; else export EDITOR="vim"; fi
export VISUAL="$EDITOR"

# nvm
export NVM_DIR="$HOME/.nvm"

[ -f ~/.zshenv_private ] && source ~/.zshenv_private
