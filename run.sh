# run.sh
# author: D.A.Pelasgus

#!/bin/bash

# Import styles.sh
source ./styles/styles.sh

# Make scripts executable
chmod +x ./styles/styles.py
chmod +x ./styles/styles.sh
chmod +x ./uninstall.sh
chmod +x ./mac_cleanup.sh
chmod +x ./launcher_qemu.py
chmod +x ./setup/setup_python.sh
chmod +x ./setup/setup_directory.py
chmod +x ./setup/setup_nix.py
chmod +x ./setup/setup_qemu.py
chmod +x ./setup/setup_image.py
chmod +x ./setup/setup_compression_status.py
chmod +x ./setup/flake_qemu.nix

style_text "Welcome to Xilinx Product Installer/Uninstaller"

# Check if script is running as root
if [ "$EUID" -ne 0 ]; then
  style_text "This script requires root privileges. Please enter your password when prompted."
  sudo -k  # Reset timestamp before prompting for password
  sudo "$0" "$@"  # Re-run the script with sudo
  exit $?
fi

style_text "Do you want to install or uninstall a Xilinx product? (Type 'install' or 'uninstall')"
read -p "Choice: " choice

if [ "$choice" = "install" ]; then
    style_text "Installing Xilinx product..."
    ./setup/setup_python.sh
elif [ "$choice" = "uninstall" ]; then
    style_text "Uninstalling Xilinx product..."
    ./uninstall.sh
    ./mac_cleanup.sh
else
    style_text "Invalid choice. Please enter 'install' or 'uninstall'."
    exit 1
fi

style_text "Process completed."