# launcher_qemu.py
# author: D.A.Pelasgus

import os
import subprocess
from styles import style_text

# Function to print colored text
def print_colored(text):
    print(style_text(text, bold=True, color="purple"))

# Function to detect CPU architecture
def detect_cpu_architecture():
    cpu_arch = os.uname().machine
    return cpu_arch

# Function to check if the system is macOS
def is_macos():
    return os.uname().sysname == "Darwin"

# Function to construct QEMU options
def construct_qemu_options():
    qemu_options = [
        "-name", "QEMU_VM",
        "-machine", "virt",
        "-cpu", "max",
        "-m", "2048",
        "-drive", "file=Documents/xilinx/installation/qemu_vm.qcow2,format=qcow2,size=20G",
        "-boot", "d",
        "-netdev", "user,id=user0 -device virtio-net,netdev=user0",
        "-vga", "virtio",
        "-display", "default,show-cursor=on",
        "-usb",
        "-drive", "file=Documents/xilinx/files,format=raw,media=cdrom",
        "-monitor", "stdio"
    ]

    # Enable Rosetta acceleration on Apple Silicon
    if is_macos() and detect_cpu_architecture() == "arm64":
        qemu_options.extend(["-cpu", "max,rosetta2"])

    return qemu_options

# Function to run QEMU
def run_qemu(*qemu_options):
    print_colored("Running QEMU...")
    subprocess.run(["qemu-system-" + detect_cpu_architecture()] + list(qemu_options))

# Main script execution
qemu_options = construct_qemu_options()
run_qemu(*qemu_options)
