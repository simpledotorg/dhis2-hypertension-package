#!/bin/bash

# Function to install pgFormatter on Debian/Ubuntu-based systems
install_pgformatter_debian() {
    echo "Detected Debian/Ubuntu-based system."
    echo "Updating package lists..."
    sudo apt-get update
    echo "Installing pgFormatter..."
    sudo apt-get install -y pgformatter
    echo "pgFormatter installation complete."
}

# Function to install pgFormatter on macOS
install_pgformatter_macos() {
    echo "Detected macOS."
    echo "Checking for Homebrew..."
    if ! command -v brew &> /dev/null
    then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    echo "Installing pgFormatter..."
    brew install pgformatter
    echo "pgFormatter installation complete."
}

# Detect the operating system and install pgFormatter accordingly
if [ -f /etc/os-release ]; then
    . /etc/os-release
    case "$ID" in
        ubuntu|debian)
            install_pgformatter_debian
            ;;
        *)
            echo "Unsupported Linux distribution: $ID"
            exit 1
            ;;
    esac
elif [ "$(uname)" == "Darwin" ]; then
    install_pgformatter_macos
else
    echo "Unsupported operating system: $(uname)"
    exit 1
fi

# Verify installation
if command -v pg_format &> /dev/null
then
    echo "pgFormatter successfully installed."
else
    echo "pgFormatter installation failed."
    exit 1
fi
