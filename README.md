# radiohead
Timeshift recordings for radio trivia shows

usage() {
    echo "Usage: $0 [-s station_name] [-t length_of_time] [-b base_dir]"
    echo "  -s station_name   Name of the station (required)"
    echo "  -t length_of_time Length of time in seconds (default: 300)"
    echo "  -b base_dir       Base directory (default: \$HOME/omd)"
    echo "  -h                Display this help message"
    exit 1
}