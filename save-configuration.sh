#!/usr/bin/env bash
# Copy the live configs back into this repo. Review `git diff` before
# committing: this repo is public, so secrets and machine-specific settings
# belong in ~/.zshenv_private and ~/.zsh_aliases_private instead.
set -euo pipefail
cd "$(dirname "$0")"

for f in .zshrc .zshenv .zprofile .zsh_aliases .p10k.zsh; do cp "$HOME/$f" shell/; done
cp -r ~/.config/nvim ./
cp ~/.tmux.conf tmux/
if [[ $(uname) == Darwin ]]; then
  cp -r ~/.config/ghostty ./
  cp ~/.aerospace.toml aerospace/aerospace.toml
fi
