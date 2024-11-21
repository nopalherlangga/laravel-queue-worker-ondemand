#!/bin/bash

if [[ -z "$1" ]]; then
    echo "Usage: $0 <path-to-ini-file>"
    exit 1
fi

ini_file="$1"

# Check if the file exists
if [[ ! -f "$ini_file" ]]; then
    echo "File '$ini_file' does not exist."
    exit 1
fi

get_value() {
    key=$1
    value=$(awk -F '=' '/^[^;]*'"$key"'[^;]*=/ {gsub(/^[ \t]+|[ \t]+$/, "", $2); print $2; exit}' "$ini_file")
    echo "$value"
}

dir=$(get_value "dir")
usr=$(get_value "user")
cmd=$(get_value "cmd")
db=$(get_value "db")

if [[ ! -d "$dir" ]]; then
    echo "No such directory"
    exit 1
fi

echo "[worker] running"

su - $usr -c "cd $dir && $cmd" &
echo "[worker] Start with PID $!"

while true
do
    jobs=$(mysql $db -se "select count(*) from jobs;" --skip-column-names)
    wn=$((($jobs / 50)))
    cw=${#pids[@]}

    if [[ $cw > $wn ]]; then
        n=$(($cw-$wn))
        pids=($(pgrep -P $$))
        for ((i=1; i<=$n; i++))
        do
            echo "[worker] Kill PID "${pids[i]}
        done
    else
        n=$(($wn-1))
        for ((i=1; i<=$n; i++))
        do
            su - $usr -c "cd $dir && $cmd" &
            echo "[worker] Start with PID $!"
        done
    fi
    sleep 1
done