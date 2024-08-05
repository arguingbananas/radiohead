#!/bin/bash

# Declare an array of directory names
mydirs=("logs" "streams")

# Get the current date and time
mydate=$(date +"%Y%m%d-%H%M%S")

# Create the parent directory
parent_dir="$HOME/runs/$mydate"
mkdir -p "$parent_dir"

# Check if the parent directory was created successfully
if [ $? -ne 0 ]; then
    echo "Failed to create parent directory $parent_dir."
    exit 1
fi

# Loop through each directory name in the array
for adir in "${mydirs[@]}"; do
    # Construct the full path for the directory
    full_path="$parent_dir/$adir"
    
    # Check if the directory does not exist
    if [ ! -d "$full_path" ]; then
        # Create the directory
        mkdir -p "$full_path"
        # Check if the mkdir command was successful
        if [ $? -ne 0 ]; then
            echo "Failed to create $full_path directory."
            exit 1
        fi
    fi
done

# Default values
length_of_time=300
input_source="https://22833.live.streamtheworld.com/WKLBFMAACIHR.aac"
station_name=WKLBFM

# Parse command-line arguments
while getopts "t:i:s:" opt; do
    case $opt in
        t) length_of_time="$OPTARG" ;;
        i) input_source="$OPTARG" ;;
        s) station_name="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
    esac
done

# Run ffmpeg command to record stream and log output
XDG_RUNTIME_DIR=/run/user/$(id -u) ffmpeg -t "$length_of_time" -i "$input_source" "$parent_dir/streams/$station_name-$mydate.mp3" > "$parent_dir/logs/ffmpeg-$mydate.log" 2>&1
if [ $? -ne 0 ]; then
    echo "ffmpeg command failed. Check the log at $parent_dir/logs/ffmpeg-$mydate.log for details."
    exit 1
fi

echo "Recording completed successfully. Check the logs and recordings in $parent_dir."