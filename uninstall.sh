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
  print_prompt "Uninstalling package: $1"
  if command -v brew &> /dev/null; then
    if brew list | grep -q "$1"; then
      brew uninstall "$1"
    else
      echo "Package $1 is not installed."
    fi
  else
    echo "Homebrew is not installed. Cannot uninstall $1."
  fi
}

# Function to uninstall Homebrew
uninstall_homebrew() {
  print_prompt "Uninstalling Homebrew"
  if command -v brew &> /dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
  else
    echo "Homebrew is not installed."
  fi
}

# Function to uninstall Nix (Multi-User)
uninstall_nix_multiuser() {
  print_prompt "Uninstalling Nix (Multi-User)"

  # Edit /etc/zshrc, /etc/bashrc, and /etc/bash.bashrc
  sudo sed -i.backup-before-nix '/\/nix\/var\/nix\/profiles\/default\/etc\/profile.d\/nix-daemon.sh/d' /etc/zshrc
  sudo sed -i.backup-before-nix '/\/nix\/var\/nix\/profiles\/default\/etc\/profile.d\/nix-daemon.sh/d' /etc/bashrc
  sudo sed -i.backup-before-nix '/\/nix\/var\/nix\/profiles\/default\/etc\/profile.d\/nix-daemon.sh/d' /etc/bash.bashrc

  # Stop and remove Nix daemon services
  sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
  sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist
  sudo launchctl unload /Library/LaunchDaemons/org.nixos.darwin-store.plist
  sudo rm /Library/LaunchDaemons/org.nixos.darwin-store.plist

  # Remove nixbld group and _nixbuildN users
  sudo dscl . -delete /Groups/nixbld
  for u in $(sudo dscl . -list /Users | grep _nixbld); do sudo dscl . -delete /Users/$u; done

  # Edit fstab to remove the line mounting the Nix Store volume on /nix
  sudo vifs -d /etc/fstab "/nix"

  # Edit /etc/synthetic.conf to remove the nix line
  sudo sed -i.backup-before-nix '/nix/d' /etc/synthetic.conf

  # Remove files added by Nix
  sudo rm -rf /etc/nix /var/root/.nix-profile /var/root/.nix-defexpr /var/root/.nix-channels ~/.nix-profile ~/.nix-defexpr ~/.nix-channels

  # Remove the Nix Store volume
  sudo diskutil apfs deleteVolume /nix
}

# Main script

# Prompt the user to enter their password for privilege escalation
echo "This script may require sudo privileges. Please enter your password below:"
sudo -v

# Uninstall qemu package
uninstall_package "qemu"

# Uninstall Homebrew
uninstall_homebrew

# Uninstall Nix (Multi-User)
uninstall_nix_multiuser

# Check if qemu still exists
if command -v qemu-system-* &> /dev/null; then
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

# Check if Nix-related configurations have been removed
if ! grep -q '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' /etc/zshrc && \
   ! grep -q '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' /etc/bashrc && \
   ! grep -q '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' /etc/bash.bashrc; then
  echo "Nix-related configurations have been successfully removed from /etc/zshrc, /etc/bashrc, and /etc/bash.bashrc."
else
  echo "Failed to remove Nix-related configurations from /etc/zshrc, /etc/bashrc, and /etc/bash.bashrc."
fi

# Check if Nix daemon services have been stopped and removed
if ! sudo launchctl list | grep -q 'org.nixos.nix-daemon' && \
   ! sudo launchctl list | grep -q 'org.nixos.darwin-store'; then
  echo "Nix daemon services have been successfully stopped and removed."
else
  echo "Failed to stop and remove Nix daemon services."
fi

# Check if Nix-related files and groups have been removed
if [ ! -f "/etc/zshrc.backup-before-nix" ] && \
   [ ! -f "/etc/bashrc.backup-before-nix" ] && \
   [ ! -f "/etc/bash.bashrc.backup-before-nix" ] && \
   [ ! -d "/etc/nix" ] && \
   [ ! -d "/var/root/.nix-profile" ] && \
   [ ! -d "/var/root/.nix-defexpr" ] && \
   [ ! -d "/var/root/.nix-channels" ] && \
   [ ! -d "~/.nix-profile" ] && \
   [ ! -d "~/.nix-defexpr" ] && \
   [ ! -d "~/.nix-channels" ] && \
   [ ! -f "/etc/synthetic.conf.backup-before-nix" ]; then
  echo "Nix-related files and groups have been successfully removed."
else
  echo "Failed to remove Nix-related files and groups."
fi

# Check if the Nix Store volume has been removed
if ! diskutil list | grep -q 'Nix Store'; then
  echo "Nix Store volume has been successfully removed."
else
  echo "Failed to remove the Nix Store volume."
fi
