#!/usr/bin/env bash
set -e

SETTINGS_FILE="core/settings.py"
BACKUP_FILE="${SETTINGS_FILE}.bak"

echo "🔍 Делаем бэкап: $BACKUP_FILE"
cp "$SETTINGS_FILE" "$BACKUP_FILE"

# Находим начало и конец блока INSTALLED_APPS
START_LINE=$(grep -n "^INSTALLED_APPS = \[" "$SETTINGS_FILE" | head -1 | cut -d: -f1)
if [ -z "$START_LINE" ]; then
  echo "❌ Не найдено 'INSTALLED_APPS = [' в $SETTINGS_FILE"
  exit 1
fi

# Ищем закрывающую скобку после START_LINE
END_LINE=$(awk -v start="$START_LINE" '
BEGIN { in_block = 0; brace_count = 0 }
NR >= start {
  if (!in_block && /INSTALLED_APPS[[:space:]]*=[[:space:]]*\[/) {
    in_block = 1; brace_count = 1
  }
  if (in_block) {
    brace_count += gsub(/\[/, "&")
    brace_count -= gsub(/\]/, "&")
  }
  if (in_block && brace_count == 0) {
    print NR
    exit
  }
}
' "$SETTINGS_FILE")

if [ -z "$END_LINE" ]; then
  # Если awk не нашёл — ищем просто следующую закрывающую скобку
  END_LINE=$(awk -v start="$START_LINE" 'NR >= start && /\]/' | head -1 | cut -d: -f1)
  if [ -z "$END_LINE" ]; then
    echo "❌ Не удалось найти конец блока INSTALLED_APPS"
    exit 1
  fi
fi

echo "🧹 Пересоздаём блок INSTALLED_APPS (строки $START_LINE–$END_LINE)..."

# Создаём новый блок
NEW_BLOCK=$(cat <<PY
INSTALLED_APPS = [
    # Django core
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    # Наши приложения (только Config)
    'employees.apps.EmployeesConfig',
    'workplaces.apps.WorkplacesConfig',
]
PY
)

# Перезаписываем блок в файле
awk -v start="$START_LINE" -v end="$END_LINE" -v new="$NEW_BLOCK" '
{
  if (NR == start) {
    print new
    skip_until = end
  } else if (NR > start && NR <= skip_until) {
    next
  } else {
    print $0
  }
}
' "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp" && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"

echo "✅ Готово: INSTALLED_APPS почищен, остались только Config-версии."
echo "🗃️ Теперь можно делать миграции."
