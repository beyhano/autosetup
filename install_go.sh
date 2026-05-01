#!/bin/bash

# Go Installation Script
# Based on instructions from go.md

GO_VERSION="1.26.2"
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
DOWNLOAD_URL="https://go.dev/dl/${GO_TARBALL}"

echo "Starting Go installation (version ${GO_VERSION})..."

bootstrap_download_tools() {
    local missing_deps=()

    if ! command -v wget > /dev/null 2>&1; then
        missing_deps+=("wget")
    fi

    if ! command -v wget > /dev/null 2>&1 && ! command -v curl > /dev/null 2>&1; then
        missing_deps+=("curl")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "Installing missing download dependencies: ${missing_deps[*]}..."
        sudo apt-get update && sudo apt-get install -y "${missing_deps[@]}"
    fi
}

download_go() {
    if command -v wget > /dev/null 2>&1; then
        wget -q "$DOWNLOAD_URL" -O "$GO_TARBALL"
    elif command -v curl > /dev/null 2>&1; then
        curl -fsSL "$DOWNLOAD_URL" -o "$GO_TARBALL"
    else
        echo "Error: Neither wget nor curl is installed."
        return 1
    fi
}

bootstrap_download_tools

# 1. Download Go
if [ ! -f "$GO_TARBALL" ]; then
    echo "Downloading Go from ${DOWNLOAD_URL}..."
    download_go
    if [ $? -ne 0 ]; then
        echo "Error: Failed to download Go."
        exit 1
    fi
else
    echo "Tarball ${GO_TARBALL} already exists, skipping download."
fi

# 2. Remove previous installation and extract
echo "Removing any previous Go installation and extracting to /usr/local..."
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf "$GO_TARBALL"

if [ $? -ne 0 ]; then
    echo "Error: Failed to extract Go."
    exit 1
fi

# 3. Add to PATH
PATH_LINE='export PATH=$PATH:/usr/local/go/bin'
PROFILE_FILE="$HOME/.bashrc"

if ! grep -q "/usr/local/go/bin" "$PROFILE_FILE"; then
    echo "Adding Go to PATH in $PROFILE_FILE..."
    echo "" >> "$PROFILE_FILE"
    echo "# Go binary path" >> "$PROFILE_FILE"
    echo "$PATH_LINE" >> "$PROFILE_FILE"
    echo "Go added to PATH."
else
    echo "Go path already exists in $PROFILE_FILE."
fi

# 4. Verify installation (in current shell)
export PATH=$PATH:/usr/local/go/bin
echo "Verifying installation..."
go version

if [ $? -eq 0 ]; then
    echo "Go installation successful!"
    echo "Please run 'source $PROFILE_FILE' or restart your terminal to use 'go' command."
else
    echo "Go installation verification failed."
    exit 1
fi
