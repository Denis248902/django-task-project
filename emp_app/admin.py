from django.contrib import admin
from .models import Skill, EmployeeProfile, EmployeeSkill, EmployeeImage

@admin.register(Skill)
class SkillAdmin(admin.ModelAdmin):
    list_display = ('name',)

class EmployeeSkillInline(admin.TabularInline):
    model = EmployeeSkill
    extra = 1

class EmployeeImageInline(admin.TabularInline):
    model = EmployeeImage
    extra = 1
    fields = ('image', 'order_index')

@admin.register(EmployeeProfile)
class EmployeeProfileAdmin(admin.ModelAdmin):
    # ВАЖНО: используем только реально существующие поля модели
    list_display = ('full_name', 'gender', 'position')
    inlines = [EmployeeSkillInline, EmployeeImageInline]
    search_fields = ('full_name',)

@admin.register(EmployeeSkill)
class EmployeeSkillAdmin(admin.ModelAdmin):
    list_display = ('employee', 'skill', 'level')
    list_filter = ('skill',)

@admin.register(EmployeeImage)
class EmployeeImageAdmin(admin.ModelAdmin):
    list_display = ('employee', 'order_index', 'image')
    list_filter = ('employee',)
