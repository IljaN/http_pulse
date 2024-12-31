#!/bin/sh
# Beep when url passed in argument is reachable. Requires curl and ffmpeg (ffplay) to be installed.

USAGE=$(cat <<EOF
Check url for reachability via HTTP response code and beep when it is reachable

Usage: $0 URL [check_interval_secs] [status-range]

Arguments:
  URL                    The url to check (required).
  check-interval-secs    Optional. The interval in seconds between checks (default: 30).
  status-range           Optional. The range of HTTP status codes to consider successful (default: 200-299).

Examples:
  $0 https://www.github.com 3 200-201
  $0 somelocalhost:8080
EOF
)

# Check if curl is installed to make the HTTP request
if ! command -v "curl" >/dev/null 2>&1; then
  echo 'Error: curl command is missing. Please install the "curl" package' >&2
  exit 1
fi

# Check if curl is installed to make the HTTP request
if ! command -v "ffplay" >/dev/null 2>&1; then
  echo 'Error: ffplay command is missing. Please install the "ffmpeg" package' >&2
  exit 1
fi

# Take the url to check as required argument for the script
if [ -z "$1" ] || [ "$1" = "-h" ] || [ "$1" = "--help" ] ; then
  echo "$USAGE" >&2
  exit 1
fi


url="$1" # URL to check
check_interval_secs="${2:-30}" # Interval to check the URL, default is 30 seconds
status_range="${3:-200-299}" # HTTP status code range to consider successful, default is 200-299

# Extract the lower and upper bounds from the range argument (example: 200-299)
status_lower_bound=$(echo "$status_range" | cut -d'-' -f1)
status_upper_bound=$(echo "$status_range" | cut -d'-' -f2)

readonly BEEP_SYNTH_PARAMS="sine=frequency=1000:duration=0.2"

echo "[$(date --rfc-3339=seconds)] Checking $url every $check_interval_secs seconds and beep as soon as the HTTP response code is in range of $status_range:"

while true; do
  response_status=$(curl -o /dev/null -s -w "%{http_code}" -L "$url")
  if [ "$response_status" -ge "$status_lower_bound" ] && [ "$response_status" -le "$status_upper_bound" ]; then
    echo "[$(date --rfc-3339=seconds)] $url is reachable with HTTP status code $response_status."
    ffplay -loglevel quiet -f lavfi -i $BEEP_SYNTH_PARAMS -autoexit -nodisp >/dev/null 2>&1 &
  else
    echo "[$(date --rfc-3339=seconds)] $url is unreachable with HTTP status code $response_status."
  fi
  sleep "$check_interval_secs"
done
