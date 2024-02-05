# launcher_qemu.py
# author: D.A.Pelasgus

import os
import subprocess
import logging
import configparser
from styles.styles import style_text

# Configuration Constants
CONFIG_PATH = "config.ini"
QEMU_IMAGE_PATH = os.path.join("Documents", "xilinx", "installation", "vm.qcow2")
FILES_PATH = os.path.join("Documents", "xilinx", "files")

# Logger configuration
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Function to print colored text
def print_colored(text):
    print(style_text(text, bold=True, color="purple"))

# Function to detect CPU architecture
def detect_cpu_architecture():
    return os.uname().machine

# Function to check if the system is macOS
def is_macos():
    return os.uname().sysname == "Darwin"

# Function to validate user input paths
def validate_paths():
    if not os.path.isfile(QEMU_IMAGE_PATH) or not os.path.isdir(FILES_PATH):
        logger.error("Invalid paths. Please check your QEMU image and files.")
        return False
    return True

# Function to construct QEMU options
def construct_qemu_options():
    qemu_options = [
        "-name", "QEMU_VM",
        "-machine", "virt",
        "-cpu", "max",
        "-m", "2048",
        "-drive", f"file={QEMU_IMAGE_PATH},format=qcow2,size=20G",
        "-boot", "d",
        "-netdev", "user,id=user0 -device virtio-net,netdev=user0",
        "-vga", "virtio",
        "-display", "default,show-cursor=on",
        "-usb",
        "-drive", f"file={FILES_PATH},format=raw,media=cdrom",
        "-monitor", "stdio"
    ]

    if is_macos() and detect_cpu_architecture() == "arm64":
        qemu_options.extend(["-cpu", "max,rosetta2"])

    return qemu_options

# Function to run QEMU
def run_qemu(*qemu_options):
    print_colored("Running QEMU...")
    try:
        subprocess.run(["qemu-system-" + detect_cpu_architecture()] + list(qemu_options), check=True)
    except subprocess.CalledProcessError as e:
        logger.error(f"Error during QEMU execution: {e}")

# Main script execution
if __name__ == "__main__":
    # Validate user input paths
    if not validate_paths():
        exit(1)

    # Construct and run QEMU options
    qemu_options = construct_qemu_options()
    run_qemu(*qemu_options)