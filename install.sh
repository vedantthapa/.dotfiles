#!/bin/bash
set -euxo pipefail

# install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # add Homebrew to PATH based on the operating system
    if [[ "$(uname -s)" == "Darwin" ]]; then
        # macOS
        export PATH="/opt/homebrew/bin:$PATH"  # Handles both Apple Silicon and Intel Macs
    else
        # Linux
        export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    fi

else
    echo "Homebrew is already installed."
fi

# tap Homebrew Bundle and install from Brewfile
brew tap Homebrew/bundle
if [[ -f ./Brewfile ]]; then
    brew bundle install --file=./Brewfile
else
    echo "Brewfile not found, skipping."
fi

# add zsh as a login shell
if ! grep -q "$(command -v zsh)" /etc/shells; then
    echo "Adding zsh to the list of login shells..."
    command -v zsh | sudo tee -a /etc/shells
fi

# set zsh as the default shell
if [[ "$SHELL" != "$(command -v zsh)" ]]; then
    echo "Setting zsh as the default shell..."
    sudo chsh -s "$(which zsh)" "$USER"
else
    echo "zsh is already the default shell."
fi

# install Oh My Zsh
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# install powerlevel10k
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# install LunarVim
if [[ ! -d "$HOME/.local/share/lunarvim" ]]; then
    echo "Installing LunarVim..."
    LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
    export PATH=/home/cloud_user/.local/bin:$PATH
else
    echo "LunarVim is already installed."
fi

# prevent stow conflicts
rm -rf ~/.zshrc ~/.config/lvim

# symlink configs using stow
if command -v stow &>/dev/null; then
    echo "Symlinking configuration files with stow..."
    stow .
else
    echo "GNU Stow is not installed. Please install it and run the script again."
    exit 1
fi

# setup tmux plugins
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    echo "Installing tmux plugin manager (tpm)..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
    echo "tmux plugin manager (tpm) is already installed."
fi

echo "Setup completed successfully!"
