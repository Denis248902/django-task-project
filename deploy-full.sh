#!/usr/bin/env bash
set -e

if [ -z "$VIRTUAL_ENV" ]; then
    echo "⚠️ venv не активирован. Пытаемся активировать..."
    if [ -f "venv/Scripts/activate" ]; then
        source venv/Scripts/activate
    else
        echo "❌ Не найден venv. Проверь структуру."
        exit 1
    fi
fi

export DJANGO_SETTINGS_MODULE="core.settings"

echo "🗃️ Делаем миграции..."
python manage.py makemigrations --check || echo "⚠️ Есть изменения в моделях — генерируем миграции."
python manage.py makemigrations
python manage.py migrate

echo "🌱 Запускаем seed (с навыками и уровнями)..."
python seed_data.py

echo ""
echo "✅ Готово!"
echo "👉 Админка: http://127.0.0.1:8000/admin/"
echo "   Логин: ivan_petrov"
echo "   Пароль: password123"
echo ""
