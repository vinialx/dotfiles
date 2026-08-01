#!/nix/store/rgnappqqc5vbq60gza5fflyk84sylwl6-python3-3.14.6/bin/python3

import subprocess


def get_output(cmd):
    try:
        return subprocess.check_output(cmd, shell=True).decode("utf-8").strip().splitlines()
    except subprocess.CalledProcessError:
        return ""


o = get_output("rfkill list")
for line in o:
    if "Soft blocked: yes" in line or "Hard blocked: yes" in line:
        print("airplane-mode-symbolic")
        print("")
        break
