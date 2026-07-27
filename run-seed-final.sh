#!/usr/bin/env bash
set -e

if [ -z "$VIRTUAL_ENV" ]; then
    echo "⚠️ venv не активирован. Пытаюсь активировать..."
    if [ -f "venv/Scripts/activate" ]; then
        source venv/Scripts/activate
    else
        echo "❌ Не найден venv. Проверь структуру."
        exit 1
    fi
fi

# ВАЖНО: задаём настройки Django ПЕРЕД любым импортом моделей
export DJANGO_SETTINGS_MODULE="core.settings"

echo "🔍 Поля EmployeeProfile (обычные, без связей):"
python -c "import django; django.setup(); from employees.models import EmployeeProfile; print([f.name for f in EmployeeProfile._meta.get_fields() if not f.is_relation and not f.one_to_one])"

echo "🔍 Поля Workplace (обычные, без связей):"
python -c "import django; django.setup(); from workplaces.models import Workplace; print([f.name for f in Workplace._meta.get_fields() if not f.is_relation])"

echo "🌱 Запускаем seed_data.py..."
python seed_data.py
