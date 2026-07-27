#!/usr/bin/env bash
set -e

echo "🧹 Убираем мусор из индекса..."
git rm --cached core/settings.py.bak core/settings.py.backup* 2>/dev/null || true
git rm --cached db.sqlite3 2>/dev/null || true

echo "✅ Добавляем нужные файлы..."
git add core/ employees/ workplaces/ manage.py requirements.txt .gitignore seed_data.py check_skills.py

echo "📝 Коммитим (если есть изменения)..."
git commit -m "chore: clean repo, remove backups" || echo "Нет изменений для коммита."

echo "🚀 Пушим в main..."
git push -u origin main

echo ""
echo "🎉 Готово: проект синхронизирован с веткой main!"
