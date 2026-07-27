#!/usr/bin/env bash
set -e

SETTINGS_FILE="core/settings.py"
BACKUP_FILE="${SETTINGS_FILE}.backup-before-full-replace"

echo "💾 Делаем бэкап: $BACKUP_FILE"
cp "$SETTINGS_FILE" "$BACKUP_FILE"

# Находим строку начала INSTALLED_APPS
START_LINE=$(grep -n "^[[:space:]]*INSTALLED_APPS[[:space:]]*=[[:space:]]*" "$SETTINGS_FILE" | head -1 | cut -d: -f1)
if [ -z "$START_LINE" ]; then
  echo "❌ Не найдено 'INSTALLED_APPS' в $SETTINGS_FILE"
  exit 1
fi
echo "🔎 INSTALLED_APPS начинается со строки $START_LINE"

# Ищем закрывающую скобку ], начиная с START_LINE
END_LINE=$(awk -v start="$START_LINE" 'NR >= start && /^[[:space:]]*\]/' "$SETTINGS_FILE" | head -1)
# Если не нашли строго по началу строки — ищем просто первое ] после START_LINE
if [ -z "$END_LINE" ]; then
  END_LINE=$(awk -v start="$START_LINE" 'NR >= start && /\]/' "$SETTINGS_FILE" | head -1)
fi

if [ -z "$END_LINE" ]; then
  echo "❌ Не найдена закрывающая ']' для INSTALLED_APPS"
  exit 1
fi
echo "🔎 Закрывающая скобка найдена"

# Создаём новый чистый блок
NEW_BLOCK='INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "django.contrib.messages",
    "django.contrib.staticfiles",

    # Наши приложения (только Config-версии, без дублей)
    "employees.apps.EmployeesConfig",
    "workplaces.apps.WorkplacesConfig",
]'

# Пересоздаём файл: всё до START_LINE + НОВЫЙ БЛОК + всё после END_LINE
awk -v start="$START_LINE" -v end_line_content="$END_LINE" -v new_block="$NEW_BLOCK" '
{
  if (NR < start) {
    print $0
  } else if (NR == start) {
    print new_block
    skip = 1
  } else if (skip == 1) {
    if ($0 ~ /^[[:space:]]*\]/) {
      skip = 2
    }
  } else {
    print $0
  }
}
' "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp" && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"

echo "✅ Блок INSTALLED_APPS полностью заменён на чистый."
echo "🗃️ Теперь проверяем, что дубли ушли."
