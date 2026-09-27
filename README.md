# dotfiles

[![Last Commit](https://img.shields.io/github/last-commit/Metall-Moses/dotfiles?style=flat-square&color=a6da95)](https://github.com/Metall-Moses/dotfiles/commits/main)
[![Repo Size](https://img.shields.io/github/repo-size/Metall-Moses/dotfiles?style=flat-square&color=8aadf4)](https://github.com/Metall-Moses/dotfiles)
[![Fedora](https://img.shields.io/badge/Fedora-51A2DA?style=flat-square&logo=fedora&logoColor=white)](https://fedoraproject.org/)
[![Hyprland](https://img.shields.io/badge/Hyprland-58E1FF?style=flat-square&logoColor=black)](https://hyprland.org/)
[![Catppuccin Macchiato](https://img.shields.io/badge/Catppuccin-Macchiato-cba6f7?style=flat-square)](https://catppuccin.com/)

> ⚠️ **Work in progress. Use at your own risk.**  
> **Monitor configuration:** The Hyprland config is set up for a specific 3-monitor layout (ultrawide primary, vertical secondary, laptop display). You **must** update the `hl.monitor(...)` lines and workspace assignments in `hyprland.lua` to match your own monitor outputs, resolutions, and positions.

Hyprland setup for Fedora with screensharing support and copy-paste into VMware Workstation Pro.
Themed with Catppuccin Macchiato throughout. Managed with GNU Stow.

---

## Contents

- [Tools](#tools)
- [Install](#install)
- [Keybindings](#keybindings)

---

## Tools

| Tool | Purpose |
|---|---|
| [Hyprland](https://hyprland.org) | Wayland compositor |
| [Noctalia](https://noctalia.dev) | Shell (bar, launcher, control center) |
| [Alacritty](https://alacritty.org) | Terminal emulator |
| [Rofi](https://github.com/davatorium/rofi) | App runner |
| [NeoVim](https://neovim.io) | Text editor (LazyVim) |
| [hyprpaper](https://github.com/hyprwm/hyprpaper) | Wallpaper daemon |
| [Hyprshot](https://github.com/Gustash/Hyprshot) | Screenshots |
| [wf-recorder](https://github.com/ammen99/wf-recorder) | Screen recording |
| [cliphist](https://github.com/sentriz/cliphist) | Clipboard history |
| [Nautilus](https://gitlab.gnome.org/GNOME/nautilus) | File manager |
| [blueman](https://github.com/blueman-project/blueman) | Bluetooth manager |
| [tmux](https://github.com/tmux/tmux) | Terminal multiplexer |
| zsh | Shell |

---

## Install

### 1. Install Hyprland

```bash
sudo dnf copr enable lionheartp/Hyprland
sudo dnf install hyprland

# Screensharing support
sudo dnf install xdg-desktop-portal-hyprland xdg-desktop-portal-gtk
```

### 2. Configure screensharing

Create the systemd target:

```bash
systemctl --user edit --full --force hyprland-session.target
```

Paste the following:

```ini
[Unit]
Description=Hyprland session
BindsTo=graphical-session.target
Wants=graphical-session-pre.target
After=graphical-session-pre.target
PropagatesStopTo=graphical-session.target
```

Verify it's running:

```bash
systemctl --user start hyprland-session.target
systemctl --user is-active graphical-session.target
# Expected: active

systemctl --user start xdg-desktop-portal
systemctl --user is-active xdg-desktop-portal
# Expected: active
```

### 3. Install dependencies

```bash
sudo dnf install noctalia alacritty nautilus rofi stow zsh cliphist hyprshot blueman tmux
```

### 4. Clone and apply dotfiles

```bash
git clone https://github.com/Metall-Moses/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow hyprland alacritty wallpapers nvim tmux
```

### 5. Change shell to zsh

```bash
chsh -s $(which zsh)
```

### 6. Reboot

```bash
sudo reboot now
```

---

## Keybindings

`Super` = Windows key &nbsp;·&nbsp; `Super2` = Windows + Shift

### Applications

| Keybind | Action |
|---|---|
| `Super + T` | Terminal (Alacritty) |
| `Super + F` | File manager (Nautilus) |
| `Super + B` | Browser (Firefox) |
| `Super + M` | Music (Spotify) |
| `Super + Space` | App launcher (Noctalia) |
| `Super + S` | Control center (Noctalia) |
| `Super + ,` | Noctalia settings |
| `Super2 + Space` | Rofi run |
| `Super2 + S` | Screenshot region → `~/Pictures/` |
| `Super + R` | Toggle screen recording → `~/Videos/` |
| `Super2 + V` | Clipboard history (cliphist → rofi) |

### Window management

| Keybind | Action |
|---|---|
| `Super + Q` | Close window |
| `Super2 + T` | Toggle floating |
| `Super2 + F` | Maximize |
| `Super + LMB drag` | Move window |
| `Super + RMB drag` | Resize window |

### Navigation

| Keybind | Action |
|---|---|
| `Super + ↑ ↓ ← →` | Focus window |
| `Super2 + ↑ ↓ ← →` | Move window |
| `Super + 1–9` | Switch workspace |
| `Super2 + 1–9` | Move window to workspace |

