#!/bin/bash

conf="./conf/"
ini_files=($(find "$conf" -type f -name "*.ini"))
pids=()

for file in "${ini_files[@]}"
do
    bash ./worker.sh "$file" &
    pids+=($!)
done

trap 'kill ${pids[@]}' SIGINT SIGTERM EXIT
wait