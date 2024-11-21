#!/bin/bash

conf="conf/"
ini_files=($(find "$conf" -type f -name "*.ini"))

for file in "${ini_files[@]}"
do
    bash worker.sh "$file" &
done

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT
wait