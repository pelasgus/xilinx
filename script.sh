# script.sh
# author: D.A.Pelasgus

#!/bin/bash

# ANSI escape codes for color and formatting
PURPLE='\033[0;35m'
BOLD='\033[1m'
RESET='\033[0m'

# Configuration file path
CONFIG_FILE=".vm_config"

# QEMU download URL
QEMU_DOWNLOAD_URL="https://www.qemu.org/download"

# Function to print colored text
print_colored() {
  echo -e "${PURPLE}${BOLD}$1${RESET}"
}

# Function to log messages
log_message() {
  local message="$1"
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $message" >> "script_log.txt"
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

# Function to check if a path exists
validate_path() {
  local path="$1"
  
  if [ ! -e "$path" ]; then
    print_colored "Error: Path '$path' does not exist. Please enter a valid path."
    exit 1
  fi
}

# Function to check if a command is available
check_command() {
  local command_name="$1"
  
  command -v "$command_name" >/dev/null 2>&1
}

# Function to download and install Homebrew
install_homebrew() {
  print_colored "Homebrew is not installed. Attempting to install Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Check if Homebrew installation was successful
  if check_command "brew"; then
    print_colored "Homebrew has been installed successfully."
  else
    print_colored "Error: Homebrew installation failed. Please check the installation and try again."
    exit 1
  fi
}

# Function to download and install QEMU
install_qemu() {
  print_colored "Checking if Homebrew is installed..."

  if ! check_command "brew"; then
    install_homebrew
  else
    print_colored "Homebrew is already installed."
  fi

  print_colored "Using Homebrew to install QEMU..."
  brew install qemu

  # Check if QEMU installation was successful
  if check_command "qemu-system"; then
    print_colored "QEMU has been installed successfully."
  else
    print_colored "Error: QEMU installation failed. Please check the installation and try again."
    exit 1
  fi
}

# Function to execute QEMU
run_qemu() {
  local -a qemu_options=("$@")

  # Run QEMU and check for errors
  qemu-system "${qemu_options[@]}"
  local exit_code=$?
  
  if [ $exit_code -ne 0 ]; then
    print_colored "Error: QEMU execution failed with exit code $exit_code."
    exit 1
  fi
}

# Function to convert VMDK to QEMU format using qemu-img
convert_vmdk_to_qemu() {
  local vmdk_path="$1"
  local qemu_path="${vmdk_path%.vmdk}.qcow2"

  print_colored "Converting VMDK to QEMU format..."
  qemu-img convert -f vmdk -O qcow2 "$vmdk_path" "$qemu_path"
  print_colored "Conversion complete."

  echo "$qemu_path"
}

# Function to construct QEMU options
construct_qemu_options() {
  local -a qemu_options=()

  # Add common options
  qemu_options+=(
    -name "$VM_NAME"
    -machine virt
    -cpu "$CPU_MODEL"
    -m "$RAM_SIZE_MB"
    -drive file="$DISK_IMAGE_PATH",format=raw,size=${DISK_SIZE_GB}G
    -boot d
    -netdev user,id=user0 -device virtio-net,netdev=user0
    -vga virtio
    -display default,show-cursor=on
    -usb
  )

  # Enable Rosetta acceleration on Apple Silicon
  if [ "$IS_APPLE_SILICON" == true ]; then
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
  CPU_ARCH=$(uname -m)
  CPU_MODEL="max"
  
  if [ "$CPU_ARCH" == "arm64" ]; then
    IS_APPLE_SILICON=true
  else
    IS_APPLE_SILICON=false
  fi
}

# Function to initialize script
initialize_script() {
  # Display acknowledgment prompt
  print_colored "You agree to use a script authored by D.A.Pelasgus. Press enter to acknowledge his might"
  read -r -s -n 1 -p "Press enter to continue"

  # Detect CPU architecture
  detect_cpu_architecture

  # Check if QEMU is installed
  if ! check_command "qemu-system"; then
    install_qemu
  fi

  # Read configuration values from file
  read_config

  # Set default values
  prompt_user "Enter the VM name" VM_NAME "$VM_NAME"
  prompt_user "Enter the amount of RAM in MB" RAM_SIZE_MB "$RAM_SIZE_MB"
  prompt_user "Enter the disk size in GB" DISK_SIZE_GB "$DISK_SIZE_GB"

  # Prompt for VMDK image path and validate
  prompt_user "Enter the path for the VMDK image" VMDK_IMAGE_PATH "$VMDK_IMAGE_PATH"
  validate_path "$VMDK_IMAGE_PATH"

  # Convert VMDK to QEMU format
  DISK_IMAGE_PATH=$(convert_vmdk_to_qemu "$VMDK_IMAGE_PATH")

  # Prompt for shared folder path and validate
  prompt_user "Enter the path for the shared folder" SHARED_FOLDER_PATH "$VM_NAME/Documents/shared_folder"
  validate_path "$SHARED_FOLDER_PATH"

  # Prompt for additional QEMU options
  prompt_user "Enter additional QEMU options (leave blank for none)" ADDITIONAL_QEMU_OPTIONS "$ADDITIONAL_QEMU_OPTIONS"

  # Write configuration values to file
  write_config
  log_message "Script initialized with configuration:"
  log_message "$(cat "$CONFIG_FILE")"
}

# Function to launch the VM
launch_vm() {
  # Construct QEMU options
  QEMU_OPTIONS=$(construct_qemu_options)

  # Prompt for confirmation
  print_colored "Ready to launch the VM with the following options:"
  printf "%s\n" "$QEMU_OPTIONS"
  read -p "Continue? (y/n): " -r
  echo

  if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Run QEMU
    run_qemu $QEMU_OPTIONS
  else
    print_colored "VM launch aborted by user."
  fi
}

# Main script execution
initialize_script
launch_vm
