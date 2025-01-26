#!/bin/bash
set -euo pipefail

# install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."

    if [[ "$(uname -s)" == "Darwin" ]]; then
        # macOS
        echo "Installing MacOS dependencies..."
        xcode-select --install
    else
        # Linux
        echo "Installing Linux dependencies..."
        sudo apt-get -y update
        sudo apt-get -y install build-essential procps curl file git
    fi
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    echo "Homebrew is already installed."
fi

# add Homebrew to PATH based on the operating system
echo "Adding Homebrew to PATH..."
if [[ "$(uname -s)" == "Darwin" ]]; then
    # macOS
    export PATH="/opt/homebrew/bin:$PATH"
else
    # Linux
    test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
    test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bashrc
fi

# tap Homebrew Bundle and install from Brewfile
brew tap Homebrew/bundle
if [[ -f ./Brewfile ]]; then
    brew bundle install --file=./Brewfile
else
    echo "Brewfile not found, skipping."
fi

# install LunarVim
if [[ ! -d "$HOME/.local/share/lunarvim" ]]; then
    echo "Installing LunarVim..."
    LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh)
else
    echo "LunarVim is already installed."
fi

# prevent stow conflicts
rm -rf ~/.config/lvim/

# symlink configs using stow
if command -v stow &>/dev/null; then
    echo "Symlinking configuration files with stow..."
    stow -R .
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

echo "Setup completed successfully!"
