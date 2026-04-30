#!/bin/bash

THRESHOLD=90
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')

if (( $(echo "$MEMORY_USAGE > $THRESHOLD" | bc -l) )); then
    sync; echo 3 > /proc/sys/vm/drop_caches
fi

ZOMBIES=$(ps axo stat,pid,ppid,comm | grep -w defunct)
if [ ! -z "$ZOMBIES" ]; then
    echo "$ZOMBIES" | awk '{ print $3 }' | xargs kill -9
fi