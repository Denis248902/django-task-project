#!/usr/bin/env bash
set -e

FILE="templates/emp_app/employee_detail.html"

sed -i '/{{ employee.full_name }}/a\
{% if employee.images.first %}\n\
  <img src="{{ employee.images.first.image.url }}" alt="Main photo" style="max-width:200px; border:1px solid #ccc;">\n\
{% else %}\n\
  <span style="color:#999;">Нет заглавного фото</span>\n\
{% endif %}\n' "$FILE"

sed -i '/{{ employee.position }}/a\
<p><strong>Пол:</strong> {{ employee.get_gender_display }}</p>\n\
<p><strong>Навыки:</strong>\n\
  {% for skill in employee.skills %}\n\
    {{ skill.name }} (уровень {{ skill.level }}),\n\
  {% endfor %}\n\
</p>\n\
<p><strong>Стаж в компании:</strong> {{ employee.tenure_days }} дней</p>\n\
<p><strong>Номер стола:</strong> {{ employee.desk_number|default:"не назначен" }}</p>\n' "$FILE"

# Галерея без первого фото
sed -i '/<!-- Галерея -->/a\
{% for img in employee.images.all|slice:"1:" %}\n\
  <img src="{{ img.image.url }}" alt="Photo {{ forloop.counter }}" style="max-width:150px; margin:4px;">\n\
{% endfor %}\n' "$FILE"

# Если нет комментария "<!-- Галерея -->", добавляем галерею в конец явно
if ! grep -q "<!-- Галерея -->" "$FILE"; then
  cat >> "$FILE" << 'HTMLEOF'
<h3>Галерея (кроме заглавного)</h3>
{% for img in employee.images.all|slice:"1:" %}
  <img src="{{ img.image.url }}" alt="Photo {{ forloop.counter }}" style="max-width:150px; margin:4px;">
{% endfor %}
HTMLEOF
fi

echo "✅ Шаблон employee_detail.html обновлён"
