#!/bin/sh

APP_DIR=/opt/health-app
PID_FILE="$APP_DIR/app.pid"

if [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null; then
    exit 0
fi

cd "$APP_DIR"
nohup java -jar target/app.jar > "$APP_DIR/app.log" 2>&1 &
echo $! > "$PID_FILE"
