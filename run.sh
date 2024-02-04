# run.sh
# author: D.A.Pelasgus

#!/bin/sh

# ANSI color codes
PURPLE_BOLD="\033[1;35m"
RESET="\033[0m"

echo -e "${PURPLE_BOLD}Welcome to Xilinx Product Installer/Uninstaller${RESET}"

# Ask the user whether to install or uninstall
echo -e "${PURPLE_BOLD}Do you want to install or uninstall a Xilinx product? (Type 'install' or 'uninstall')${RESET}"
read -p "Choice: " choice

if [ "$choice" = "install" ]; then
    echo -e "${PURPLE_BOLD}Installing Xilinx product...${RESET}"
    ./setup.sh  # Replace with the actual setup script name
elif [ "$choice" = "uninstall" ]; then
    echo -e "${PURPLE_BOLD}Uninstalling Xilinx product...${RESET}"
    ./uninstall.sh  # Replace with the actual cleanup script name
else
    echo -e "${PURPLE_BOLD}Invalid choice. Please enter 'install' or 'uninstall'.${RESET}"
    exit 1
fi

echo -e "${PURPLE_BOLD}Process completed.${RESET}"
