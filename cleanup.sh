# cleanup.sh
# author: D.A.Pelasgus

# cleanup.sh
# author: D.A.Pelasgus

#!/bin/bash

# ANSI color codes
PURPLE="\033[1;35m"
RESET="\033[0m"

# Function to print prompts in purple ANSI bold characters
print_prompt() {
  echo -e "${PURPLE}$1${RESET}"
}

# Function to uninstall a Homebrew package
uninstall_package() {
  print_prompt "Uninstalling Homebrew package: $1"
  if brew list | grep -q "$1"; then
    sudo brew uninstall "$1"
  else
    echo "Package $1 is not installed."
  fi
}

# Function to uninstall Homebrew
uninstall_homebrew() {
  print_prompt "Uninstalling Homebrew"
  sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
}

# Function to uninstall Nix in multi-user mode
uninstall_nix_multiuser() {
  print_prompt "Uninstalling Nix (Multi-User)"
  sudo rm -rf /nix
  sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
  sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
  sudo rm /etc/nix/nix.conf
}

# Function to uninstall Nix in single-user mode
uninstall_nix_singleuser() {
  print_prompt "Uninstalling Nix (Single-User)"
  rm -rf $HOME/.nix-profile
  rm -rf $HOME/.nix-defexpr
  rm -rf $HOME/.nix-channels
  rm $HOME/.nixrc
}

# Main script

# Check if the script is run with sudo
if [ "$(id -u)" != "0" ]; then
  echo "This script requires sudo privileges. To run with sudo, please enter your password below:"
  sudo -v
fi

# Uninstall qemu package
uninstall_package "qemu"

# Uninstall Homebrew
uninstall_homebrew

# Uninstall Nix (Multi-User)
uninstall_nix_multiuser

# Uninstall Nix (Single-User)
uninstall_nix_singleuser

# Check if qemu still exists
if command -v qemu &> /dev/null; then
  echo "QEMU is still installed."
else
  echo "QEMU has been successfully uninstalled."
fi

# Check if Homebrew still exists
if command -v brew &> /dev/null; then
  echo "Homebrew is still installed."
else
  echo "Homebrew has been successfully uninstalled."
fi

# Check if Nix still exists
if command -v nix &> /dev/null; then
  echo "Nix is still installed."
else
  echo "Nix has been successfully uninstalled."
fi
