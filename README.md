# Arch AUR Helper Installer

A bash script that automatically installs the most popular AUR helpers on Arch Linux.

## What it installs

| Helper | Language | Description |
|--------|----------|-------------|
| [yay](https://github.com/Jguer/yay) | Go | Most popular AUR helper, drop-in pacman wrapper |
| [paru](https://github.com/morganamilo/paru) | Rust | Feature-rich helper, considered yay's successor |
| [trizen](https://github.com/trizen/trizen) | Perl | Lightweight with minimal dependencies |
| [pikaur](https://github.com/actionless/pikaur) | Python | Minimal, no AUR dependencies to install it |
| [aurutils](https://github.com/AladW/aurutils) | Bash | Collection of utilities rather than a single helper |

## Requirements

- Arch Linux (or an Arch-based distro with `pacman`)
- A regular user account with `sudo` privileges
- Internet connection

## Usage

```bash
bash install-aur-helpers.sh
```

The script will:
1. Refuse to run as root
2. Install `base-devel` and `git` via pacman if not already present
3. Clone and build each AUR helper from source using `makepkg`
4. Skip any helper that is already installed
5. Report any failures at the end without stopping early

## Notes

- Do **not** run as root. `makepkg` requires a normal user.
- Each helper is built from its official AUR PKGBUILD — no third-party binaries.
- If a helper fails to install, the script continues with the rest and exits with a non-zero code at the end.
