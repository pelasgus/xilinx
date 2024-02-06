# hotfix.py
# author: D.A.Pelasgus

#!/usr/bin/env python3

import subprocess
import sys
import os
import logging

# Get the absolute path of the current script
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.abspath(os.path.join(current_dir, '..'))

# Add parent directory to the sys.path
sys.path.append(parent_dir)

# Import style_text from styles.styles
from styles.styles import style_text

# Setup logging
logging.basicConfig(filename='setup.log', level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

logging.info("Calling setup_nix.py...")
subprocess.run(['python3', os.path.join(parent_dir, 'setup', 'setup_nix.py')], check=True)
logging.info("Calling setup_qemu.py...")
subprocess.run(['python3', os.path.join(parent_dir, 'setup', 'setup_qemu.py')], check=True)
# logging.info("Calling setup_image.py...")
# subprocess.run(['python3', os.path.join(parent_dir, 'setup', 'setup_image.py')], check=True)