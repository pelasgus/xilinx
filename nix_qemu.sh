# nix_qemu.sh
# author: D.A.Pelasgus

#!/bin/bash

# ANSI escape codes for color and formatting
PURPLE='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

# Configuration file path
CONFIG_FILE=".vm_config"

# Function to print colored text
print_colored() {
  echo -e "${PURPLE}${BOLD}$1${RESET}"
}

# Function to log messages
log_message() {
  local message="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "script_log.txt"
}

# Function to check if a command is available
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to handle errors
handle_error() {
  local error_message="$1"
  print_colored "Error: $error_message"
  exit 1
}

# Function to install Nix package manager
install_nix() {
  print_colored "Installing Nix package manager..."
  curl -L https://nixos.org/nix/install | sh -s -- --daemon
}

# Function to install QEMU using Nix flake
install_qemu_flake() {
  print_colored "Installing QEMU using Nix flake..."
  if nix build .#qemu -o qemu; then
    export PATH=$PWD/qemu/bin:$PATH
    print_colored "QEMU installed successfully."
  else
    handle_error "Failed to install QEMU using Nix flake."
  fi
}

# Function to convert VMDK to QEMU format using qemu-img
convert_vmdk_to_qemu() {
  local vmdk_path="$1"
  local qemu_path="${vmdk_path%.vmdk}.qcow2"

  print_colored "Converting VMDK to QEMU format..."
  if qemu-img convert -f vmdk -O qcow2 "$vmdk_path" "$qemu_path"; then
    print_colored "Conversion complete."
    echo "$qemu_path"
  else
    handle_error "Failed to convert VMDK to QEMU format."
  fi
}

# Function to check dependencies
check_dependencies() {
  command_exists nix || install_nix || handle_error "Nix installation failed."
  command_exists qemu || install_qemu_flake || handle_error "QEMU installation failed."
}

# Function to read configuration values from file
read_config() {
  source "$CONFIG_FILE" 2>/dev/null
}

# Function to write configuration values to file
write_config() {
  cat <<EOL >"$CONFIG_FILE"
VM_NAME="${VM_NAME:-}"
RAM_SIZE_MB="${RAM_SIZE_MB:-2048}"
DISK_SIZE_GB="${DISK_SIZE_GB:-10}"
DISK_IMAGE_PATH="${DISK_IMAGE_PATH:-}"
SHARED_FOLDER_PATH="${SHARED_FOLDER_PATH:-}"
ADDITIONAL_QEMU_OPTIONS="${ADDITIONAL_QEMU_OPTIONS:-}"
EOL
}

# Function to prompt the user for input with a default value
prompt_user() {
  local prompt_message="$1"
  local variable_name="$2"
  local default_value="$3"
  
  print_colored "$prompt_message (default: $default_value):"
  read -r -s -n 1 -p "Press enter to use the default or provide a new value"

  # If the user provides a new value, read it
  if [[ $REPLY ]]; then
    read -r "$variable_name"
  else
    eval "$variable_name=\${$variable_name:-$default_value}"
  fi
}

# Function to validate path existence
validate_path() {
  local path="$1"
  
  if [ ! -e "$path" ]; then
    handle_error "Path '$path' does not exist. Please enter a valid path."
  fi
}

# Function to construct QEMU options
construct_qemu_options() {
  local -a qemu_options=()

  # Add common options
  qemu_options+=(
    -name "$VM_NAME"
    -machine virt
    -cpu "max"
    -m "$RAM_SIZE_MB"
    -drive file="$DISK_IMAGE_PATH",format=raw,size=${DISK_SIZE_GB}G
    -boot d
    -netdev user,id=user0 -device virtio-net,netdev=user0
    -vga virtio
    -display default,show-cursor=on
    -usb
  )

  # Enable Rosetta acceleration on Apple Silicon
  if [ "$(uname -m)" == "arm64" ]; then
    qemu_options+=(-cpu "max,rosetta2")
  fi

  # Add additional QEMU options if provided
  if [ "${#ADDITIONAL_QEMU_OPTIONS[@]}" -gt 0 ]; then
    qemu_options+=("${ADDITIONAL_QEMU_OPTIONS[@]}")
  fi

  # Add shared folder option
  qemu_options+=(-drive file="$SHARED_FOLDER_PATH",format=raw,media=cdrom)

  # Add monitor option
  qemu_options+=(-monitor stdio)

  echo "${qemu_options[@]}"
}

# Function to detect CPU architecture
detect_cpu_architecture() {
  local cpu_arch=$(uname -m)
  local cpu_model="max"
  
  if [ "$cpu_arch" == "arm64" ]; then
    is_apple_silicon=true
  else
    is_apple_silicon=false
  fi
}

# Function to initialize script
initialize_script() {
  # Display acknowledgment prompt
  print_colored "You agree to use a script authored by D.A.Pelasgus. Press enter to acknowledge his might"
  read -r -s -n 1 -p "Press enter to continue"

  # Detect CPU architecture
  detect_cpu_architecture

  # Read configuration values from file
  read_config

  # Set default values
  prompt_user "Enter the VM name" vm_name "$VM_NAME"
  prompt_user "Enter the amount of RAM in MB" ram_size_mb "$RAM_SIZE_MB"
  prompt_user "Enter the disk size in GB" disk_size_gb "$DISK_SIZE_GB"

  # Accept ISO, IMG, or VMDK file path as input
  prompt_user "Enter the path for the ISO, IMG, or VMDK file" disk_image_path "$DISK_IMAGE_PATH"
  validate_path "$DISK_IMAGE_PATH"

  # If VMDK, convert to QEMU format
  if [[ $DISK_IMAGE_PATH == *.vmdk ]]; then
    DISK_IMAGE_PATH=$(convert_vmdk_to_qemu "$DISK_IMAGE_PATH")
  fi

  # Prompt for shared folder path and validate
  prompt_user "Enter the path for the shared folder" shared_folder_path "$VM_NAME/Documents/shared_folder"
  validate_path "$SHARED_FOLDER_PATH"

  # Prompt for additional QEMU options
  prompt_user "Enter additional QEMU options (leave blank for none)" additional_qemu_options "$ADDITIONAL_QEMU_OPTIONS"

  # Write configuration values to file
  write_config
  log_message "Script initialized with configuration:"
  log_message "$(cat "$CONFIG_FILE")"
}

# Function to launch the VM
launch_vm() {
  # Construct QEMU options
  qemu_options=$(construct_qemu_options)

  # Prompt for confirmation
  print_colored "Ready to launch the VM with the following options:"
  printf "%s\n" "${qemu_options[@]}"
  read -p "Continue? (y/n): " -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Run QEMU
    run_qemu "${qemu_options[@]}"
  else
    print_colored "VM launch aborted by the user."
  fi
}

# Function to run QEMU
run_qemu() {
  print_colored "Running QEMU..."
  nix run .#qemu -- "${@}"
}

# Main script execution
check_dependencies
initialize_script
launch_vm
