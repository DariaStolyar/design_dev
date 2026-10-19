#!/usr/bin/env bash

if [ "$#" -ne 3 ]; then
    echo "Использование: $0 <ссылка> <ветка_1> <ветка_2>" >&2
    exit 1
fi

REPOSITORY=$1
BRANCH_1=$2
BRANCH_2=$3
TEMP_DIR=$(mktemp -d) || exit 1
trap 'rm -rf "$TEMP_DIR"' EXIT

git clone -q "$REPOSITORY" "$TEMP_DIR/repository" || exit 1

DIFF_FILE="$TEMP_DIR/diff.txt"
git -C "$TEMP_DIR/repository" diff --no-renames --name-status \
    "origin/$BRANCH_1" "origin/$BRANCH_2" > "$DIFF_FILE" || exit 1

TOTAL=$(wc -l < "$DIFF_FILE" | tr -d '[:space:]')
ADDED=$(awk -F '\t' '$1 == "A" { count++ } END { print count + 0 }' "$DIFF_FILE")
DELETED=$(awk -F '\t' '$1 == "D" { count++ } END { print count + 0 }' "$DIFF_FILE")
MODIFIED=$(awk -F '\t' '$1 == "M" { count++ } END { print count + 0 }' "$DIFF_FILE")

FILE_BRANCH_1=${BRANCH_1//\//_}
FILE_BRANCH_2=${BRANCH_2//\//_}
REPORT_FILE="diff_report_${FILE_BRANCH_1}_vs_${FILE_BRANCH_2}.txt"

{
    echo "Отчет о различиях между ветками"
    echo
    echo "================================"
    echo "Репозиторий:    $REPOSITORY"
    echo "Ветка 1:        $BRANCH_1"
    echo "Ветка 2:        $BRANCH_2"
    echo "Дата генерации: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "================================"
    echo
    echo "СПИСОК ИЗМЕНЕННЫХ ФАЙЛОВ:"
    cat "$DIFF_FILE"
    echo
    echo "СТАТИСТИКА:"
    echo "Всего измененных файлов: $TOTAL"
    echo "Добавлено (A):           $ADDED"
    echo "Удалено (D):             $DELETED"
    echo "Изменено (M):            $MODIFIED"
} > "$REPORT_FILE"

echo "Отчет создан: $REPORT_FILE"
