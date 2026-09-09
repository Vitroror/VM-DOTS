#!/usr/bin/env bash
# Deploy the SDDM theme as system files. SDDM cannot read a theme symlinked
# into a private home directory because the greeter runs as a different user.
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$ROOT_DIR/dotfiles"
PACKAGE_DIR="$DOTFILES_DIR/sddm"
THEME_SOURCE="$PACKAGE_DIR/usr/share/sddm/themes/dresden-tahoe"
THEME_TARGET="/usr/share/sddm/themes/dresden-tahoe"
CONF_SOURCE="$PACKAGE_DIR/etc/sddm.conf.d/10-dresden-tahoe.conf"
CONF_TARGET="/etc/sddm.conf.d/10-dresden-tahoe.conf"

[[ -f "$CONF_SOURCE" ]] || { printf 'Missing SDDM configuration source.\n' >&2; exit 1; }
[[ -f "$THEME_SOURCE/Main.qml" ]] || { printf 'Missing SDDM theme source.\n' >&2; exit 1; }

# Migrate installations that previously deployed this package with Stow.
if [[ -L "$CONF_TARGET" || -L "$THEME_TARGET/Main.qml" ]]; then
  sudo stow -D -d "$DOTFILES_DIR" -t / sddm
fi

sudo install -Dm644 "$CONF_SOURCE" "$CONF_TARGET"
sudo rm -rf "$THEME_TARGET"
sudo install -d -m 755 "$THEME_TARGET"
sudo cp -rT "$THEME_SOURCE" "$THEME_TARGET"
sudo chown -R root:root "$THEME_TARGET"
sudo chmod -R a+rX "$THEME_TARGET"

printf 'Deployed SDDM theme: %s\n' "$THEME_TARGET"
