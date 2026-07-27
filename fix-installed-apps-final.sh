#!/usr/bin/env bash
set -e

SETTINGS_FILE="core/settings.py"
BACKUP_FILE="${SETTINGS_FILE}.bak"

echo "🔍 Делаем бэкап: $BACKUP_FILE"
cp "$SETTINGS_FILE" "$BACKUP_FILE"

# 1. Удаляем ВСЕ строки, где есть employees или workplaces
sed -i '/employees/d' "$SETTINGS_FILE"
sed -i '/workplaces/d' "$SETTINGS_FILE"
echo "✅ Все упоминания employees/workplaces удалены."

# 2. Находим строку с INSTALLED_APPS = [ и запоминаем её номер
START_LINE=$(grep -n "^INSTALLED_APPS[[:space:]]*=[[:space:]]*\[" "$SETTINGS_FILE" | head -1 | cut -d: -f1)
if [ -z "$START_LINE" ]; then
  echo "❌ Не найдено 'INSTALLED_APPS = [' в $SETTINGS_FILE"
  exit 1
fi
echo "🔎 INSTALLED_APPS начинается со строки $START_LINE"

# 3. Пересоздаём блок INSTALLED_APPS целиком — это самый надёжный способ
# Сначала сделаем временный файл
awk -v start="$START_LINE" '
{
  if (NR == start) {
    print "INSTALLED_APPS = ["
    print "    \"django.contrib.admin\","
    print "    \"django.contrib.auth\","
    print "    \"django.contrib.contenttypes\","
    print "    \"django.contrib.sessions\","
    print "    \"django.contrib.messages\","
    print "    \"django.contrib.staticfiles\","
    print ""
    print "    # Наши приложения"
    print "    \"employees.apps.EmployeesConfig\","
    print "    \"workplaces.apps.WorkplacesConfig\","
    skip = 1
  } else if (skip == 1 && $0 ~ /\]/) {
    # Нашли закрывающую скобку — пропускаем её, мы её уже «пересоздали» в print выше
    skip = 2
  } else if (skip != 2) {
    print $0
  }
}
' "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp" && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"

echo "✅ Готово: INSTALLED_APPS пересоздан, дубли удалены."
echo "🗃️ Теперь можно делать миграции."
