#!/usr/bin/env bash
set -euo pipefail

# Popular AUR helpers: yay, paru, trizen, pikaur, aurutils
HELPERS=(yay paru trizen pikaur aurutils)

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${GREEN}[+]${NC} $*"; }
warn()    { echo -e "${YELLOW}[!]${NC} $*"; }
error()   { echo -e "${RED}[-]${NC} $*" >&2; }

if [[ $EUID -eq 0 ]]; then
    error "Do not run as root. Run as a regular user with sudo privileges."
    exit 1
fi

if ! command -v pacman &>/dev/null; then
    error "This script requires Arch Linux (pacman not found)."
    exit 1
fi

info "Installing build dependencies..."
sudo pacman -S --needed --noconfirm base-devel git

install_from_aur() {
    local name=$1

    if command -v "$name" &>/dev/null; then
        warn "$name is already installed, skipping."
        return 0
    fi

    info "Installing $name..."
    local tmpdir
    tmpdir=$(mktemp -d)
    trap "rm -rf '$tmpdir'" RETURN

    if ! git clone "https://aur.archlinux.org/${name}.git" "$tmpdir/$name"; then
        error "Failed to clone $name from AUR."
        return 1
    fi

    if ! (cd "$tmpdir/$name" && makepkg -si --noconfirm); then
        error "Failed to build/install $name."
        return 1
    fi

    info "$name installed successfully."
}

failed=()

for helper in "${HELPERS[@]}"; do
    if ! install_from_aur "$helper"; then
        failed+=("$helper")
    fi
done

echo
if [[ ${#failed[@]} -eq 0 ]]; then
    info "All AUR helpers installed successfully."
else
    warn "The following helpers failed to install: ${failed[*]}"
    exit 1
fi
