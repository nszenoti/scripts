import os
import sys

def find_relative_path(start_path, target_path):
    start_path = os.path.abspath(start_path)
    target_path = os.path.abspath(target_path)
    relative_path = os.path.relpath(target_path, start_path)
    return relative_path

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python relative_path.py <target_path>")
        #print("Usage: python relative_path.py <current_path> <target_path>")
        sys.exit(1)

    #current_path = sys.argv[1]
    current_path = os.getcwd()
    target_path = sys.argv[1]
    print(find_relative_path(current_path, target_path))
