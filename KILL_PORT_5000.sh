#!/bin/bash
# Script to kill process using port 5000

echo "Finding process on port 5000..."
PID=$(lsof -ti:5000)

if [ -z "$PID" ]; then
    echo "No process found on port 5000"
else
    echo "Killing process $PID..."
    kill -9 $PID
    sleep 1
    echo "Port 5000 is now free"
fi

