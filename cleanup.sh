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
    brew uninstall "$1"
  else
    echo "Package $1 is not installed."
  fi
}

# Function to uninstall Homebrew
uninstall_homebrew() {
  print_prompt "Uninstalling Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"
}

# Main script

# Uninstall qemu package
uninstall_package "qemu"

# Uninstall Homebrew
uninstall_homebrew

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
