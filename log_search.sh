#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
    echo "Использование: $0 <лог-файл> <слово>" >&2
    exit 1
fi

LOG_FILE=$1
KEYWORD=$2

if [ ! -r "$LOG_FILE" ]; then
    echo "Не удалось прочитать файл: $LOG_FILE" >&2
    exit 1
fi

RESULT_FILE="errors_$(basename "$LOG_FILE").txt"
COUNT_FILE="count_$(basename "$LOG_FILE").txt"

grep -F -- "$KEYWORD" "$LOG_FILE" > "$RESULT_FILE"
COUNT=$(wc -l < "$RESULT_FILE" | tr -d '[:space:]')
echo "$COUNT" > "$COUNT_FILE"

echo "Найдено строк: $COUNT"
echo "Результат сохранен в файл: $RESULT_FILE"
echo "Количество сохранено в файл: $COUNT_FILE"
