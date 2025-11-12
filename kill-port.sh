#!/bin/bash
# Script to forcefully kill all processes on a specific port

PORT=${1:-5000}

echo "🔍 Finding processes on port $PORT..."

PIDS=$(lsof -ti:$PORT)

if [ -z "$PIDS" ]; then
    echo "✅ No processes found on port $PORT"
    exit 0
fi

echo "Found processes: $PIDS"
echo "🔪 Killing processes..."

for PID in $PIDS; do
    echo "  Killing PID: $PID"
    kill -9 $PID 2>/dev/null
done

sleep 2

# Verify
REMAINING=$(lsof -ti:$PORT)
if [ -z "$REMAINING" ]; then
    echo "✅ Port $PORT is now free!"
else
    echo "⚠️  Warning: Some processes may still be running: $REMAINING"
    echo "Try running: sudo lsof -ti:$PORT | xargs sudo kill -9"
fi

