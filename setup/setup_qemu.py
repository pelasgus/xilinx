# setup_qemu.py
# author: D.A.Pelasgus

import subprocess
from styles import style_text

def install_qemu():
    print(style_text("Checking if QEMU is installed..."))

    # Check if QEMU is already installed
    if shutil.which('qemu-system-x86_64') and shutil.which('qemu-system-aarch64'):
        print(style_text("QEMU is already installed."))
    else:
        print(style_text("QEMU not found. Installing QEMU..."))

        # Replace 'path/to/your/flake' with the actual path to your flake directory or repository
        subprocess.run(['nix', 'flake', 'install', 'flake_qemu.nix'], check=True, stdout=subprocess.PIPE)

def main():
    install_qemu()

if __name__ == "__main__":
    main()