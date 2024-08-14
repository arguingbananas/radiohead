#!/bin/bash

# Function to create a directory and check for errors
create_directory() {
    local dir_path="$1"
    mkdir -p "${dir_path}"
    if [ $? -ne 0 ]; then
        echo "Failed to create directory ${dir_path}."
        exit 1
    fi
}

# Default values
length_of_time=300
input_source="https://22833.live.streamtheworld.com/WKLBFMAACIHR.aac"
parent_dir="$HOME/omd"
station_name=""

# Parse command-line arguments
while getopts "t:i:p:s:" opt; do
    case $opt in
        t) length_of_time="$OPTARG" ;;
        i) input_source="$OPTARG" ;;
        p) parent_dir="$OPTARG" ;;
        s) station_name="$OPTARG" ;;
        \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
    esac
done

done

# Check if station name is provided
if [ -z "$station_name" ]; then
    echo "Station name is required. Use the -s option to provide it."
    exit 1
fi

# Get the current date and time components
current_year=$(date +"%Y") # e.g., 2024
current_month=$(date +"%m") # e.g., 04
current_day=$(date +"%d") # e.g., 23
current_time=$(date +"%H%M%S") # e.g., 143205

# Construct the full path for the output directories
output_dir="${parent_dir}/${current_year}/${current_month}/${current_day}/${station_name}/${current_time}"
logs_dir="${output_dir}/logs"
streams_dir="${output_dir}/streams"

# Create the necessary directories
create_directory "${logs_dir}"
create_directory "${streams_dir}"

# Run ffmpeg command to record stream and log output
XDG_RUNTIME_DIR=/run/user/$(id -u) ffmpeg -t "${length_of_time}" -i "${input_source}" "${streams_dir}/${station_name}-${current_time}.mp3" > "${logs_dir}/${station_name}-${current_time}.log" 2>&1
if [ $? -ne 0 ]; then
    echo "ffmpeg command failed. Check the log at ${logs_dir}/${station_name}-${current_time}.log for details."
    exit 1
fi

echo "Recording completed successfully. Check the logs and recordings in ${output_dir}."