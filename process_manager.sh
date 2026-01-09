#!/bin/bash

# Process Management Script

set -e  # Exit on error

process_action=$1

case $process_action in
    List)
        ps aux
        ;;
    Kill)
        read -p "Enter PID or Process Name: " input
        
        # Check if input is a number (PID) or name
        if [[ "$input" =~ ^[0-9]+$ ]]; then
            # It's a PID
            if ps -p "$input" > /dev/null 2>&1; then
                kill "$input" && echo "Process $input killed successfully"
            else
                echo "Process with PID $input not found"
            fi
        else
            # It's a process name
            if pgrep "$input" > /dev/null; then
                pkill "$input" && echo "Process(es) '$input' killed successfully"
            else
                echo "No process found with name '$input'"
            fi
        fi
        ;;
    Monitor)
        read -p "Enter PID or Process Name: " input
    
    # Check if input is a number (PID)
    if [[ "$input" =~ ^[0-9]+$ ]]; then
        # It's a PID
        if ps -p "$input" > /dev/null 2>&1; then
            echo "Process with PID $input is RUNNING"
            echo "Number of instances: 1"
            echo "Details:"
            ps -p "$input" -o pid,comm,stat
        else
            echo "Process with PID $input is NOT running"
        fi
    else
        # It's a process name
        count=$(pgrep -c "$input" 2>/dev/null)
        
        if [ "$count" -gt 0 ]; then
            echo "Process '$input' is RUNNING"
            echo "Number of instances: $count"
            echo "Details:"
            pgrep -l "$input"
        else
            echo "Process '$input' is NOT running"
        fi
    fi
        ;;
    *)
        echo "Invalid Action!"
        echo "Kindly add from these 3 options: List, Kill, Monitor"
        ;;
esac
