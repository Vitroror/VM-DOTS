#!/usr/bin/env bash
# Bootstrap the Magala Hyprland rice on a fresh Arch Linux installation.
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$ROOT_DIR/dotfiles"
SYSTEM_DIR="$ROOT_DIR/system"

OFFICIAL_PACKAGES=(
  hyprland hyprlock hyprpaper waybar swaync wlogout hyprshot cava
  pipewire pipewire-pulse wireplumber pamixer libpulse playerctl
  kitty fish thunar blueman networkmanager network-manager-applet
  nm-connection-editor iwd impala libnotify lm_sensors btop curl kvantum pacman-contrib
  nwg-look papirus-icon-theme materia-gtk-theme ttf-font-awesome
  ttf-jetbrains-mono-nerd wl-clipboard brightnessctl sddm stow
  bluetui wiremix
)

AUR_PACKAGES=(fsel-bin nordzy-icon-theme hyprmod)
DOTFILE_PACKAGES=(Kvantum btop cava fish fsel gtk-3.0 gtk-4.0 hypr kitty micro nwg-look swaync waybar wlogout)

die() { printf 'Error: %s\n' "$*" >&2; exit 1; }
info() { printf '\n==> %s\n' "$*"; }

[[ $EUID -ne 0 ]] || die "Run this as your normal desktop user, not root."
[[ -d "$DOTFILES_DIR" ]] || die "Missing dotfiles directory: $DOTFILES_DIR"
[[ -d "$SYSTEM_DIR" ]] || die "Missing system configuration directory: $SYSTEM_DIR"
command -v pacman >/dev/null || die "This installer supports Arch Linux only."

info "Installing base tools"
sudo pacman -Syu --needed --noconfirm git base-devel stow

if ! command -v yay >/dev/null; then
  info "Installing yay"
  build_dir="$(mktemp -d)"
  trap 'rm -rf "$build_dir"' EXIT
  git clone https://aur.archlinux.org/yay.git "$build_dir/yay"
  (cd "$build_dir/yay" && makepkg -si --noconfirm)
fi

info "Installing official packages"
sudo pacman -S --needed --noconfirm "${OFFICIAL_PACKAGES[@]}"

info "Installing AUR packages"
yay -S --needed --noconfirm "${AUR_PACKAGES[@]}"

info "Applying IWD and NetworkManager configuration"
sudo install -Dm644 "$SYSTEM_DIR/etc/iwd/main.conf" /etc/iwd/main.conf
sudo install -Dm644 "$SYSTEM_DIR/etc/NetworkManager/conf.d/20-iwd-standalone.conf" /etc/NetworkManager/conf.d/20-iwd-standalone.conf

info "Stowing user configuration"
stow -d "$DOTFILES_DIR" -t "$HOME" "${DOTFILE_PACKAGES[@]}"

info "Stowing the SDDM theme"
sudo stow -d "$DOTFILES_DIR" -t / sddm

info "Enabling system services"
sudo systemctl enable iwd.service NetworkManager.service systemd-resolved.service NetworkManager-wait-online.service sddm.service

info "Applying desktop defaults"
gsettings set org.gnome.desktop.interface gtk-theme 'Materia-dark-compact'
gsettings set org.gnome.desktop.interface icon-theme 'Nordzy-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != "$(command -v fish)" ]]; then
  chsh -s "$(command -v fish)" "$USER"
fi

cat <<'EOF'

Installation complete. Reboot before logging in to Hyprland.

Notes:
- IWD manages Wi-Fi; NetworkManager manages Ethernet. Wi-Fi credentials are
  deliberately not included and must be joined on the new machine.
- The Hyprland monitor definitions are hardware-specific. Adjust them after
  first boot if the new machine has different monitor names or resolutions.
EOF
