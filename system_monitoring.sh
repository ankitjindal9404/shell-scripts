#!/bin/bash


# System Monitoring Script

echo "Calculating CPU usage"
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{print $4}' | awk '{print $1}')

#using bc command for decimal calculation and using echo because bc command can't take from command instead it takes from STDIN
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)

echo "Current CPU Usage: $CPU_USAGE%"

echo "Calculating Memory Usage"
TOTAL_MEMORY=$(free | grep "Mem" | awk '{print $2}')
USED_MEMORY=$(free | grep "Mem" | awk '{print $3}')

MEMORY_USAGE=$(($USED_MEMORY * 100 / $TOTAL_MEMORY))

echo "Current Memory Usage: $MEMORY_USAGE%"

echo "Calculating Disk Usage on each mounted filesystem"
DISK_USAGE=$(df -h | awk '{print $1, $5}')

echo "Current Disk Usage on each mounted filesystem:"
echo $DISK_USAGE

timestamp=$(date +%"F %T")

WEBHOOK_URL="https://hooks.slack.com/services/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"

#function for notification
notify_slack() {
    local message="$1"
    curl -s -X POST -H 'Content-type: application/json' \
        --data '{"text":"'"$message"'"}' \
        "$WEBHOOK_URL"
    echo ""
}

#Setting threshold of 80%.
if (( $(echo "$CPU_USAGE > 80" | bc -l) )); then
    message="*System Status Report:*\n• Metric Type: CPU\n• Current Usage: $CPU_USAGE%\n• Hostname: $HOSTNAME\n• Timestamp: $timestamp"
    notify_slack "$message"
elif (( $(echo "$MEMORY_USAGE > 80" | bc -l) )); then
    message="*System Status Report:*\n• Metric Type: CPU\n• Current Usage: $CPU_USAGE%\n• Hostname: $HOSTNAME\n• Timestamp: $timestamp"
    notify_slack "$message"
fi

# "Checking disk usage thresholds..."
df -h | tail -n +2 | while read -r line; do
    FILESYSTEM=$(echo "$line" | awk '{print $1}')
    MOUNT_POINT=$(echo "$line" | awk '{print $6}')
    USAGE=$(echo "$line" | awk '{print $5}' | sed 's/%//')
    
    if [ "$USAGE" -gt 80 ]; then
        message="*System Status Report:*\n• Metric Type: Disk\n• Filesystem: $FILESYSTEM\n• Mount Point: $MOUNT_POINT\n• Current Usage: $USAGE%\n• Hostname: $HOSTNAME\n• Timestamp: $timestamp"
        notify_slack "$message"
    fi
done


# # testing messsage
# test_message="*🧪 Test Alert*\n• This is a test notification\n• Hostname: $HOSTNAME\n• Timestamp: $timestamp"
# notify_slack "$test_message"
