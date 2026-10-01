#!/usr/bin/env bash
# Set up a Debian/Ubuntu machine (e.g. a cloud dev workspace) with this repo:
# zsh (oh-my-zsh, powerlevel10k, plugins, fzf, zoxide), Neovim (LazyVim config
# with its plugins installed), lazygit and tmux. Safe to rerun.
#
#   git clone https://github.com/thomasian06/dojo ~/projects/dojo
#   ~/projects/dojo/shell/setup-shell-debian.bash
#
# Only the basics come from apt; the tools below are pinned releases installed
# under ~/.local, so they need no root and survive workspace rebuilds that
# keep $HOME. Fonts are not needed here: the terminal you connect from draws
# them (use a Nerd Font, e.g. MesloLGS Nerd Font Mono).
set -euo pipefail
repo=$(cd "$(dirname "$0")/.." && pwd)

NVIM_VERSION=0.12.5
TREE_SITTER_VERSION=0.27.0
LAZYGIT_VERSION=0.65.1
FZF_VERSION=0.74.4
ZOXIDE_VERSION=0.10.0

case $(uname -m) in
  x86_64) arch=x86_64 ;;
  aarch64 | arm64) arch=arm64 ;;
  *) echo "unsupported architecture: $(uname -m)" >&2; exit 1 ;;
esac
bin=$HOME/.local/bin
mkdir -p "$bin"
export PATH="$bin:$PATH"

# apt basics -------------------------------------------------------------------
declare -A pkg=([zsh]=zsh [git]=git [curl]=curl [unzip]=unzip [gcc]=gcc [make]=make [rg]=ripgrep [tmux]=tmux)
missing=()
for cmd in "${!pkg[@]}"; do command -v "$cmd" >/dev/null || missing+=("${pkg[$cmd]}"); done
command -v fd >/dev/null || command -v fdfind >/dev/null || missing+=(fd-find)
if ((${#missing[@]})); then
  sudo=$([[ $(id -u) == 0 ]] || echo sudo)
  $sudo apt-get update -qq
  $sudo apt-get install -y -qq "${missing[@]}"
fi
# Debian names fd `fdfind`
if ! command -v fd >/dev/null && command -v fdfind >/dev/null; then ln -sf "$(command -v fdfind)" "$bin/fd"; fi

# Pinned releases ----------------------------------------------------------------
# installed <binary> <version>: true when <binary> --version reports <version>.
installed() { [[ -x $1 ]] && "$1" --version 2>/dev/null | grep -qF "$2"; }
gh_release() { echo "https://github.com/$1/releases/download/$2"; }

if ! installed "$bin/nvim" "v$NVIM_VERSION"; then
  rm -rf "$HOME/.local/nvim" && mkdir -p "$HOME/.local/nvim"
  curl -fsSL "$(gh_release neovim/neovim "v$NVIM_VERSION")/nvim-linux-$arch.tar.gz" |
    tar -xz -C "$HOME/.local/nvim" --strip-components=1
  ln -sf "$HOME/.local/nvim/bin/nvim" "$bin/nvim"
fi

# tree-sitter: the prebuilt binary needs glibc 2.39+ (e.g. Ubuntu 24.04); on
# older systems (Ubuntu 22.04, Debian 12) build it with cargo, installing a
# minimal Rust toolchain under $HOME first if needed. Once per version.
if ! installed "$bin/tree-sitter" "$TREE_SITTER_VERSION"; then
  ts_arch=$([[ $arch == x86_64 ]] && echo x64 || echo arm64)
  curl -fsSL "$(gh_release tree-sitter/tree-sitter "v$TREE_SITTER_VERSION")/tree-sitter-linux-$ts_arch.gz" |
    gunzip >"$bin/tree-sitter"
  chmod +x "$bin/tree-sitter"
  if ! installed "$bin/tree-sitter" "$TREE_SITTER_VERSION"; then
    rm -f "$bin/tree-sitter"
    echo "building tree-sitter $TREE_SITTER_VERSION (the prebuilt binary needs a newer glibc)..."
    log=$HOME/.local/state/dojo-tree-sitter-build.log
    mkdir -p "$(dirname "$log")"
    cargo=$(command -v cargo || echo "$HOME/.cargo/bin/cargo")
    if ! {
      [[ -x $cargo ]] || curl -fsSL https://sh.rustup.rs | sh -s -- -y --profile minimal --no-modify-path
      "$cargo" install tree-sitter-cli --version "$TREE_SITTER_VERSION" --locked --root "$HOME/.local"
    } >"$log" 2>&1; then
      echo "tree-sitter build failed; see $log" >&2
      exit 1
    fi
  fi
fi

if ! installed "$bin/lazygit" "$LAZYGIT_VERSION"; then
  curl -fsSL "$(gh_release jesseduffield/lazygit "v$LAZYGIT_VERSION")/lazygit_${LAZYGIT_VERSION}_linux_$arch.tar.gz" |
    tar -xz -C "$bin" lazygit
fi

if ! installed "$bin/fzf" "$FZF_VERSION"; then
  fzf_arch=$([[ $arch == x86_64 ]] && echo amd64 || echo arm64)
  curl -fsSL "$(gh_release junegunn/fzf "v$FZF_VERSION")/fzf-$FZF_VERSION-linux_$fzf_arch.tar.gz" | tar -xz -C "$bin" fzf
fi

if ! installed "$bin/zoxide" "$ZOXIDE_VERSION"; then
  z_arch=$([[ $arch == x86_64 ]] && echo x86_64 || echo aarch64)
  curl -fsSL "$(gh_release ajeetdsouza/zoxide "v$ZOXIDE_VERSION")/zoxide-$ZOXIDE_VERSION-$z_arch-unknown-linux-musl.tar.gz" |
    tar -xz -C "$bin" zoxide
fi

nvim_v=$("$bin/nvim" --version | head -1) lazygit_v=$("$bin/lazygit" --version | grep -o ', version=[^,]*' | cut -d= -f2)
printf "%-12s %s\n" nvim "$nvim_v" tree-sitter "$("$bin/tree-sitter" --version)" lazygit "$lazygit_v" \
  fzf "$("$bin/fzf" --version)" zoxide "$("$bin/zoxide" --version)"

# Shell, configs, plugins ---------------------------------------------------------
"$repo/shell/setup-zsh.bash"
"$repo/load-configuration.sh"
"$repo/tmux/setup-tmux-plugins.bash"

# Neovim plugins at the versions in lazy-lock.json. Mason's tools (language
# servers, linters) install on the first interactive start.
log=$HOME/.local/state/dojo-nvim-plugins.log
mkdir -p "$(dirname "$log")"
if "$bin/nvim" --headless "+Lazy! restore" +qa >"$log" 2>&1; then
  echo "neovim plugins installed (log: $log)"
else
  echo "neovim plugin install failed; see $log" >&2
  exit 1
fi

# zsh as the login shell
zsh_path=$(command -v zsh)
if [[ $(getent passwd "$(id -un)" | cut -d: -f7) != "$zsh_path" ]]; then
  sudo chsh -s "$zsh_path" "$(id -un)" || echo "could not change the login shell; run: chsh -s $zsh_path"
fi

echo "done: open a new shell (exec zsh)"
