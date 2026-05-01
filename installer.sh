#!/bin/sh
# Bootstrap: ensure bash is available, then re-execute.
if [ -z "${BASH_VERSION:-}" ]; then
    if ! command -v bash >/dev/null 2>&1; then
        printf '[INFO] bash is required, installing...\n'
        if [ -f /etc/alpine-release ]; then
            apk add --no-cache bash
        elif command -v apt-get >/dev/null 2>&1; then
            apt-get update && apt-get install -y bash
        elif command -v pacman >/dev/null 2>&1; then
            pacman -Sy --noconfirm bash
        fi
    fi
    exec bash "$0" "$@"
fi

# ==============================================================================
# General Tool Installer Script
# ==============================================================================
# This script provides a modular way to download, install, and configure
# various software tools and system dependencies.
# Supports: Ubuntu/Debian (apt), Alpine Linux (apk), and Arch Linux (pacman).
# ==============================================================================

# --- OS Detection & Package Manager Abstraction ---

PKG_MANAGER=""
PKG_UPDATE=""
PKG_INSTALL=""
PKG_INSTALL_ARGS=""
PROFILE_FILE="$HOME/.bashrc"
SUDO_CMD="sudo"

detect_os() {
    if [ -f /etc/alpine-release ]; then
        PKG_MANAGER="apk"
        PKG_UPDATE="apk update"
        PKG_INSTALL="apk add"
        PKG_INSTALL_ARGS="--no-cache"
        PROFILE_FILE="$HOME/.profile"
        # Alpine may not have sudo; fall back to direct root
        if ! command -v sudo > /dev/null 2>&1; then
            SUDO_CMD=""
        fi
        log_info "Detected Alpine Linux (apk)"
    elif command -v pacman > /dev/null 2>&1; then
        PKG_MANAGER="pacman"
        PKG_UPDATE="pacman -Sy --noconfirm"
        PKG_INSTALL="pacman -S --noconfirm --needed"
        PKG_INSTALL_ARGS=""
        PROFILE_FILE="$HOME/.bashrc"
        SUDO_CMD="sudo"
        log_info "Detected Arch Linux (pacman)"
    elif command -v apt-get > /dev/null 2>&1; then
        PKG_MANAGER="apt"
        PKG_UPDATE="apt-get update"
        PKG_INSTALL="apt-get install -y --no-install-recommends"
        PKG_INSTALL_ARGS=""
        PROFILE_FILE="$HOME/.bashrc"
        SUDO_CMD="sudo"
        log_info "Detected Debian/Ubuntu (apt)"
    else
        log_error "Unsupported distribution. Only apt (Debian/Ubuntu), apk (Alpine), and pacman (Arch) are supported."
        exit 1
    fi
}

# Map Debian package names to distro equivalents
map_pkg() {
    local pkg=$1
    case "$PKG_MANAGER" in
        apk)
            case "$pkg" in
                pkg-config)       echo "pkgconfig" ;;
                libvips-dev)      echo "vips-dev" ;;
                build-essential)  echo "build-base" ;;
                python3-virtualenv) echo "py3-virtualenv" ;;
                python3-dev)      echo "python3-dev" ;;
                php-cli)          echo "php83-cli" ;;
                *)                echo "$pkg" ;;
            esac
            ;;
        pacman)
            case "$pkg" in
                pkg-config)       echo "pkgconf" ;;
                libvips-dev)      echo "libvips" ;;
                build-essential)  echo "base-devel" ;;
                python3-virtualenv) echo "python-virtualenv" ;;
                python3-dev)      echo "python" ;;
                php-cli)          echo "php" ;;
                ca-certificates)  echo "ca-certificates" ;;
                *)                echo "$pkg" ;;
            esac
            ;;
        *)
            echo "$pkg"
            ;;
    esac
}

# --- Helper Functions ---

DRY_RUN=false

parse_args() {
    while [ $# -gt 0 ]; do
        case "$1" in
            --dry-run|-n)
                DRY_RUN=true
                ;;
            --help|-h)
                cat <<'EOF'
Usage: ./installer.sh [--dry-run]

Options:
  -n, --dry-run  Print the commands that would run without changing the system.
  -h, --help     Show this help message.
EOF
                exit 0
                ;;
            *)
                log_error "Unknown argument: $1"
                exit 1
                ;;
        esac
        shift
    done
}

log_info() {
    echo -e "\e[32m[INFO]\e[0m $1"
}

log_error() {
    echo -e "\e[31m[ERROR]\e[0m $1" >&2
}

run_cmd() {
    if [ "$DRY_RUN" = true ]; then
        printf '[DRY-RUN]'
        for arg in "$@"; do
            printf ' %q' "$arg"
        done
        printf '\n'
        return 0
    fi

    "$@"
}

run_shell_cmd() {
    local command_string=$1

    if [ "$DRY_RUN" = true ]; then
        printf '[DRY-RUN] %s\n' "$command_string"
        return 0
    fi

    eval "$command_string"
}

has_downloader() {
    command -v wget > /dev/null 2>&1 || command -v curl > /dev/null 2>&1
}

# Download a file if it doesn't exist
download_tool() {
    local url=$1
    local output=$2
    if [ ! -f "$output" ]; then
        log_info "Downloading from $url..."
        if command -v wget > /dev/null 2>&1; then
            run_cmd wget -q "$url" -O "$output"
        elif command -v curl > /dev/null 2>&1; then
            run_cmd curl -fsSL "$url" -o "$output"
        else
            log_error "No download tool available. Install wget or curl."
            return 1
        fi

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
        run_cmd $SUDO_CMD rm -rf "$target_dir"
    fi

    log_info "Extracting $tarball to $(dirname "$target_dir")..."
    # Ensure parent directory exists
    run_cmd $SUDO_CMD mkdir -p "$(dirname "$target_dir")"
    run_cmd $SUDO_CMD tar -C "$(dirname "$target_dir")" -xzf "$tarball"
    
    if [ $? -ne 0 ]; then
        log_error "Failed to extract $tarball"
        return 1
    fi
    return 0
}

# Add a directory to PATH in profile file if not already present
update_bash_path() {
    local bin_path=$1
    local profile_file="${2:-$PROFILE_FILE}"
    local path_line="export PATH=\$PATH:$bin_path"

    if [ ! -f "$profile_file" ]; then
        log_info "$profile_file does not exist, creating it..."
        run_cmd touch "$profile_file"
    fi

    if ! grep -q "$bin_path" "$profile_file"; then
        log_info "Adding $bin_path to PATH in $profile_file..."
        run_shell_cmd "printf '\n# Added by General Installer\n%s\n' \"$path_line\" >> \"$profile_file\""
    else
        log_info "$bin_path is already in $profile_file PATH."
    fi
}

# --- System Dependencies ---

install_system_deps() {
    log_info "--- Installing System Dependencies ($PKG_MANAGER) ---"
    
    # Based on linux.md and additional requirements
    log_info "Updating package lists..."
    run_cmd $SUDO_CMD $PKG_UPDATE
    
    log_info "Installing system packages..."
    local pkgs=(
        ca-certificates
        git
        pkg-config
        libvips-dev
        curl
        wget
        build-essential
        python3
        python3-dev
        python3-virtualenv
        supervisor
        php-cli
    )
    
    local mapped_pkgs=()
    for p in "${pkgs[@]}"; do
        mapped_pkgs+=("$(map_pkg "$p")")
    done
    
    run_cmd $SUDO_CMD $PKG_INSTALL $PKG_INSTALL_ARGS "${mapped_pkgs[@]}"
    
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
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Would verify Go with: PATH=\$PATH:$bin_dir go version"
    else
        export PATH=$PATH:$bin_dir
        go version
    fi
}

# --- Tool Specific Installation: Rust ---

install_rust() {
    log_info "--- Installing Rust (rustup) ---"
    
    # Rust is usually installed via rustup script
    if ! command -v rustup &> /dev/null; then
        log_info "Downloading and running rustup installer..."
        # -s -- -y is used for non-interactive installation
        run_shell_cmd "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y"
        
        if [ $? -ne 0 ]; then
            log_error "Failed to install Rust via rustup."
            return 1
        fi
    else
        log_info "Rust is already installed, updating..."
        run_cmd rustup update
    fi

    # Add Cargo bin to PATH
    local cargo_bin="$HOME/.cargo/bin"
    update_bash_path "$cargo_bin"
    
    # Verify in current session
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Would verify Rust with: PATH=\$PATH:$cargo_bin rustc --version"
    else
        export PATH="$PATH:$cargo_bin"
        rustc --version
    fi
}

# --- Main Execution ---

# Check for and bootstrap core dependencies needed by the script itself
bootstrap_dependencies() {
    local missing_deps=()
    for cmd in tar grep; do
        if ! command -v $cmd &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done

    # sudo is only required on non-Alpine systems
    if [ "$PKG_MANAGER" != "apk" ]; then
        if ! command -v sudo &> /dev/null; then
            missing_deps+=("sudo")
        fi
    fi

    if ! command -v wget &> /dev/null; then
        missing_deps+=("wget")
    fi

    if ! has_downloader; then
        missing_deps+=("curl")
    fi

    if [ ${#missing_deps[@]} -gt 0 ]; then
        log_info "Missing core dependencies: ${missing_deps[*]}. Attempting to install..."
        run_cmd $SUDO_CMD $PKG_UPDATE
        run_cmd $SUDO_CMD $PKG_INSTALL $PKG_INSTALL_ARGS "${missing_deps[@]}"
        
        if [ $? -ne 0 ]; then
            log_error "Failed to install required dependencies: ${missing_deps[*]}. Please install them manually."
            exit 1
        fi
    fi
}

parse_args "$@"

detect_os

bootstrap_dependencies

# 1. Install System Dependencies
install_system_deps

# 2. Install Tools
install_go
install_rust

log_info "Installation process completed."

# Apply changes to the current script environment
if [ -f "$PROFILE_FILE" ]; then
    log_info "Sourcing $PROFILE_FILE..."
    if [ "$DRY_RUN" = true ]; then
        log_info "[DRY-RUN] Would source $PROFILE_FILE"
    else
        source "$PROFILE_FILE"
    fi
fi

log_info "All tools are installed and PATH is updated."
log_info "NOTE: If you ran this script as './installer.sh', please run 'source $PROFILE_FILE' MANUALLY to use the tools in this session."
log_info "Alternatively, you can run the script as 'source ./installer.sh' next time."
