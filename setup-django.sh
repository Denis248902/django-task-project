#!/usr/bin/env bash
set -e

echo "🚀 Запуск полной настройки Django‑проекта..."

# --- Модели: workplaces/models.py ---
mkdir -p workplaces
cat > workplaces/models.py << 'PYEOF'
from django.db import models

class Workplace(models.Model):
    name = models.CharField(max_length=200, unique=True)
    location = models.CharField(max_length=255, blank=True)
    description = models.TextField(blank=True)

    def __str__(self):
        return self.name
PYEOF
echo "✅ Создан workplaces/models.py"

# --- Модели: employees/models.py ---
mkdir -p employees
cat > employees/models.py << 'PYEOF'
from django.db import models
from workplaces.models import Workplace

class Employee(models.Model):
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    position = models.CharField(max_length=150)
    workplace = models.ForeignKey(
        Workplace,
        on_delete=models.SET_NULL,
        null=True,
        related_name='employees',
    )
    hire_date = models.DateField()

    class Meta:
        ordering = ['last_name', 'first_name']

    def __str__(self):
        return f"{self.first_name} {self.last_name}"
PYEOF
echo "✅ Создан employees/models.py"

# --- Миграции ---
echo "🗄️ Запуск makemigrations..."
venv/Scripts/python manage.py makemigrations

echo "🗄️ Запуск migrate..."
venv/Scripts/python manage.py migrate
echo "✅ Миграции применены."

# --- Форматирование кода (PEP 8) ---
echo "🎨 Форматируем код через black..."
venv/Scripts/python -m black .

echo "📦 Сортируем импорты через isort..."
venv/Scripts/python -m isort .
echo "✅ Код отформатирован (black + isort)."

# --- requirements.txt ---
echo "📋 Сохраняем зависимости в requirements.txt..."
venv/Scripts/pip freeze > requirements.txt
echo "✅ requirements.txt создан."

# --- Git ---
if [ ! -d .git ]; then
  echo "💾 Инициализируем Git..."
  git init
  git config user.name "Denis248902"
  git config user.email "denisdotniy@yandex.ru"
fi

cat > .gitignore << 'EOF'
venv/
__pycache__/
*.pyc
db.sqlite3
.DS_Store
.env
