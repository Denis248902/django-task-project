#!/usr/bin/env bash
set -e

FILE="templates/emp_app/employee_list.html"

if ! grep -q "page_obj.has_other_pages" "$FILE"; then
  cat >> "$FILE" << 'PAGEOF'

{% if page_obj.has_other_pages %}
  <nav>
    {% if page_obj.has_previous %}
      <a href="?page={{ page_obj.previous_page_number }}">←</a>
    {% endif %}

    {% for num in page_obj.paginator.page_range %}
      {% if page_obj.number == num %}
        <strong>{{ num }}</strong>
      {% else %}
        <a href="?page={{ num }}">{{ num }}</a>
      {% endif %}
    {% endfor %}

    {% if page_obj.has_next %}
      <a href="?page={{ page_obj.next_page_number }}">→</a>
    {% endif %}
  </nav>
{% endif %}
PAGEOF
  echo "✅ Пагинатор добавлен в шаблон"
else
  echo "✅ Пагинатор уже есть в шаблоне"
fi
