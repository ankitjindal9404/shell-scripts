#!/bin/bash

# Process Management Script

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

        # Check if input is empty
        if [ -z "$input" ]; then
            echo "Error: No input provided"
            exit 1
        fi
    
        # Check if input is a number (PID)
        if [[ "$input" =~ ^[0-9]+$ ]]; then
            # It's a PID
            if ps -p "$input" > /dev/null 2>&1; then
                echo "Process with PID $input is RUNNING"
                echo "Number of instances: 1"
                echo "Details:"
                ps -p "$input" -o pid,comm,%cpu,%mem,stat
            else
                echo "Process with PID $input is NOT running"
            fi
        else
            # It's a process name
            pids=$(pgrep -f "$input" 2>/dev/null)

            # Check if pids is empty
            if [ -z "$pids" ]; then
                echo "Process matching '$input' is NOT running"
                exit 1
            fi
            count=$(echo "$pids" | wc -l)
        
            echo "Process matching '$input' is RUNNING"
            echo "Number of instances: $count"
            echo "Details:"
            echo "$pids" | xargs ps -o pid,comm,%cpu,%mem,stat -p 2>/dev/null

        fi
        ;;
    *)
        echo "Invalid Action!"
        echo "Kindly add from these 3 options: List, Kill, Monitor"
        ;;
esac
