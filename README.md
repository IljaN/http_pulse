# http_pulse.sh

A shell script which beeps like a [pulse oximeter](https://en.wikipedia.org/wiki/Pulse_oximetry) if a given http url returns a successful status-code. Useful if you need to wait
for a certain service to be available to continue a certain task and don't want to constantly hit F5 in your browser.

## Usage
```bash
./http_pulse.sh --help
Check url for reachability via HTTP response code and beep when it is reachable

Usage: ./http_pulse.sh URL [check_interval_secs] [status-range]

Arguments:
  URL                    The url to check (required).
  check-interval-secs    Optional. The interval in seconds between checks (default: 30).
  status-range           Optional. The range of HTTP status codes to consider successful (default: 200-299).

Examples:
  ./http_pulse.sh https://www.github.com 3 200-201
  ./http_pulse.sh somelocalhost:8080
```
### Example Output
```bash
$ ./http_pulse.sh https://www.github.com 3 200-201
[2024-12-31 19:47:39+01:00] Checking https://www.github.com every 3 seconds and beep as soon as the HTTP response code is in range of 200-201:
[2024-12-31 19:47:39+01:00] https://www.github.com is reachable with HTTP status code 200.
[2024-12-31 19:47:42+01:00] https://www.github.com is reachable with HTTP status code 200.
[2024-12-31 19:47:46+01:00] https://www.github.com is reachable with HTTP status code 200.
[2024-12-31 19:47:49+01:00] https://www.github.com is reachable with HTTP status code 200.
```
## Requirements
- curl and ffmpeg (ffplay) needs to be installed on your system.
