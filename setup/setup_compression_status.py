# setup_compression_status.py
# author: D.A.Pelasgus

import subprocess
import sys
import os

# Get the absolute path of the current script
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.abspath(os.path.join(current_dir, '..'))

# Add parent directory to the sys.path
sys.path.append(parent_dir)

# Import style_text from styles.styles
from styles.styles import style_text

def prompt_user():
    choice = input(style_text("Do you require assistance with compression? (y/n): ")).strip().lower()
    return choice

def handle_yes():
    print(style_text("Calling setup_directory.py..."))
    subprocess.run(['python3', os.path.join(parent_dir, 'setup', 'setup_directory.py')])
    print(style_text("Calling setup_nix.py..."))
    subprocess.run(['python3', os.path.join(parent_dir, 'setup', 'setup_nix.py')])
    print(style_text("Calling setup_qemu.py..."))
    subprocess.run(['python3', os.path.join(parent_dir, 'setup', 'setup_qemu.py')])
    print(style_text("Calling setup_image.py..."))
    subprocess.run(['python3', os.path.join(parent_dir, 'setup', 'setup_image.py')])

def handle_no():
    confirm = input(style_text("Are you sure the VM file is named 'vm.vmdk' and placed in 'Documents/xilinx/installation'? (y/n): ")).strip().lower()
    if confirm == 'y':
        print(style_text("No further action needed."))
    else:
        print(style_text("Please ensure the VM file is named 'vm.vmdk' and placed in 'Documents/xilinx/installation'."))

    print(style_text("Calling setup_nix.py..."))
    subprocess.run(['python3', os.path.join(parent_dir, 'setup', 'setup_nix.py')])
    print(style_text("Calling setup_qemu.py..."))
    subprocess.run(['python3', os.path.join(parent_dir, 'setup', 'setup_qemu.py')])
    print(style_text("Calling setup_image.py..."))
    subprocess.run(['python3', os.path.join(parent_dir, 'setup', 'setup_image.py')])

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 setup_compression_status.py <action>")
        print("<action>: 'yes' or 'no'")
        sys.exit(1)

    action = sys.argv[1].lower()

    if action == 'yes':
        handle_yes()
    elif action == 'no':
        handle_no()
    else:
        print("Invalid action. Please specify 'yes' or 'no'.")