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
parent_dir="$HOME/omd"
station_name=""
input_source=""
length_of_time=300

# Parse command-line arguments
while getopts "s:t:p:" opt; do
    case $opt in
        s) station_name="$OPTARG" ;;
        t) length_of_time="$OPTARG" ;;
        p) parent_dir="$OPTARG" ;;
        \?) echo "Invalid option: -$opt" >&2; exit 1 ;;
    esac
done

# Check if station name is provided
if [ -z "$station_name" ]; then
    echo "Station name is required. Use the -s option to provide it."
    exit 1
fi

# Set input source based on station name
case $station_name in
    "WKLB") input_source="https://22833.live.streamtheworld.com/WKLBFMAACIHR.aac" ;;
    "WROR") input_source="https://26363.live.streamtheworld.com/WRORFMAACIHR_SC" ;;
    *) echo "Unknown station name: $station_name" >&2; exit 1 ;;
esac

# Get the current date and time components
current_date=$(date +"%Y %m %d %H%M%S")
current_year=$(echo "$current_date" | awk '{print $1}')
current_month=$(echo "$current_date" | awk '{print $2}')
current_day=$(echo "$current_date" | awk '{print $3}')
current_time=$(echo "$current_date" | awk '{print $4}')

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

# Get the current date and time components
current_date=$(date +"%Y %m %d %H%M%S")
current_year=$(echo "$current_date" | awk '{print $1}')
current_month=$(echo "$current_date" | awk '{print $2}')