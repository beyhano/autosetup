#!/bin/bash

# Go Installation Script
# Based on instructions from go.md
# Supports: Ubuntu/Debian (apt), Alpine Linux (apk), Arch Linux (pacman)

GO_VERSION="1.26.2"
GO_TARBALL="go${GO_VERSION}.linux-amd64.tar.gz"
DOWNLOAD_URL="https://go.dev/dl/${GO_TARBALL}"

echo "Starting Go installation (version ${GO_VERSION})..."

# --- OS Detection ---
detect_pkg_manager() {
    if [ -f /etc/alpine-release ]; then
        PKG_UPDATE="apk update"
        PKG_INSTALL="apk add --no-cache"
        PROFILE_FILE="$HOME/.profile"
        SUDO_CMD=""
        command -v sudo > /dev/null 2>&1 && SUDO_CMD="sudo"
        echo "Detected Alpine Linux (apk)"
    elif command -v pacman > /dev/null 2>&1; then
        PKG_UPDATE="pacman -Sy --noconfirm"
        PKG_INSTALL="pacman -S --noconfirm --needed"
        PROFILE_FILE="$HOME/.bashrc"
        SUDO_CMD="sudo"
        echo "Detected Arch Linux (pacman)"
    elif command -v apt-get > /dev/null 2>&1; then
        PKG_UPDATE="apt-get update"
        PKG_INSTALL="apt-get install -y --no-install-recommends"
        PROFILE_FILE="$HOME/.bashrc"
        SUDO_CMD="sudo"
        echo "Detected Debian/Ubuntu (apt)"
    else
        echo "Error: Unsupported distribution."
        exit 1
    fi
}

detect_pkg_manager

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
        $SUDO_CMD $PKG_UPDATE && $SUDO_CMD $PKG_INSTALL "${missing_deps[@]}"
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
$SUDO_CMD rm -rf /usr/local/go && $SUDO_CMD tar -C /usr/local -xzf "$GO_TARBALL"

if [ $? -ne 0 ]; then
    echo "Error: Failed to extract Go."
    exit 1
fi

# 3. Add to PATH
PATH_LINE='export PATH=$PATH:/usr/local/go/bin'

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
