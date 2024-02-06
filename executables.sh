# run.sh
# D.A.Pelasgus

#!/bin/bash

# Make scripts executable
make_executable() {
    chmod +x "$SCRIPT_DIR/styles/styles.py" || handle_error "Failed to make styles.py executable"
    chmod +x "$SCRIPT_DIR/styles/styles.sh" || handle_error "Failed to make styles.sh executable"
    chmod +x "$SCRIPT_DIR/uninstall.sh" || handle_error "Failed to make uninstall.sh executable"
    chmod +x "$SCRIPT_DIR/mac_cleanup.sh" || handle_error "Failed to make mac_cleanup.sh executable"
    chmod +x "$SCRIPT_DIR/launcher_qemu.py" || handle_error "Failed to make launcher_qemu.py executable"
    chmod +x "$SCRIPT_DIR/setup/setup_python.sh" || handle_error "Failed to make setup_python.sh executable"
    chmod +x "$SCRIPT_DIR/setup/setup_directory.py" || handle_error "Failed to make setup_directory.py executable"
    chmod +x "$SCRIPT_DIR/setup/setup_nix.py" || handle_error "Failed to make setup_nix.py executable"
    chmod +x "$SCRIPT_DIR/setup/setup_qemu.py" || handle_error "Failed to make setup_qemu.py executable"
    chmod +x "$SCRIPT_DIR/setup/setup_image.py" || handle_error "Failed to make setup_image.py executable"
    chmod +x "$SCRIPT_DIR/setup/setup_compression_status.py" || handle_error "Failed to make setup_compression_status.py executable"
    chmod +x "$SCRIPT_DIR/setup/flake_qemu.nix" || handle_error "Failed to make flake_qemu.nix executable"
}