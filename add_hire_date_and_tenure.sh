#!/usr/bin/env bash
set -e

FILE="emp_app/models.py"

# Вставляем hire_date и tenure_days в класс EmployeeProfile
# Используем sed: ищем строку "desk_number" и после неё добавляем новые поля
sed -i "/desk_number = models.IntegerField/,/def __str__/ {
    /desk_number = models.IntegerField/a\
    hire_date = models.DateField(null=False, blank=False)
}" "$FILE"

# Добавляем property tenure_days перед def __str__
sed -i '/def __str__/,/}/ {
    /def __str__/i\
    @property\n\
    def tenure_days(self):\n\
        from datetime import date\n\
        today = date.today()\n\
        if self.hire_date:\n\
            return (today - self.hire_date).days\n\
        return 0
}' "$FILE"

echo "✅ hire_date и tenure_days добавлены в models.py"
