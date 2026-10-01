#!/usr/bin/env bash
# oh-my-zsh, powerlevel10k and the zsh plugins the dotfiles in this folder use,
# as pinned git clones (the same on macOS and Linux). Safe to rerun: existing
# clones are moved to the pinned version.
set -euo pipefail

ZSH=$HOME/.oh-my-zsh
custom=$ZSH/custom

# git, without its harmless "refs/tags/... is not a commit!" warning for
# shallow clones of annotated tags; real errors still show.
quiet_git() {
  local out
  if ! out=$(git -c advice.detachedHead=false "$@" 2>&1); then
    echo "$out" >&2
    return 1
  fi
  if [[ -n $out ]]; then grep -v 'is not a commit!' <<<"$out" || true; fi
}

# clone <url> <dest> [ref]: a shallow clone at `ref` (a tag), or the default branch.
clone() {
  local url=$1 dest=$2 ref=${3:-}
  if [[ ! -d $dest/.git ]]; then
    quiet_git clone -q --depth 1 --recurse-submodules --shallow-submodules ${ref:+--branch "$ref"} "$url" "$dest"
    echo "installed $(basename "$dest") ${ref:-(latest)}"
  elif [[ -n $ref && $(git -C "$dest" describe --tags --exact-match 2>/dev/null) != "$ref" ]]; then
    quiet_git -C "$dest" fetch -q --depth 1 origin tag "$ref"
    quiet_git -C "$dest" checkout -q "$ref"
    quiet_git -C "$dest" submodule -q update --init --depth 1
    echo "updated   $(basename "$dest") to $ref"
  else
    echo "ok        $(basename "$dest") ${ref:-(latest)}"
  fi
}

# oh-my-zsh and powerlevel10k release from their default branch (no recent tags).
clone https://github.com/ohmyzsh/ohmyzsh.git "$ZSH"
clone https://github.com/romkatv/powerlevel10k.git "$custom/themes/powerlevel10k"
clone https://github.com/zsh-users/zsh-autosuggestions.git "$custom/plugins/zsh-autosuggestions" v0.7.1
clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$custom/plugins/zsh-syntax-highlighting" 0.8.0
clone https://github.com/olets/zsh-abbr.git "$custom/plugins/zsh-abbr" v6.5.2
