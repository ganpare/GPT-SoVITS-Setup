#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
PyOpenJTalk dictionary checker and installer
"""

import sys

def check_and_install_pyopenjtalk():
    """Check if pyopenjtalk dictionary exists and install if needed"""
    try:
        import pyopenjtalk
        import os
        import shutil
        
        # Apply Windows path workaround (from GPT_SoVITS/text/japanese.py)
        if os.name == "nt":
            python_dir = os.getcwd()
            OPEN_JTALK_DICT_DIR = pyopenjtalk.OPEN_JTALK_DICT_DIR.decode("utf-8")
            
            # Check if path contains non-ASCII characters (common Windows issue)
            import re
            if not (re.match(r"^[A-Za-z0-9_/\\:.\-]*$", OPEN_JTALK_DICT_DIR)):
                print("Applying Windows path encoding fix...")
                
                if not os.path.exists("TEMP"):
                    os.mkdir("TEMP")
                if not os.path.exists(os.path.join("TEMP", "ja")):
                    os.mkdir(os.path.join("TEMP", "ja"))
                
                temp_dict_path = os.path.join("TEMP", "ja", "open_jtalk_dic")
                if os.path.exists(temp_dict_path):
                    shutil.rmtree(temp_dict_path)
                
                # Copy dictionary to safe ASCII path
                shutil.copytree(OPEN_JTALK_DICT_DIR, temp_dict_path)
                pyopenjtalk.OPEN_JTALK_DICT_DIR = temp_dict_path.encode("utf-8")
                print(f"Dictionary copied to: {temp_dict_path}")
        
        # Test pyopenjtalk after path fix
        pyopenjtalk.g2p('テスト')
        print("Japanese dictionary is working correctly.")
        return True
        
    except Exception as e:
        print(f"pyopenjtalk error: {e}")
        
        # Try alternative: reinstall pyopenjtalk
        print("Attempting to reinstall pyopenjtalk...")
        try:
            import subprocess
            subprocess.check_call([sys.executable, "-m", "pip", "uninstall", "pyopenjtalk", "-y"])
            subprocess.check_call([sys.executable, "-m", "pip", "install", "pyopenjtalk"])
            
            import pyopenjtalk
            pyopenjtalk.g2p('テスト')
            print("pyopenjtalk reinstallation successful.")
            return True
            
        except Exception as e2:
            print(f"Reinstallation failed: {e2}")
            print("\nManual fix required:")
            print("1. pip uninstall pyopenjtalk")
            print("2. pip install pyopenjtalk")
            print("3. Or use alternative: pip install pyopenjtalk-dict")
            return False

if __name__ == "__main__":
    success = check_and_install_pyopenjtalk()
    sys.exit(0 if success else 1)