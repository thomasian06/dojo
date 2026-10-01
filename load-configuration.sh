#!/usr/bin/env bash
# Copy the configs in this repo into place. Shell dotfiles that would change
# are backed up first. Machine-specific settings stay in ~/.zshenv_private and
# ~/.zsh_aliases_private, which this never touches.
set -euo pipefail
cd "$(dirname "$0")"

backup=$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)
for f in .zshrc .zshenv .zprofile .zsh_aliases .p10k.zsh; do
  if [[ -f $HOME/$f ]] && ! cmp -s "shell/$f" "$HOME/$f"; then
    mkdir -p "$backup" && cp -p "$HOME/$f" "$backup/"
  fi
  cp "shell/$f" "$HOME/$f"
done
[[ -d $backup ]] && echo "backed up changed shell dotfiles to $backup"

mkdir -p ~/.config
cp -r nvim ~/.config/
cp tmux/.tmux.conf ~/.tmux.conf
if [[ $(uname) == Darwin ]]; then
  cp -r ghostty ~/.config/
  cp aerospace/aerospace.toml ~/.aerospace.toml
fi
echo "configuration loaded"
