# styles.py
# author: D.A.Pelasgus
import subprocess

def style_text(text):
    # Call the shell script to style the text
    return subprocess.run(['bash', '-c', f'source styles.sh && style_text "{text}"'], capture_output=True, text=True).stdout
