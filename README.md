# dojo
An environment repo which turns a workspace into a dojo.

### Setup
- **macOS (Apple silicon):** `./install-macos-arm64.sh` installs Homebrew and the `Brewfile`, then the zsh, tmux and Neovim setup below.
- **Debian/Ubuntu (e.g. a cloud dev workspace):** `shell/setup-shell-debian.bash` installs the same setup without root (pinned releases under `~/.local`): zsh, fzf, zoxide, Neovim with its plugins, lazygit and tmux plugins.
- **Docker:** `shell/setup-shell-ubuntu.Dockerfile` builds an Ubuntu container with the Debian setup.

Both scripts are safe to rerun.
`./load-configuration.sh` copies the configs into place (backing up shell dotfiles it changes), and `./save-configuration.sh` copies them back into the repo.

Secrets and machine-specific settings never go in this public repo: `~/.zshenv_private` (environment, loaded by every zsh) and `~/.zsh_aliases_private` (abbreviations) are loaded when present.

### Shell Environment
Under `shell` you'll find my zsh configs: [oh-my-zsh](https://ohmyz.sh/) with [powerlevel10k](https://github.com/romkatv/powerlevel10k), [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions), [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting), [zsh-abbr](https://github.com/olets/zsh-abbr), [fzf](https://github.com/junegunn/fzf) and [zoxide](https://github.com/ajeetdsouza/zoxide).
The prompt needs a [Nerd Font](https://www.nerdfonts.com) in the terminal you use (I use MesloLGS Nerd Font Mono); remote machines need no fonts.

### Neovim Environment
Under `nvim` you'll find the contents of my `.config/nvim`: [LazyVim](https://www.lazyvim.org) with my plugins, including [herdr-nvim](https://github.com/thomasian06/herdr-nvim) for [Herdr](https://herdr.dev) agents.

### Tmux Config
Under `tmux` you'll find some nifty shortcuts, remaps, and the catppuccin theme.
