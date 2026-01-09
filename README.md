# Shell Scripts Collection

This repository contains various Shell scripts. Each script performs a specific function that can be useful for automating common tasks on a system.

## Scripts Overview

### 1. `permission_manager.sh`
This script is to manage file permissions for a multi-user system with strict security requirements.
The script will:
1.	Check the file permissions for a given file or directory. Update permissions based on a user-defined rule (e.g., making a file executable for all users).
2.	Add and remove specific users or groups from a file’s ownership (group and user). 
3.	Apply special permissions like SUID, SGID, and Sticky Bit to specific files.
4.	Log all changes made by the script to a log file with a timestamp.

The script should take two arguments:
File/Directory Path: Path of the file/directory to be managed.
Permission Action: The action to be performed (check, add-permission, remove-permission, set-special-permission).

### 2. `process_manager.sh`
This will manage processes on a system. The script will:
1.	List all running processes with detailed information (PID, process name, and status).
2.	Kill a process by its PID or name.
3.	Monitor a specific process (whether it’s running, how many instances, and status).
