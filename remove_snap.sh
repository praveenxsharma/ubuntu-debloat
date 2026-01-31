#!/bin/bash
# Description: Ubuntu Snap Removal and Flatpak Setup

set -e

# --- Root Check ---
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root: sudo $0"
  exit 1
fi

# --- Helper Functions ---
prompt_confirmation() {
    while true; do
        read -p "$1 [y/n]: " choice
        case "$choice" in
            y|Y ) return 0;;
            n|N ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

# --- Core Logic ---

remove_snaps() {
    echo "Removing Snap packages and daemon..."
    while snap list 2>/dev/null | awk 'NR > 1 {print $1}' | grep -q .; do
        for s in $(snap list | awk 'NR > 1 {print $1}'); do
            snap remove --purge "$s" || true
        done
    done
    apt-get purge -y snapd || true
    rm -rf ~/snap /var/snap /var/lib/snapd
}

block_snap_reinstall() {
    echo "Pinning snapd to prevent reinstallation..."
    cat <<EOF > /etc/apt/preferences.d/nosnap.pref
Package: snapd
Pin: release a=*
Pin-Priority: -10
EOF
}

install_flatpak() {
    echo "Installing Flatpak and Flathub repository..."
    apt-get update
    apt-get install -y flatpak gnome-software-plugin-flatpak
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

install_firefox_apt() {
    echo "Configuring Mozilla APT Repo..."
    install -d -m 0755 /etc/apt/keyrings
    wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" | tee /etc/apt/sources.list.d/mozilla.list > /dev/null
    
    cat <<EOF > /etc/apt/preferences.d/mozilla
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000
EOF

    apt-get update
    if prompt_confirmation "Install Firefox ESR? (No installs standard)"; then
        apt-get install -y firefox-esr
    else
        apt-get install -y firefox
    fi
}

# --- Execution ---

echo "Starting System Modification..."

if prompt_confirmation "Do you want to completely remove Snap?"; then
    remove_snaps
    block_snap_reinstall
fi

if prompt_confirmation "Do you want to install Flatpak and Flathub?"; then
    install_flatpak
    REBOOT_REQUIRED=true
fi

if prompt_confirmation "Install Firefox via Mozilla APT?"; then
    install_firefox_apt
fi

if [ "$REBOOT_REQUIRED" = true ]; then
    echo "========================================"
    echo "Setup complete. A reboot is required to finish Flatpak integration."
    if prompt_confirmation "Would you like to reboot now?"; then
        reboot
    fi
else
    echo "Process complete. No reboot necessary."
fi
