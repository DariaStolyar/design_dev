#!/usr/bin/env bash

PID_FILE="system_monitor.pid"

is_running() {
    [ -f "$PID_FILE" ] && kill -0 "$(cat "$PID_FILE")" 2>/dev/null
}

get_cpu_usage() {
    CPU1=$(awk '/^cpu / { print $2+$3+$4+$5+$6+$7+$8+$9, $5+$6 }' /proc/stat)
    sleep 1
    CPU2=$(awk '/^cpu / { print $2+$3+$4+$5+$6+$7+$8+$9, $5+$6 }' /proc/stat)

    awk -v first="$CPU1" -v second="$CPU2" 'BEGIN {
        split(first, a)
        split(second, b)
        printf "%.2f", 100 * (1 - (b[2]-a[2])/(b[1]-a[1]))
    }'
}

write_report() {
    MEMORY=$(free -m | awk '/^Mem:/ { printf "%s;%s;%.2f", $2, $4, $3*100/$2 }')
    CPU_USED=$(get_cpu_usage)
    DISK_USED=$(df -P / | awk 'NR == 2 { gsub("%", "", $5); print $5 }')
    LOAD_AVERAGE=$(awk '{ print $1 }' /proc/loadavg)
    REPORT_FILE="system_report_$(date '+%Y-%m-%d').csv"

    if [ ! -s "$REPORT_FILE" ]; then
        echo 'timestamp;all_memory;free_memory;%memory_used;%cpu_used;%disk_used;load_average_1m' > "$REPORT_FILE"
    fi

    echo "$(date '+%Y-%m-%d %H:%M:%S');$MEMORY;$CPU_USED;$DISK_USED;$LOAD_AVERAGE" >> "$REPORT_FILE"
}

if [ "${1:-}" = "RUN" ]; then
    while true; do
        write_report
        sleep 600
    done
fi

if [ "$#" -ne 1 ]; then
    echo "Использование: $0 START|STOP|STATUS" >&2
    exit 1
fi

case "$1" in
    START)
        if is_running; then
            echo "Мониторинг уже запущен. PID: $(cat "$PID_FILE")"
        else
            nohup "$0" RUN >/dev/null 2>&1 &
            echo $! > "$PID_FILE"
            echo "Мониторинг запущен. PID: $(cat "$PID_FILE")"
        fi
        ;;
    STOP)
        if is_running; then
            kill "$(cat "$PID_FILE")"
            rm -f "$PID_FILE"
            echo "Мониторинг остановлен."
        else
            rm -f "$PID_FILE"
            echo "Мониторинг не запущен."
        fi
        ;;
    STATUS)
        if is_running; then
            echo "Мониторинг запущен. PID: $(cat "$PID_FILE")"
        else
            rm -f "$PID_FILE"
            echo "Мониторинг не запущен."
        fi
        ;;
    *)
        echo "Неизвестная команда: $1" >&2
        exit 1
        ;;
esac
