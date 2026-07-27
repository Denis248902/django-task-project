#!/usr/bin/env bash
set -e

SETTINGS_FILE="core/settings.py"

echo "🔍 Проверяем, есть ли закрывающая скобка после INSTALLED_APPS..."

# Ищем строку с INSTALLED_APPS
START_LINE=$(grep -n "^INSTALLED_APPS[[:space:]]*=[[:space:]]*\[" "$SETTINGS_FILE" | head -1 | cut -d: -f1)
if [ -z "$START_LINE" ]; then
  echo "❌ Не найдено 'INSTALLED_APPS = ['"
  exit 1
fi

# Ищем следующую закрывающую скобку после START_LINE
END_LINE=$(awk -v start="$START_LINE" 'NR >= start && /\]/' "$SETTINGS_FILE" | head -1)

if [ -z "$END_LINE" ]; then
  echo "⚠️ Не найдена закрывающая скобка ']' после INSTALLED_APPS — добавляем её в конец файла."
  # Просто дописываем одну строку в конец
  echo "]" >> "$SETTINGS_FILE"
  echo "✅ Добавлена закрывающая скобка."
else
  echo "✅ Закрывающая скобка уже есть."
fi

echo "🗃️ Теперь пробуем миграции."
