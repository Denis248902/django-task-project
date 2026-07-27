#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/Denis248902/django-task-project.git"

echo "🔧 Удаляем старый origin..."
git remote remove origin || true

echo "➕ Добавляем правильный remote..."
git remote add origin "$REPO_URL"

echo "🚀 Пушим и создаём ветку main..."
git push -u origin main

echo "✅ Готово! Проверь репозиторий на GitHub."
