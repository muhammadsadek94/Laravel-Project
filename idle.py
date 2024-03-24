#!/usr/bin/env python3

from time import sleep

def main():
    sleep(10)
    raise Exception("Application Crashing")

if __name__ == "__main__":
    print("Starting the simple test application")
    main()



















# idle.py

import time

#def main():
    # Simulate some work (sleep for 10 seconds)
#    print("Starting idle process...")
#    time.sleep(10)
#    print("Idle process completed.")

#if __name__ == "__main__":
#    main()












# idle_runner.py

#import subprocess

#def main():
    # Run Supervisor with the provided configuration file
#    subprocess.run(["supervisorctl", "-c", "/etc/supervisor/supervisord.conf", "update"])

#if __name__ == "__main__":
#    main()

