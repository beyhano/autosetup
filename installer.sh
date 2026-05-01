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
    
    # Based on linux.md and additional requirements
    log_info "Updating package lists..."
    sudo apt-get update
    
    log_info "Installing system packages..."
    sudo apt-get install -y --no-install-recommends \
        ca-certificates \
        git \
        pkg-config \
        libvips-dev \
        curl \
        wget \
        build-essential \
        python3 \
        python3-dev \
        python3-virtualenv \
        supervisor \
        php-cli
    
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

# --- Tool Specific Installation: Rust ---

install_rust() {
    log_info "--- Installing Rust (rustup) ---"
    
    # Rust is usually installed via rustup script
    if ! command -v rustup &> /dev/null; then
        log_info "Downloading and running rustup installer..."
        # -s -- -y is used for non-interactive installation
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        
        if [ $? -ne 0 ]; then
            log_error "Failed to install Rust via rustup."
            return 1
        fi
    else
        log_info "Rust is already installed, updating..."
        rustup update
    fi

    # Add Cargo bin to PATH
    local cargo_bin="$HOME/.cargo/bin"
    update_bash_path "$cargo_bin"
    
    # Verify in current session
    export PATH="$PATH:$cargo_bin"
    rustc --version
}

# --- Main Execution ---

# Check for and bootstrap core dependencies needed by the script itself
bootstrap_dependencies() {
    local missing_deps=()
    for cmd in wget tar sudo grep curl; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_info "Missing core dependencies: ${missing_deps[*]}. Attempting to install..."
        sudo apt-get update
        sudo apt-get install -y "${missing_deps[@]}"
        
        if [ $? -ne 0 ]; then
            log_error "Failed to install required dependencies: ${missing_deps[*]}. Please install them manually."
            exit 1
        fi
    fi
}

bootstrap_dependencies

# 1. Install System Dependencies
install_system_deps

# 2. Install Tools
install_go
install_rust

log_info "Installation process completed."

# Apply changes to the current script environment
if [ -f "$HOME/.bashrc" ]; then
    log_info "Sourcing $HOME/.bashrc..."
    source "$HOME/.bashrc"
fi

log_info "All tools are installed and PATH is updated."
log_info "NOTE: If you ran this script as './installer.sh', please run 'source ~/.bashrc' MANUALLY to use the tools in this session."
log_info "Alternatively, you can run the script as 'source ./installer.sh' next time."
