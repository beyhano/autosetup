#!/bin/bash

# ==============================================================================
# General Tool Installer Script
# ==============================================================================
# This script provides a modular way to download, install, and configure
# various software tools and system dependencies.
# ==============================================================================

# --- Helper Functions ---

log_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

log_error() {
    echo -e "\e[31m[ERROR]\e[0m $1" >&2
}

# Download a file if it doesn't exist
download_tool() {
    local url=$1
    local output=$2
    if [ ! -f "$output" ]; then
        log_info "Downloading from $url..."
        wget -q "$url" -O "$output"
        if [ $? -ne 0 ]; then
            log_error "Failed to download $url"
            return 1
        fi
    else
        log_info "$output already exists, skipping download."
    fi
    return 0
}

# Extract and install to a target directory
install_tarball() {
    local tarball=$1
    local target_dir=$2
    local remove_old=$3 # Boolean: true/false

    if [ "$remove_old" = true ]; then
        log_info "Removing old installation at $target_dir..."
        sudo rm -rf "$target_dir"
    fi

    log_info "Extracting $tarball to $(dirname "$target_dir")..."
    # Ensure parent directory exists
    sudo mkdir -p "$(dirname "$target_dir")"
    sudo tar -C "$(dirname "$target_dir")" -xzf "$tarball"
    
    if [ $? -ne 0 ]; then
        log_error "Failed to extract $tarball"
        return 1
    fi
    return 0
}

# Add a directory to PATH in .bashrc if not already present
update_bash_path() {
    local bin_path=$1
    local profile_file="${2:-$HOME/.bashrc}"
    local path_line="export PATH=\$PATH:$bin_path"

    if ! grep -q "$bin_path" "$profile_file"; then
        log_info "Adding $bin_path to PATH in $profile_file..."
        echo "" >> "$profile_file"
        echo "# Added by General Installer" >> "$profile_file"
        echo "$path_line" >> "$profile_file"
    else
        log_info "$bin_path is already in $profile_file PATH."
    fi
}

# --- System Dependencies ---

install_system_deps() {
    log_info "--- Installing System Dependencies (apt) ---"
    
    # Based on linux.md requirements
    log_info "Updating package lists..."
    sudo apt-get update
    
    log_info "Installing: ca-certificates, git, pkg-config, libvips-dev..."
    sudo apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        pkg-config \
        libvips-dev
    
    if [ $? -ne 0 ]; then
        log_error "Failed to install system dependencies."
        return 1
    fi
    return 0
}

# --- Tool Specific Installation: Go ---

install_go() {
    local version="1.26.2"
    local tarball="go${version}.linux-amd64.tar.gz"
    local url="https://go.dev/dl/${tarball}"
    local target="/usr/local/go"
    local bin_dir="/usr/local/go/bin"

    log_info "--- Installing Go $version ---"
    
    download_tool "$url" "$tarball" || return 1
    install_tarball "$tarball" "$target" true || return 1
    update_bash_path "$bin_dir"
    
    # Verify in current session
    export PATH=$PATH:$bin_dir
    go version
}

# --- Main Execution ---

# Check for dependencies needed by the script itself
for cmd in wget tar sudo grep; do
    if ! command -v $cmd &> /dev/null; then
        log_error "Dependency '$cmd' is missing. Please install it."
        exit 1
    fi
done

# 1. Install System Dependencies
install_system_deps

# 2. Install Tools
install_go

log_info "Installation process completed."
log_info "Please run 'source ~/.bashrc' to apply PATH changes."
