#!/usr/bin/env bash
# tmux plugins for tmux/.tmux.conf: tpm installs the @plugin list, and the
# catppuccin theme is cloned where the config runs it from. Safe to rerun.
set -euo pipefail

# shallow clone of a release tag, without git's harmless "is not a commit!"
# warning for annotated tags; real errors still show.
clone_tag() {
  local out
  if ! out=$(git -c advice.detachedHead=false clone -q --depth 1 --branch "$1" "$2" "$3" 2>&1); then
    echo "$out" >&2
    return 1
  fi
}

plugins=$HOME/.tmux/plugins
mkdir -p "$plugins"
[[ -d $plugins/tpm ]] || clone_tag v3.1.0 https://github.com/tmux-plugins/tpm "$plugins/tpm"
[[ -d $plugins/tmux ]] || clone_tag v2.1.2 https://github.com/catppuccin/tmux "$plugins/tmux"
if [[ -f $HOME/.tmux.conf ]]; then
  "$plugins/tpm/bin/install_plugins" >/dev/null
fi
echo "tmux plugins installed"
