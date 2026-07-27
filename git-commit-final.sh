#!/usr/bin/env bash
set -e

# Добавляем все изменённые и новые файлы
git add .

# Делаем коммит с понятным сообщением
git commit -m "feat: finalize admin with inline skills, confirm seed data, fix migrations"

echo "✅ Коммит создан!"
