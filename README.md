# dotfiles

# Work in progress. Use at own risk.

## Overview

My version of a Hyprland setup for Fedora with support for screensharing and copy-paste into VMware Workstation Pro. 
Themed with catppuccing macchiato in both Hyprland and Alacritty. And of course anime backgrounds for the memes.

The easiest way to apply all settings are with GNU Stow.

Please read the instructions for install to make it work properly.

## Tools
- NeoVim
- Alacritty
- Hyprlock
- Hyprshot

## Install 
  1. Base install on Fedora.
    
    ```
    sudo dnf cpor enable ashbuk/Hyprland-fedora
    sudo dnf install hyprland
    sudo dnf install xdg-desktop-portal-hyprland
    ```
  
  2. Post install for screensharing.

    ```
    sudo systemctl --user edit --full --force hyprland-session.target
    ```

  3. Paste following

    ```
    [Unit]
    Description=Hyprland session
    BindsTo=graphical-session.target
    Wants=graphical-session-pre.target  
    After=graphical-session-pre.target
    PropagatesStopTo=graphical-session.target
    ```

  4. Run following.

    ```
```
    sudo system --user start hyprland-session.target
    sudo systemctl --user start is-active graphical-session.target
    Expect: active
    sudo systemctl --user start xdg-desktop-portal
    sudo systemctl --user is-active xdg-desktop-portal
    Expect: active
    ```

  5. Install dependencies

    ```
    sudo dnf install noctalia alacritty nautilus rofi stow zsh
    ```

  6. Clone dotfiles repo
    
    ```
    git clone https://github.com/Metall-Moses/dotfiles.git
    ```
  7. Stow the configs
    
    ```
    cd ~/dotfiles/
    stow hyprland alacritty wallpapers nvim
    ```
  8. Reboot
    `sudo reboot now`

### Dont forget to change shell to zsh


## Keybindings

  ### Basic
    Super = Windows-key
    Super 2 = Windows + shift

  ### Apps
    * Super + T = Open Terminal (Alacritty)
    * Super + F = Open Filemanager
    * Super + Space = Open app launcher
    * Super + B = Open Browser (Firefox)
    * Super + M = Open Music (Spotify if installed)
    * Super + X = Hyprlock
    * Super 2 + S = Hyprshot
      * Screencap saved in ~/Pictures/
    * Super + Q = Close window

  ### Navigation
    * Super + arrowkeys = Move between active windows
    * Super 2 + arrowkeys = Move windows around
    * Super + 1-9 = Change workspace
    * Super 2 + 1-9 = Move highlighted window to workspace

