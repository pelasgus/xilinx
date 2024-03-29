# setup_image.py
# author: D.A.Pelasgus

#!/usr/bin/env python3

import os
import subprocess
import sys 

# Add parent directory to the sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# Import style_text from styles.styles
from styles.styles import style_text

def convert_image():
    target_directory = os.path.expanduser("~/Documents/xilinx/installation")

    print(style_text("Navigating to target directory...", bold=True, color="purple"))
    os.chdir(target_directory)

    vmdk_file = "vm.vmdk"  # Updated to use "vm.vmdk" as the file name

    if not os.path.exists(vmdk_file):
        print(style_text(f"The file {vmdk_file} does not exist.", bold=True, color="purple"))
        return

    print(style_text(f"Converting {vmdk_file} to QEMU format...", bold=True, color="purple"))

    try:
        subprocess.run(["qemu-img", "convert", "-f", "vmdk", "-O", "qcow2", vmdk_file], check=True)
        print(style_text("Conversion successful!", bold=True, color="purple"))

        # Delete the original .vmdk file
        os.remove(vmdk_file)
        print(style_text(f"Original {vmdk_file} deleted.", bold=True, color="purple"))

    except subprocess.CalledProcessError as e:
        print(style_text(f"Error during conversion: {e}", bold=True, color="purple"))

def main():
    convert_image()

if __name__ == "__main__":
    main()

# Chainlink
subprocess.run(['python3', '../setup/setup_image.py'])