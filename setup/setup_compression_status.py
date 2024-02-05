# setup_compression_status.py
# author: D.A.Pelasgus

import subprocess
from styles import style_text

def prompt_user():
    choice = input(style_text("Do you require assistance with compression? (y/n): ")).strip().lower()
    return choice

def handle_yes():
    print(style_text("Calling setup_directory.py..."))
    subprocess.run(['python3', './setup/setup_directory.py'])
    print(style_text("Calling setup_image.py..."))
    subprocess.run(['python3', './setup/setup_image.py'])

def handle_no():
    confirm = input(style_text("Are you sure the VM file is named 'vm.vmdk' and placed in 'Documents/xilinx/installation'? (y/n): ")).strip().lower()
    if confirm == 'y':
        print(style_text("No further action needed."))
    else:
        print(style_text("Please ensure the VM file is named 'vm.vmdk' and placed in 'Documents/xilinx/installation'."))

if __name__ == "__main__":
    user_choice = prompt_user()

    if user_choice == 'y':
        handle_yes()
    elif user_choice == 'n':
        handle_no()
    else:
        print(style_text("Invalid choice. Please enter 'y' or 'n'."))