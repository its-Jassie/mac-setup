#!/bin/bash

# Function to install multiple packages if they're not already installed
install_packages() {
    for package_name in "$@"; do
        if brew list "$package_name" &>/dev/null; then
            echo "$package_name is already installed."
        else
            echo "Installing $package_name..."
            brew install "$package_name"
        fi
    done
}

# Function to install multiple casks if they're not already installed
install_casks() {
    for package_name in "$@"; do
        if brew list --cask "$package_name" &>/dev/null; then
            echo "$package_name is already installed."
        else
            echo "Installing $package_name..."
            brew install --cask "$package_name"
        fi
    done
}

# Function to install multiple App Store apps if they're not already installed
install_mas() {
    for app_id in "$@"; do
        app_name=$(mas info $app_id | head -n 1)
        if mas list | grep -q $app_id; then
            echo "$app_name is already installed."
        else
            echo "Installing $app_name..."
            mas install $app_id
        fi
    done
}

# Check if Homebrew is installed
if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed."
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    (echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/justinhunkele/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

brew --version

# Install multiple casks
install_casks firefox discord visual-studio-code

# Install multiple packages
install_packages git neovim ripgrep bat fish mas

# Install multiple app store apps (mas)
install_mas 

# Find the Fish shell executable
FISH_PATH=$(which fish)

# Check if Fish is already the default shell
if [ "$SHELL" = "$FISH_PATH" ]; then
    echo "Fish is already the default shell."
else
    # Add Fish to the list of approved shells, if not already present
    if ! grep -Fxq "$FISH_PATH" /etc/shells; then
        echo "Adding Fish to the list of approved shells..."
        echo "$FISH_PATH" | sudo tee -a /etc/shells
    fi

    # Change the default shell to Fish
    echo "Setting Fish as the default shell..."
    sudo chsh -s "$FISH_PATH" $(whoami)
    echo "Fish shell is now set as your default shell."
fi
