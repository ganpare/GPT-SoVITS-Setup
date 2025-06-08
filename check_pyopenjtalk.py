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
        # Try to use pyopenjtalk with a simple test
        pyopenjtalk.g2p('テスト')
        print("Japanese dictionary is available.")
        return True
    except Exception as e:
        print(f"Japanese dictionary not found: {e}")
        print("Attempting to install dictionary...")
        try:
            # This should trigger dictionary download
            pyopenjtalk.g2p('テスト')
            print("Dictionary installation completed.")
            return True
        except Exception as e2:
            print(f"Failed to install dictionary: {e2}")
            print("Please install pyopenjtalk dictionary manually:")
            print("python -c \"import pyopenjtalk; pyopenjtalk.g2p('テスト')\"")
            return False

if __name__ == "__main__":
    success = check_and_install_pyopenjtalk()
    sys.exit(0 if success else 1)