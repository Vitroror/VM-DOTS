#!/usr/bin/env bash
# Conservative Arch Linux maintenance helper. Nothing destructive is automatic.
set -Eeuo pipefail

if [[ -t 1 ]]; then
  RED=$'\033[31m'; GREEN=$'\033[32m'; YELLOW=$'\033[33m'; BLUE=$'\033[34m'; CYAN=$'\033[36m'; RESET=$'\033[0m'
else
  RED= GREEN= YELLOW= BLUE= CYAN= RESET=
fi

info() { printf '%s%s%s\n' "$BLUE" "$*" "$RESET"; }
warn() { printf '%s%s%s\n' "$YELLOW" "$*" "$RESET"; }
ok() { printf '%s%s%s\n' "$GREEN" "$*" "$RESET"; }
error() { printf '%s%s%s\n' "$RED" "$*" "$RESET" >&2; }
divider() { printf '%s%s%s\n' "$CYAN" '----------------------------------------' "$RESET"; }

confirm() {
  local answer
  read -r -p "$1 [y/N] " answer
  [[ "$answer" =~ ^[Yy]([Ee][Ss])?$ ]]
}

require_sudo() { sudo -v; }

orphans=()
load_orphans() {
  mapfile -t orphans < <(pacman -Qdtq 2>/dev/null || true)
}

show_status() {
  info 'System maintenance status'
  df -h / | tail -n 1
  printf 'Pacman cache: '; du -sh /var/cache/pacman/pkg 2>/dev/null || printf 'unavailable\n'
  printf 'Journal usage: '; journalctl --disk-usage 2>/dev/null || printf 'unavailable\n'
  printf 'User cache: '; du -sh "$HOME/.cache" 2>/dev/null || printf 'none\n'

  load_orphans
  if ((${#orphans[@]})); then
    warn "Orphan candidates (${#orphans[@]}): ${orphans[*]}"
  else
    ok 'No orphan packages reported.'
  fi

  if [[ -d "$HOME/Downloads" ]]; then
    local old_downloads
    old_downloads=$(find "$HOME/Downloads" -type f -mtime +30 -printf . 2>/dev/null | wc -c)
    printf 'Downloads older than 30 days: %s file(s)\n' "$old_downloads"
  fi
}

safe_cleanup() {
  info 'Safe cleanup: retain package rollback cache, vacuum old journal logs.'
  require_sudo

  if command -v paccache >/dev/null; then
    sudo paccache -r
    ok 'Pacman cache trimmed; recent package versions were retained.'
  else
    warn 'paccache is unavailable. Install pacman-contrib to enable safe cache trimming.'
  fi

  sudo journalctl --vacuum-time=2weeks
  load_orphans
  if ((${#orphans[@]})); then
    warn "Orphans were not removed automatically: ${orphans[*]}"
  fi
}

remove_orphans() {
  load_orphans
  if ((${#orphans[@]} == 0)); then
    ok 'No orphan packages to remove.'
    return
  fi

  warn "The following packages will be removed with unused dependencies:"
  printf '  %s\n' "${orphans[@]}"
  if confirm 'Remove exactly these packages?'; then
    require_sudo
    sudo pacman -Rns -- "${orphans[@]}"
  else
    info 'Cancelled.'
  fi
}

clear_user_cache() {
  [[ -d "$HOME/.cache" ]] || { ok 'No user cache directory.'; return; }
  warn "Current user cache size: $(du -sh "$HOME/.cache" 2>/dev/null | cut -f1)"
  warn 'Quit applications that may be using their cache before continuing.'
  if confirm "Delete the contents of $HOME/.cache?"; then
    find "$HOME/.cache" -mindepth 1 -maxdepth 1 -exec rm -rf -- {} +
    ok 'User cache contents removed.'
  else
    info 'Cancelled.'
  fi
}

delete_old_downloads() {
  local -a files=()
  [[ -d "$HOME/Downloads" ]] || { ok 'No Downloads directory.'; return; }
  mapfile -d '' -t files < <(find "$HOME/Downloads" -type f -mtime +30 -print0)
  if ((${#files[@]} == 0)); then
    ok 'No files older than 30 days in Downloads.'
    return
  fi

  warn 'Files older than 30 days:'
  printf '  %s\n' "${files[@]}"
  if confirm "Permanently delete these ${#files[@]} file(s)?"; then
    printf '%s\0' "${files[@]}" | xargs -0 rm -f --
    ok 'Old download files removed.'
  else
    info 'Cancelled.'
  fi
}

verify_packages() {
  info 'Checking package-owned files (this does not modify anything).'
  if sudo pacman -Qk; then
    ok 'Package ownership check completed.'
  else
    warn 'Some package files may be missing. Review the output before reinstalling anything.'
  fi
}

update_system() {
  require_sudo
  sudo pacman -Syu
  if command -v yay >/dev/null && confirm 'Also update AUR packages with yay?'; then
    yay -Syu
  elif command -v paru >/dev/null && confirm 'Also update AUR packages with paru?'; then
    paru -Syu
  fi
}

update_flatpaks() {
  if ! command -v flatpak >/dev/null; then
    warn 'Flatpak is not installed.'
    return
  fi
  flatpak update
}

while true; do
  divider
  printf '%sArch Linux Maintenance%s\n' "$CYAN" "$RESET"
  printf '%s\n' \
    '1) Show status (read-only)' \
    '2) Safe cleanup: trim cache and vacuum journal' \
    '3) Review and remove orphan packages' \
    '4) Clear user cache (confirmed)' \
    '5) Review and delete old download files' \
    '6) Verify package-owned files (read-only)' \
    '7) Update system and optionally AUR packages' \
    '8) Update Flatpaks' \
    '0) Exit'
  read -r -p 'Select an option: ' choice
  case "$choice" in
    1) show_status ;;
    2) safe_cleanup ;;
    3) remove_orphans ;;
    4) clear_user_cache ;;
    5) delete_old_downloads ;;
    6) verify_packages ;;
    7) update_system ;;
    8) update_flatpaks ;;
    0) exit 0 ;;
    *) error 'Invalid option.' ;;
  esac
done
