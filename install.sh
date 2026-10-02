#!/usr/bin/env bash
#
# Automated installation script for Fedora Hyprland dotfiles
# Repo: https://github.com/Metall-Moses/dotfiles
#

set -euo pipefail

# --- Color formatting ---
BOLD="\033[1m"
GREEN="\033[32m"
BLUE="\033[34m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

log_info()    { echo -e "${BLUE}${BOLD}[INFO]${RESET} $1"; }
log_success() { echo -e "${GREEN}${BOLD}[OK]${RESET} $1"; }
log_warn()    { echo -e "${YELLOW}${BOLD}[WARN]${RESET} $1"; }
log_err()     { echo -e "${RED}${BOLD}[ERROR]${RESET} $1"; }

# --- Sanity checks ---
if [ "$(id -u)" -eq 0 ]; then
    log_err "Do not run this script as root or with sudo."
    log_err "The script will request sudo privileges when needed for dnf."
    exit 1
fi

if [ ! -f /etc/fedora-release ]; then
    log_warn "This script is tailored for Fedora Linux. Proceeding anyway..."
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

log_info "Starting dotfiles setup from: ${DOTFILES_DIR}"

# --- 1. Enable Hyprland Copr & Install Dependencies ---
log_info "Checking Fedora package repositories..."
if ! dnf repolist | grep -q "copr:copr.fedorainfracloud.org:lionheartp:Hyprland"; then
    log_info "Enabling lionheartp/Hyprland Copr repository..."
    sudo dnf copr enable -y lionheartp/Hyprland
fi

PACKAGES=(
    # Compositor & Portal
    hyprland
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk

    # Desktop UI & Utilities
    noctalia
    alacritty
    nautilus
    rofi
    cliphist
    hyprshot
    wf-recorder
    slurp
    libnotify
    blueman
    hyprpaper

    # CLI & Editors
    neovim
    tmux
    zsh
    stow
    git
    curl
)

log_info "Installing required packages via dnf..."
sudo dnf install -y "${PACKAGES[@]}"
log_success "Packages installed successfully."

# --- 2. Configure screensharing (systemd target) ---
log_info "Configuring hyprland-session.target for screensharing..."
SYSTEMD_USER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user"
mkdir -p "$SYSTEMD_USER_DIR"

cat > "${SYSTEMD_USER_DIR}/hyprland-session.target" << 'EOF'
[Unit]
Description=Hyprland session
BindsTo=graphical-session.target
Wants=graphical-session-pre.target
After=graphical-session-pre.target
PropagatesStopTo=graphical-session.target
EOF

systemctl --user daemon-reload
log_success "Systemd user target configured."

# --- 3. TPM (Tmux Plugin Manager) Setup ---
TPM_DIR="$HOME/.tmux/plugins/tpm"
if [ ! -d "$TPM_DIR" ]; then
    log_info "Cloning Tmux Plugin Manager (TPM)..."
    mkdir -p "$HOME/.tmux/plugins"
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    log_success "TPM installed."
else
    log_info "TPM already installed. Skipping."
fi

# --- 4. Apply Stow symlinks ---
log_info "Deploying dotfiles using GNU Stow..."

# Ensure target directories exist so stow links individual config files
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/Pictures/wallpapers" "$HOME/Videos"

STOW_PKGS=(
    hyprland
    alacritty
    nvim
    tmux
    recorder
    wallpapers
)

for pkg in "${STOW_PKGS[@]}"; do
    if [ -d "$DOTFILES_DIR/$pkg" ]; then
        log_info "Stowing package: $pkg"
        stow -R "$pkg" -t "$HOME"
    else
        log_warn "Package directory '$pkg' not found in $DOTFILES_DIR. Skipping."
    fi
done

log_success "GNU Stow completed."

# Ensure recorder script has execution permissions if present
if [ -f "$HOME/.local/bin/record-screen.sh" ]; then
    chmod +x "$HOME/.local/bin/record-screen.sh"
fi

# --- 5. Shell configuration ---
CURRENT_SHELL="$(basename "$SHELL")"
if [ "$CURRENT_SHELL" != "zsh" ]; then
    ZSH_PATH="$(which zsh)"
    log_info "Current shell is $CURRENT_SHELL. Switching default shell to $ZSH_PATH..."
    chsh -s "$ZSH_PATH"
    log_success "Default shell changed to zsh."
else
    log_info "Default shell is already zsh."
fi

# --- 6. Done ---
echo ""
echo -e "${GREEN}${BOLD}========================================${RESET}"
echo -e "${GREEN}${BOLD} Installation Complete!                ${RESET}"
echo -e "${GREEN}${BOLD}========================================${RESET}"
echo ""
echo -e "${YELLOW}IMPORTANT NOTICE:${RESET}"
echo "1. Remember to check and adjust monitor outputs in ~/.config/hypr/hyprland.lua"
echo "2. Inside tmux, press 'prefix + I' (Ctrl+s followed by Shift+i) to fetch plugins."
echo "3. Please reboot your machine to finalize display manager and portal setup:"
echo "   sudo reboot now"
echo ""
