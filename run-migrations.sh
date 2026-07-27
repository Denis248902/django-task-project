#!/usr/bin/env bash
set -e

if [ -z "$VIRTUAL_ENV" ]; then
    if [ -f "venv/Scripts/activate" ]; then
        source venv/Scripts/activate
    else
        echo "❌ venv не найден"
        exit 1
    fi
fi

export DJANGO_SETTINGS_MODULE="core.settings"

echo "🗃️ Делаем миграции..."
python manage.py makemigrations
python manage.py migrate
echo "✅ Миграции завершены"
