#! /bin/bash

# Install oh-my-zsh and p10k
# sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install Homebrew
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Brew Installs
# brew install tmux
# brew install lazygit
# brew install herdr

# Install Neovim
# tree-sitter-cli builds parsers for nvim-treesitter's main branch (used by LazyVim)
# brew install neovim tree-sitter-cli

# Install Tmux Plugin Manager
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copy Configuration
cd $HOME/projects/dojo
./load-configuration.sh
