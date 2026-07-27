#!/usr/bin/env bash
set -e

SETTINGS_FILE="core/settings.py"

echo "🔍 Ищем дубли в $SETTINGS_FILE..."

# Сначала делаем бэкап
cp "$SETTINGS_FILE" "${SETTINGS_FILE}.bak"
echo "✅ Бэкап: ${SETTINGS_FILE}.bak"

# Удаляем строки с простыми именами приложений (оставляем только Config)
sed -i '/^[[:space:]]*"employees",[[:space:]]*$/d' "$SETTINGS_FILE"
sed -i '/^[[:space:]]*"workplaces",[[:space:]]*$/d' "$SETTINGS_FILE"

echo "🧹 Удалены дубли: 'employees' и 'workplaces' (оставлены только Config-версии)."

# Проверяем, что Config-версии точно есть
if ! grep -q "employees.apps.EmployeesConfig" "$SETTINGS_FILE"; then
  sed -i "/INSTALLED_APPS = \[/a\    'employees.apps.EmployeesConfig'," "$SETTINGS_FILE"
fi

if ! grep -q "workplaces.apps.WorkplacesConfig" "$SETTINGS_FILE"; then
  sed -i "/INSTALLED_APPS = \[/a\    'workplaces.apps.WorkplacesConfig'," "$SETTINGS_FILE"
fi

echo "✅ Готово. Проверь core/settings.py — там должны остаться только Config-строки."
echo "🗃️ Теперь можно делать миграции."
