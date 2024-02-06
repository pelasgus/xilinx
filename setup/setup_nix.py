# setup_nix.py
# author: D.A.Pelasgus

#!/usr/bin/env python3

import os
import subprocess
import sys
import shutil

# Add parent directory to the sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

# Import style_text from styles.styles
from styles.styles import style_text

def install_nix():
    print(style_text("Checking if Nix is installed..."))

    # Check if Nix is already installed
    nix_path = subprocess.run(['which', 'nix'], stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    if nix_path.returncode == 0:
        print(style_text("Nix is already installed."))
    else:
        print(style_text("Nix not found. Installing Nix..."))

        # Perform a multi-user installation using the official script with daemon flag and experimental features
        try:
            subprocess.run(['sh', '-c', 'curl -L https://nixos.org/nix/install | sh -s -- --daemon --experimental-features "nix-command flakes"'], check=True)
        except subprocess.CalledProcessError as e:
            print("Nix installation failed:", e)
            sys.exit(1)

def main():
    install_nix()

if __name__ == "__main__":
    main()