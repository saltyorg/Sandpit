#!/bin/bash
# Author(s): salty
# script to monitor for gluetun health changes,check and restart the Plex docker container.
# checks every 10 minutes.
# can append as many urls as you want for the curl check
# This should run continiously.

# Container names
plex_container="plex"
gluetun_container="gluetun"

# Log file path
log_file="/home/seed/logs/plex_restart.txt"

# Interval for the curl check (in minutes)
curl_check_interval=10

# URLs to check for connectivity
urls=("icanhazip.com" "example.com" "another-service.com")

# Function to check if a container is running
is_container_running() {
    running=$(docker inspect --format="{{.State.Running}}" "$1" 2>/dev/null)
    if [[ "$running" == "true" ]]; then
        return 0
    else
        return 1
    fi
}

# Function to perform a curl check on multiple URLs using docker exec
perform_curl_check() {
    for url in "${urls[@]}"; do
        if docker exec "$plex_container" curl -s "$url" > /dev/null; then
            return 0
        fi
    done
    return 1
}

# Process Docker events
process_docker_events() {
    docker events --filter "type=container" --filter "container=$gluetun_container" --filter "event=health_status" | 
    while read -r event
    do
        if [[ $event == *"health_status: healthy"* ]]; then
            timestamp=$(date +"%Y-%m-%d %H:%M:%S")
            if is_container_running "$plex_container"; then
                if ! perform_curl_check; then
                    echo "$timestamp - Connectivity check failed: Restarting $plex_container" >> "$log_file"
                    docker restart "$plex_container"
                    echo "$timestamp - $plex_container restarted due to connectivity check" >> "$log_file"
                else
                    echo "$timestamp - $gluetun_container is healthy, connectivity check passed" >> "$log_file"
                fi
            else
                echo "$timestamp - $plex_container is not running, skipping connectivity check" >> "$log_file"
            fi
        fi
    done
}

# Start processing Docker events in the background
process_docker_events &

# Periodic connectivity check loop
while true; do
    timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    if (( $(date +%s) % (curl_check_interval * 60) == 0 )); then
        if is_container_running "$plex_container"; then
            if ! perform_curl_check; then
                echo "$timestamp - Periodic connectivity check failed: Restarting $plex_container" >> "$log_file"
                docker restart "$plex_container"
                echo "$timestamp - $plex_container restarted due to periodic connectivity check" >> "$log_file"
            fi
        else
            echo "$timestamp - $plex_container is not running, skipping periodic connectivity check" >> "$log_file"
        fi
    fi
    sleep 60 # Check every minute if it's time for a connectivity check
done
