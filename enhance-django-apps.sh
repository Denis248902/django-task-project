#!/usr/bin/env bash
set -e

# ================= НАСТРОЙКИ =================
# Имя папки, где лежит settings.py
SETTINGS_DIR="core"

if [ ! -d "$SETTINGS_DIR" ]; then
  echo "❌ Папка $SETTINGS_DIR не найдена. Выполни 'ls' и поправь SETTINGS_DIR в скрипте."
  exit 1
fi

SETTINGS_FILE="$SETTINGS_DIR/settings.py"
echo "📂 Используем настройки из: $SETTINGS_FILE"

# ================= 1. Создаём apps.py, если нет =================
for app in employees workplaces; do
  if [ -d "$app" ]; then
    if [ ! -f "$app/apps.py" ]; then
      echo "➕ Создаём $app/apps.py..."
      cat > "$app/apps.py" <<APPS
from django.apps import AppConfig

class ${app^}Config(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = '$app'
APPS
    else
      echo "✅ $app/apps.py уже есть."
    fi
  else
    echo "❌ Папка $app не найдена."
    exit 1
  fi
done

# ================= 2. Добавляем приложения в INSTALLED_APPS =================
echo "📝 Обновляем $SETTINGS_FILE: добавляем apps.Config..."

add_to_installed_apps() {
  local entry="$1"
  if ! grep -q "$entry" "$SETTINGS_FILE"; then
    sed -i "/INSTALLED_APPS = \[/a\    '$entry'," "$SETTINGS_FILE"
    echo "✅ Добавлено: $entry"
  else
    echo "⚠️ Уже есть: $entry"
  fi
}

add_to_installed_apps "employees.apps.EmployeesConfig"
add_to_installed_apps "workplaces.apps.WorkplacesConfig"

# ================= 3. Пишем models.py =================
cat > employees/models.py << 'MODELS_EMP'
from django.contrib.auth.models import User
from django.db import models
from django.core.exceptions import ValidationError

class Skill(models.Model):
    name = models.CharField('навык', max_length=50)

    def __str__(self):
        return self.name


class EmployeeProfile(models.Model):
    GENDER_CHOICES = [('M', 'Мужской'), ('F', 'Женский'), ('O', 'Другой')]

    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    gender = models.CharField('пол', max_length=1, choices=GENDER_CHOICES, blank=True, null=True)
    first_name = models.CharField('имя', max_length=30)
    last_name = models.CharField('фамилия', max_length=30)
    middle_name = models.CharField('отчество', max_length=30, blank=True, null=True)
    description = models.TextField('описание', blank=True, null=True)

    skills = models.ManyToManyField(Skill, through='EmployeeSkillLevel', related_name='employees')

    def __str__(self):
        return f"{self.last_name} {self.first_name}"


class EmployeeSkillLevel(models.Model):
    employee = models.ForeignKey(EmployeeProfile, on_delete=models.CASCADE)
    skill = models.ForeignKey(Skill, on_delete=models.CASCADE)
    level = models.PositiveSmallIntegerField('уровень (1–10)', default=1)

    class Meta:
        unique_together = ('employee', 'skill')

    def clean(self):
        if not (1 <= self.level <= 10):
            raise ValidationError({'level': 'Уровень должен быть от 1 до 10.'})

    def save(self, *args, **kwargs):
        if not (1 <= self.level <= 10):
            raise ValueError("Уровень должен быть от 1 до 10.")
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.employee} — {self.skill}: {self.level}"
MODELS_EMP

cat > workplaces/models.py << 'MODELS_WP'
from django.db import models
from employees.models import EmployeeProfile

class Workplace(models.Model):
    desk_number = models.CharField('номер стола', max_length=20, unique=True)
    extra_info = models.TextField('доп. информация', blank=True, null=True)
    employee = models.OneToOneField(
        EmployeeProfile,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='workplace',
        verbose_name='сотрудник'
    )

    def __str__(self):
        return f"Стол {self.desk_number}"
MODELS_WP

# ================= 4. Пишем admin.py =================
cat > employees/admin.py << 'ADMIN_EMP'
from django.contrib import admin
from .models import Skill, EmployeeProfile, EmployeeSkillLevel

class EmployeeSkillLevelInline(admin.TabularInline):
    model = EmployeeSkillLevel
    extra = 1

@admin.register(EmployeeProfile)
class EmployeeProfileAdmin(admin.ModelAdmin):
    list_display = ('last_name', 'first_name', 'gender')
    search_fields = ('last_name', 'first_name')
    inlines = [EmployeeSkillLevelInline]

admin.site.register(Skill)
ADMIN_EMP

cat > workplaces/admin.py << 'ADMIN_WP'
from django.contrib import admin
from .models import Workplace

@admin.register(Workplace)
class WorkplaceAdmin(admin.ModelAdmin):
    list_display = ('desk_number', 'employee')
    search_fields = ('desk_number',)
ADMIN_WP

# ================= 5. Миграции и суперпользователь =================
echo "🗃️ Делаем миграции..."
python manage.py makemigrations
python manage.py migrate

echo "👮 Создаём суперпользователя (будет запрос в консоли)..."
python manage.py createsuperuser

# ================= 6. Коммит изменений =================
echo "💾 Делаем коммит..."
git add employees/apps.py employees/models.py employees/admin.py \
           workplaces/apps.py workplaces/models.py workplaces/admin.py \
           "$SETTINGS_FILE"
git commit -m "feat: enhance employees/workplaces with models, admin, and 1:1 relation"

echo "🎉 Готово. Запускай: python manage.py runserver"
