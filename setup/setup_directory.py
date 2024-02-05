# setup_directory.py
# author: D.A.Pelasgus

import os
import shutil
import tarfile
import zipfile
import subprocess
from styles import style_text

def unzip_untar_move_cleanup():
    # Step 1: Request user to enter a path
    user_path = input(style_text("Enter the path to the compressed file: ")).strip()

    # Step 2: Verify that the path ends in a compress file
    if not (user_path.endswith('.zip') or user_path.endswith('.tar.gz')):
        print(style_text("Error: The provided file is not a valid compressed file."))
        return

    # Step 3: Unzip/Untar the file
    destination_folder = os.path.splitext(user_path)[0]
    if user_path.endswith('.zip'):
        with zipfile.ZipFile(user_path, 'r') as zip_ref:
            zip_ref.extractall(destination_folder)
    elif user_path.endswith('.tar.gz'):
        with tarfile.open(user_path, 'r:gz') as tar_ref:
            tar_ref.extractall(destination_folder)

    # Step 4: Change directory into the extracted folder
    os.chdir(destination_folder)

    # Step 5: Delete the original compressed file
    os.remove(user_path)

    # Step 6: Navigate to the internal folder 'ova'
    ova_folder_path = os.path.join(destination_folder, 'ova')
    if not os.path.exists(ova_folder_path):
        print(style_text("Error: 'ova' folder not found in the extracted contents."))
        return

    os.chdir(ova_folder_path)

    # Step 7: Move the contents of 'ova' to Documents/xinix/installation and rename to "vm.vmdk"
    documents_path = os.path.expanduser('~' + os.sep + 'Documents')
    xinix_path = os.path.join(documents_path, 'xinix')
    installation_path = os.path.join(xinix_path, 'installation')

    if not os.path.exists(installation_path):
        os.makedirs(installation_path)

    for item in os.listdir(ova_folder_path):
        item_path = os.path.join(ova_folder_path, item)
        if os.path.isfile(item_path):
            # Rename to "vm.vmdk" during the move
            shutil.move(item_path, os.path.join(installation_path, "vm.vmdk"))

    # Step 8: Delete everything else from the contents of 'ova'
    for remaining_item in os.listdir(ova_folder_path):
        remaining_item_path = os.path.join(ova_folder_path, remaining_item)
        if os.path.isfile(remaining_item_path):
            os.remove(remaining_item_path)
        elif os.path.isdir(remaining_item_path):
            shutil.rmtree(remaining_item_path)

    # Step 9: Delete the parent directory of 'ova' and its contents
    os.chdir(documents_path)
    shutil.rmtree(destination_folder)

    print(style_text("Unzipping, moving, and cleanup completed successfully."))

if __name__ == "__main__":
    unzip_untar_move_cleanup()