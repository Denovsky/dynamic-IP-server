#!/bin/bash

# daemon_logs="/var/log/detect_ip_change_daemon"
daemon_logs="./" #use your own catalog

while true; do
    a="$(cat $daemon_logs/file.log)"
    b="$(curl -s ifconfig.me)"
    if [ "$a" = "$b" ]; then
        echo "Equals!"
    else
        past_ip_time="$(cat $daemon_logs/time.log)"
        current_ip_time="$(date +%s)"
        delta=$((current_ip_time-past_ip_time))
        sec=$((delta%60))
        min=$((delta/60))
        hour=$((delta/60/60))
        days=$((delta/60/60/24))
        echo "$days:$hour:$min:$sec - $a" >> change.log
        echo "$b" > $daemon_logs/file.log
        echo "$current_ip_time" > $daemon_logs/time.log
        echo "Not equals!"
    fi  
    sleep 5
done