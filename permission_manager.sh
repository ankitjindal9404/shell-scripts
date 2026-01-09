#!/bin/bash

# Permission Manager Script
# Usage: ./permission_manager.sh <file_path> <permission_action>

set -e  # Exit on error

FILE_PATH=$1
permission_action=$2
LOG_FILE="./permission_manager.log"

#checking number of arguments
if [ "$#" -ne 2 ]; then
  echo "Error: Invalid number of arguments."
  echo ""
  echo "Available actions:"
  echo "  - add-permission"
  echo "  - remove-permission"
  echo "  - set-special-permission"
  exit 1
fi

#Checking file/directory existense
if [ ! -e "$FILE_PATH" ]; then
    echo "File $FILE_PATH does not exist."
    exit 1
fi

# Function to log changes
log_action() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $message" >> "$LOG_FILE"
}

case $permission_action in
    check)
        echo "=== Permission Check for: $FILE_PATH ==="
        if [ -d "$FILE_PATH" ]; then
            ls -ld "$FILE_PATH"
        else
            ls -l "$FILE_PATH"
        fi
        log_action "Checked permissions for $FILE_PATH"
        ;;
    add-permission)
        echo "=== Add Permission Menu ==="
        echo "1) Add read permission for user (u+r)"
        echo "2) Add write permission for user (u+w)"
        echo "3) Add execute permission for user (u+x)"
        echo "4) Add read permission for group (g+r)"
        echo "5) Add write permission for group (g+w)"
        echo "6) Add execute permission for group (g+x)"
        echo "7) Add read permission for others (o+r)"
        echo "8) Add write permission for others (o+w)"
        echo "9) Add execute permission for others (o+x)"
        echo "10) Add read for ALL (a+r)"
        echo "11) Add write for ALL (a+w)"
        echo "12) Add execute for ALL (a+x) - Make executable"
        echo "13) Add full permissions for user (u+rwx)"
        echo "14) Add full permissions for group (g+rwx)"
        echo "15) Add read+execute for all (a+rx) - Common for scripts"
        read -p "Enter choice (1-15): " choice

        case $choice in
            1) 
                chmod u+r "$FILE_PATH" && log_action "Added user read: $FILE_PATH" 
                echo "✓ Added read permission for user"
                ;;
            2) 
                chmod u+w "$FILE_PATH" && log_action "Added user write: $FILE_PATH" 
                echo "✓ Added write permission for user"
                ;;
            3) 
                chmod u+x "$FILE_PATH" && log_action "Added user execute: $FILE_PATH" 
                echo "✓ Added execute permission for user"
                ;;
            4) 
                chmod g+r "$FILE_PATH" && log_action "Added group read: $FILE_PATH" 
                echo "✓ Added read permission for group"
                ;;
            5) 
                chmod g+w "$FILE_PATH" && log_action "Added group write: $FILE_PATH" 
                echo "✓ Added write permission for group"
                ;;
            6) 
                chmod g+x "$FILE_PATH" && log_action "Added group execute: $FILE_PATH" 
                echo "✓ Added execute permission for group"
                ;;
            7) 
                chmod o+r "$FILE_PATH" && log_action "Added others read: $FILE_PATH" 
                echo "✓ Added read permission for others"
                ;;
            8) 
                chmod o+w "$FILE_PATH" && log_action "Added others write: $FILE_PATH" 
                echo "⚠️  WARNING: Others can now write to this file!"
                ;;
            9) 
                chmod o+x "$FILE_PATH" && log_action "Added others execute: $FILE_PATH" 
                echo "✓ Added execute permission for others"
                ;;
            10) 
                chmod a+r "$FILE_PATH" && log_action "Added read for all: $FILE_PATH" 
                echo "✓ Added read permission for all (user, group, others)"
                ;;
            11) 
                chmod a+w "$FILE_PATH" && log_action "Added write for all: $FILE_PATH" 
                echo "⚠️  WARNING: Everyone can now write to this file!"
                ;;
            12) 
                chmod a+x "$FILE_PATH" && log_action "Made executable for all: $FILE_PATH" 
                echo "✓ Made file executable for all users"
                ;;
            13) 
                chmod u+rwx "$FILE_PATH" && log_action "Added full permissions for user: $FILE_PATH" 
                echo "✓ User now has full permissions (read, write, execute)"
                ;;
            14) 
                chmod g+rwx "$FILE_PATH" && log_action "Added full permissions for group: $FILE_PATH" 
                echo "✓ Group now has full permissions (read, write, execute)"
                ;;
            15) 
                chmod a+rx "$FILE_PATH" && log_action "Added read+execute for all: $FILE_PATH" 
                echo "✓ All users can now read and execute (common for scripts)"
                ;;
            *) 
                echo "❌ Invalid choice! Please select 1-15"
                return 1
                ;;
        esac
        ;;
    remove-permission)
        echo "=== Remove Permission Menu ==="
        echo "1) Remove read permission from user (u-r)"
        echo "2) Remove write permission from user (u-w)"
        echo "3) Remove execute permission from user (u-x)"
        echo "4) Remove read permission from group (g-r)"
        echo "5) Remove write permission from group (g-w)"
        echo "6) Remove execute permission from group (g-x)"
        echo "7) Remove read permission from others (o-r)"
        echo "8) Remove write permission from others (o-w)"
        echo "9) Remove execute permission from others (o-x)"
        echo "10) Remove ALL permissions from others (o-rwx) - Security hardening"
        echo "11) Remove write from ALL (a-w) - Make read-only"
        echo "12) Remove execute from ALL (a-x)"
        echo "13) Remove write from group and others (go-w)"
        echo "14) Remove all permissions from group (g-rwx)"
        echo "15) Strip all 'others' permissions (chmod o=)"
        
        read -p "Enter choice: " choice

        case $choice in
            1) 
                chmod u-r "$FILE_PATH" && log_action "Removed user read: $FILE_PATH" 
                echo "✓ Removed read permission from user (owner)"
                ;;
            2) 
                chmod u-w "$FILE_PATH" && log_action "Removed user write: $FILE_PATH" 
                echo "✓ Removed write permission from user (owner)"
                ;;
            3) 
                chmod u-x "$FILE_PATH" && log_action "Removed user execute: $FILE_PATH" 
                echo "✓ Removed execute permission from user (owner)"
                ;;
            4) 
                chmod g-r "$FILE_PATH" && log_action "Removed group read: $FILE_PATH" 
                echo "✓ Removed read permission from group"
                ;;
            5) 
                chmod g-w "$FILE_PATH" && log_action "Removed group write: $FILE_PATH" 
                echo "✓ Removed write permission from group"
                ;;
            6) 
                chmod g-x "$FILE_PATH" && log_action "Removed group execute: $FILE_PATH" 
                echo "✓ Removed execute permission from group"
                ;;
            7) 
                chmod o-r "$FILE_PATH" && log_action "Removed others read: $FILE_PATH" 
                echo "✓ Removed read permission from others"
                ;;
            8) 
                chmod o-w "$FILE_PATH" && log_action "Removed others write: $FILE_PATH" 
                echo "✓ Removed write permission from others"
                ;;
            9) 
                chmod o-x "$FILE_PATH" && log_action "Removed others execute: $FILE_PATH" 
                echo "✓ Removed execute permission from others"
                ;;
            10) 
                chmod o-rwx "$FILE_PATH" && log_action "Removed all others perms: $FILE_PATH" 
                echo "✓ Removed ALL permissions from others (Security hardening)"
                ;;
            11) 
                chmod a-w "$FILE_PATH" && log_action "Made read-only for all: $FILE_PATH" 
                echo "✓ Made file read-only for everyone (removed write from all)"
                ;;
            12) 
                chmod a-x "$FILE_PATH" && log_action "Removed execute from all: $FILE_PATH" 
                echo "✓ Removed execute permission from all users"
                ;;
            13) 
                chmod go-w "$FILE_PATH" && log_action "Removed write from group+others: $FILE_PATH" 
                echo "✓ Removed write permission from group and others"
                ;;
            14) 
                chmod g-rwx "$FILE_PATH" && log_action "Removed all group perms: $FILE_PATH" 
                echo "✓ Removed ALL permissions from group"
                ;;
            15) 
                chmod o= "$FILE_PATH" && log_action "Stripped all others perms: $FILE_PATH" 
                echo "✓ Stripped all permissions from others (using o=)"
                ;;
            *) 
                echo "❌ Invalid choice! Please select 1-15"
                return 1
                ;;
        esac
        ;;
    set-special-permission)
        echo "=== Special Permission Menu ==="
        echo "SUID (Set User ID) - 4xxx:"
        echo "  1) Add SUID (chmod u+s or chmod 4755)"
        echo "  2) Remove SUID (chmod u-s)"
        echo "  → File executes with OWNER's permissions"
        echo "  → Example: /usr/bin/passwd runs as root"
        echo ""
        echo "SGID (Set Group ID) - 2xxx:"
        echo "  3) Add SGID on file (chmod g+s or chmod 2755)"
        echo "  4) Add SGID on directory (chmod g+s or chmod 2775)"
        echo "  5) Remove SGID (chmod g-s)"
        echo "  → On FILE: Executes with GROUP's permissions"
        echo "  → On DIRECTORY: New files inherit directory's group"
        echo ""
        echo "Sticky Bit - 1xxx:"
        echo "  6) Add Sticky Bit (chmod +t or chmod 1777)"
        echo "  7) Remove Sticky Bit (chmod -t)"
        echo "  → Only file OWNER can delete in directory"
        echo "  → Example: /tmp directory"
        echo ""
        echo "Combined:"
        echo "  8) SUID + SGID (chmod 6755)"
        echo "  9) SGID + Sticky Bit (chmod 3775)"
        echo "  10) Remove ALL special bits (chmod 0755)"
        read -p "Choice: " choice

        case $choice in
            1) 
                chmod u+s "$FILE_PATH"
                log_action "Added SUID to $FILE_PATH"
                echo "⚠️  WARNING: SUID is a security risk - use carefully!"
                echo "✓ File will now execute with owner's privileges"
                ls -l "$FILE_PATH"
                ;;
            
            2)
                chmod u-s "$FILE_PATH"
                log_action "Removed SUID from $FILE_PATH"
                echo "✓ SUID bit removed successfully"
                ls -l "$FILE_PATH"
                ;;
            
            3) 
                chmod g+s "$FILE_PATH"
                log_action "Added SGID to file $FILE_PATH"
                echo "✓ File will now execute with group's privileges"
                ls -l "$FILE_PATH"
                ;;
            
            4) 
                if [ -d "$FILE_PATH" ]; then
                    chmod g+s "$FILE_PATH"
                else
                    echo "❌ Error: $FILE_PATH is not a directory!"
                    echo "   Use option 3 for files"
                fi
                ;;
            5)
                chmod g-s "$FILE_PATH"
                log_action "Removed SGID from $FILE_PATH"
                echo "✓ SGID bit removed successfully"
                if [ -d "$FILE_PATH" ]; then
                    echo "  Note: New files will no longer inherit the directory's group"
                fi
                ls -l "$FILE_PATH"
                ;;
        
            6) 
                if [ -d "$FILE_PATH" ]; then
                    chmod +t "$FILE_PATH"
                    log_action "Added Sticky Bit to directory $FILE_PATH"
                    echo "✓ Only file owners can delete files in this directory"
                    echo "✓ Sticky bit is now active"
                    ls -ld "$FILE_PATH"
                else
                    echo "⚠️  WARNING: Sticky bit is typically used on directories"
                    read -p "   Continue anyway? (y/n): " confirm
                    if [ "$confirm" = "y" ]; then
                        chmod +t "$FILE_PATH"
                        log_action "Added Sticky Bit to file $FILE_PATH"
                        echo "✓ Sticky bit added"
                        ls -l "$FILE_PATH"
                    else
                        echo "Operation cancelled"
                    fi
                fi
                ;;
        
            7)
                chmod -t "$FILE_PATH"
                log_action "Removed Sticky Bit from $FILE_PATH"
                echo "✓ Sticky bit removed successfully"
                if [ -d "$FILE_PATH" ]; then
                    echo "  Note: Any user with write permission can now delete files"
                fi
                ls -l "$FILE_PATH"
                ;;
            
            8)
                echo "⚠️  WARNING: Setting both SUID and SGID"
                echo "   This is a significant security configuration!"
                read -p "   Are you sure? (yes/no): " confirm
                if [ "$confirm" = "yes" ]; then
                    chmod 6755 "$FILE_PATH"
                    log_action "Set SUID+SGID (6755) on $FILE_PATH"
                    echo "✓ Both SUID and SGID bits are now set"
                    echo "  File will execute with owner AND group privileges"
                    ls -l "$FILE_PATH"
                else
                    echo "Operation cancelled"
                fi
                ;;
            
            9)
                if [ -d "$FILE_PATH" ]; then
                    chmod 3775 "$FILE_PATH"
                    log_action "Set SGID+Sticky Bit (3775) on directory $FILE_PATH"
                    echo "✓ SGID + Sticky Bit set successfully"
                    echo "  - New files inherit group: $(stat -c '%G' $FILE_PATH)"
                    echo "  - Only owners can delete files"
                    echo "  Perfect for shared team directories!"
                    ls -ld "$FILE_PATH"
                else
                    echo "⚠️  This combination is designed for directories"
                    read -p "   Continue anyway? (y/n): " confirm
                    if [ "$confirm" = "y" ]; then
                        chmod 3755 "$FILE_PATH"
                        log_action "Set SGID+Sticky Bit (3755) on file $FILE_PATH"
                        echo "✓ Special bits applied"
                        ls -l "$FILE_PATH"
                    else
                        echo "Operation cancelled"
                    fi
                fi
                ;;
            
            10)
                read -p "Remove ALL special bits and set to 755? (y/n): " confirm
                if [ "$confirm" = "y" ]; then
                    chmod 0755 "$FILE_PATH"
                    log_action "Removed all special bits from $FILE_PATH (set to 0755)"
                    echo "✓ All special permission bits removed"
                    echo "  Permissions reset to: rwxr-xr-x (755)"
                    ls -l "$FILE_PATH"
                else
                    echo "Operation cancelled"
                fi
                ;;
            
            *)
                echo "❌ Invalid choice! Please select 1-10"
                return 1
                ;;
        esac
        ;;
    *)
        echo "Invalid action!"
        ;;
esac

echo ""
echo "✅ Operation completed successfully!"
echo "📝 Log saved to: $LOG_FILE"

#Testing commands for scripts
# 1. Make script executable
# chmod +x permission_manager.sh

# 2. Test check action
# ./permission_manager.sh /tmp check

# 3. Test add permission
# ./permission_manager.sh test.txt add-permission
# # Choose option 12 (make executable)

# 4. Test remove permission
# ./permission_manager.sh test.txt remove-permission
# # Choose option 10 (remove all others permissions)

# 5. Test special permissions on directory
# mkdir test_dir
# ./permission_manager.sh test_dir set-special-permission
# # Choose option 9 (SGID + Sticky)

# 6. Check the log
# cat ./permission_manager.log