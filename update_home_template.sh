#!/usr/bin/env bash
set -e

FILE="templates/emp_app/employee_list.html"

# Вставляем блок с общим количеством и 4 последними сотрудниками
# Ищем закрывающий тег </h1> или начало карточек и добавляем туда
sed -i '/<h1>/a\
<p>Всего сотрудников: {{ total_employees }}</p>\n\
<h2>4 последних по дате приёма</h2>\n\
<div class="latest-cards">\n\
  {% for emp in latest_4 %}\n\
    <div class="card">\n\
      <h3>{{ emp.full_name }}</h3>\n\
      <p>Должность: {{ emp.position }}</p>\n\
      {% if emp.images.first %}\n\
        <img src="{{ emp.images.first.image.url }}" alt="Photo" style="max-width:100px;">\n\
      {% else %}\n\
        <span style="color:#999;">Нет фото</span>\n\
      {% endif %}\n\
      <p>Стаж: {{ emp.tenure_days }} дн.</p>\n\
    </div>\n\
  {% endfor %}\n\
</div>\n' "$FILE"

echo "✅ Шаблон employee_list.html обновлён"
