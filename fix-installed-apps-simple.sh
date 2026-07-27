#!/usr/bin/env bash
set -e

SETTINGS_FILE="core/settings.py"
BACKUP_FILE="${SETTINGS_FILE}.bak"

echo "🔍 Делаем бэкап: $BACKUP_FILE"
cp "$SETTINGS_FILE" "$BACKUP_FILE"

# 1. Удаляем ЛЮБЫЕ строки, где есть employees или workplaces (это уберёт и простые, и Config, если они уже были)
sed -i '/employees/d' "$SETTINGS_FILE"
sed -i '/workplaces/d' "$SETTINGS_FILE"
echo "✅ Удалены все строки с employees и workplaces."

# 2. Находим строку с закрывающей скобкой ] в INSTALLED_APPS и вставляем перед ней наши приложения
# Это самый надёжный способ добавить в конец списка
sed -i "/^[[:space:]]*\]/i\    'employees.apps.EmployeesConfig',\n    'workplaces.apps.WorkplacesConfig'," "$SETTINGS_FILE"

echo "✅ Готово: INSTALLED_APPS почищен и дополнен Config-версиями."
echo "🗃️ Теперь можно делать миграции."
