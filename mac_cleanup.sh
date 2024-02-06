# mac_cleanup.sh
# author: D.A.Pelasgus

#!/bin/bash

# Unmount and remove the Nix store volume and the system-wide nix installation
sudo umount /nix
sudo rm -rf /nix

# Remove user-specific Nix installation
rm -rf $HOME/.nix-profile
rm -rf $HOME/.nix-defexpr
rm -rf $HOME/.nix-channels
rm -rf $HOME/.config/nixpkgs

# Remove Nix user environment
rm -f $HOME/.profile
rm -f $HOME/.bash_profile
rm -f $HOME/.zshrc
rm -f $HOME/.bashrc

# Remove Nix user symlinks
rm -f $HOME/.nix-profile
rm -f $HOME/.nix-channels

# Remove nix daemon service
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist
sudo rm /Library/LaunchDaemons/org.nixos.nix-daemon.plist

# Remove nix user service
rm -f $HOME/Library/LaunchAgents/nix-daemon.plist

echo "Multi-user Nix installation and store volume removed successfully."