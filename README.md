# Django Task Project: Сотрудники и галерея

Учебный проект на Django: список сотрудников, карточка с фото (с ранжированием), поиск, пагинация, экспорт в CSV, кэширование.

## Структура

- `core/` — настройки проекта, главный `urls.py`
- `emp_app/` — приложение сотрудников (модели, views, urls, admin)
- `templates/` — шаблоны (наследование от `base.html`)
- `static/` — CSS и прочие статические файлы
- `media/` — загруженные изображения (создаётся автоматически)
- `scripts/` — скрипты инициализации (seed, настройки)

## Быстрый старт

1. **Клонирование и окружение**
   ```bash
   git clone <ссылка-на-репозиторий>
   cd django-task-project
   python -m venv venv
   source venv/Scripts/activate   # Windows: venv\\Scripts\\activate
   pip install -r requirements.txt
