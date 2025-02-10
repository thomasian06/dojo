#! /bin/bash

# Install oh-my-zsh and p10k
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Brew Installs
brew install tmux
brew install lazygit

# Install Neovim
mkdir $HOME/Downloads/setups/neovim
cd $HOME/Downloads/setups/neovim
curl -LO https://github.com/neovim/neovim/releases/download/v0.10.4/nvim-macos-arm64.tar.gz
xattr -c ./nvim-macos-arm64.tar.gz
tar -xzvf nvim-macos-arm64.tar.gz
cd ./nvim-macos-arm64
rsync -a bin ~/.local/
rsync -a lib ~/.local/
rsync -a share ~/.local/

# Install Tmux Plugin Manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Copy Configuration
cd $HOME/projects/dojo
./load-configuration.sh
