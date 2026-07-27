#!/usr/bin/env bash
set -e

SETTINGS_FILE="core/settings.py"

# Проверяем, есть ли уже наши приложения — чтобы не дублировать при повторном запуске
if grep -q "'workplaces'" "$SETTINGS_FILE" && grep -q "'employees'" "$SETTINGS_FILE"; then
  echo "✅ Приложения уже зарегистрированы в INSTALLED_APPS."
  exit 0
fi

echo "🛠️ Регистрируем приложения workplaces и employees в INSTALLED_APPS..."

# Ищем строку "INSTALLED_APPS = [" и после неё добавляем наши приложения
# Используем sed: вставляем строки сразу после найденного шаблона
sed -i.bak '/^INSTALLED_APPS = \[/a\    '"'"'workplaces'"'",' "$SETTINGS_FILE"
sed -i.bak '/^INSTALLED_APPS = \[/a\    '"'"'employees'"'",' "$SETTINGS_FILE"

echo "✅ Приложения успешно добавлены."
echo ""
echo "Проверь результат командой:"
echo "  grep -A 10 'INSTALLED_APPS' core/settings.py"
