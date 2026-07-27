import os

SETTINGS_FILE = "core/settings.py"

with open(SETTINGS_FILE, "r", encoding="utf-8") as f:
    lines = f.readlines()

# Проверяем, есть ли уже наши приложения
if "'workplaces'" in "".join(lines) and "'employees'" in "".join(lines):
    print("✅ Приложения уже зарегистрированы в INSTALLED_APPS.")
    exit(0)

print("🛠️ Регистрируем приложения workplaces и employees в INSTALLED_APPS...")

new_lines = []
added = False

for line in lines:
    new_lines.append(line)
    # Ищем начало списка INSTALLED_APPS
    if line.strip().startswith("INSTALLED_APPS = ["):
        # Вставляем наши приложения сразу после открывающей скобки
        new_lines.append("    'workplaces',\n")
        new_lines.append("    'employees',\n")
        added = True

if not added:
    print("❌ Не удалось найти INSTALLED_APPS в settings.py. Проверь файл вручную.")
    exit(1)

with open(SETTINGS_FILE, "w", encoding="utf-8") as f:
    f.writelines(new_lines)

print("✅ Приложения успешно добавлены.")
print("")
print("Проверь результат командой:")
print("  grep -A 10 'INSTALLED_APPS' core/settings.py")
