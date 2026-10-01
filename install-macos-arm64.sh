#!/usr/bin/env bash
# Set up a Mac (Apple silicon) with this repo: Homebrew packages (Brewfile),
# zsh (oh-my-zsh, powerlevel10k, plugins), tmux plugins and the configs.
# Safe to rerun.
set -euo pipefail
repo=$(cd "$(dirname "$0")" && pwd)

if ! command -v brew >/dev/null; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
brew bundle --file "$repo/Brewfile"

"$repo/shell/setup-zsh.bash"
"$repo/load-configuration.sh"
"$repo/tmux/setup-tmux-plugins.bash"
