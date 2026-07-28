#!/usr/bin/env bash
set -e

FILE="emp_app/models.py"

# Сначала импортируем ValidationError, если его ещё нет
if ! grep -q "from django.core.exceptions import ValidationError" "$FILE"; then
  sed -i '1i from django.core.exceptions import ValidationError' "$FILE"
fi

# Ищем def __str__ и перед ним вставляем метод clean()
sed -i '/def __str__/i \
\n\
    def clean(self):\n\
        super().clean()\n\
        # Если стол не указан — валидацию не делаем\n\
        if not self.desk_number:\n\
            return\n\
\n\
        def is_tester(e):\n\
            return e.role == "tester"\n\
\n\
        def is_dev(e):\n\
            return e.role in ["backend", "frontend", "fullstack"]\n\
\n\
        current_is_tester = is_tester(self)\n\
        current_is_dev = is_dev(self)\n\
\n\
        others = EmployeeProfile.objects.exclude(pk=self.pk).filter(desk_number__isnull=False)\n\
        for other in others:\n\
            other_is_tester = is_tester(other)\n\
            other_is_dev = is_dev(other)\n\
\n\
            if (current_is_tester and other_is_dev) or (current_is_dev and other_is_tester):\n\
                if abs(self.desk_number - other.desk_number) <= 1:\n\
                    raise ValidationError(\n\
                        f"Нельзя сажать тестировщика и разработчика за соседние столы. "\n\
                        f"Конфликт со столом {other.desk_number} ({other.full_name})."\n\
                    )\n' "$FILE"

echo "✅ Валидатор desk_number добавлен в models.py"
