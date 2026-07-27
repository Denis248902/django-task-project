from django.contrib import admin
from .models import Employee, EmployeeImage, Skill, EmployeeSkill

class EmployeeImageInline(admin.TabularInline):
    model = EmployeeImage
    extra = 1
    fields = ('image', 'order')

class EmployeeSkillInline(admin.TabularInline):
    model = EmployeeSkill
    extra = 1
    autocomplete_fields = ('skill',)

@admin.register(Employee)
class EmployeeAdmin(admin.ModelAdmin):
    list_display = ('user', 'gender', 'last_name', 'first_name')
    list_filter = ('gender',)
    search_fields = ('user__username', 'last_name', 'first_name')
    inlines = [EmployeeImageInline, EmployeeSkillInline]

@admin.register(Skill)
class SkillAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name',)
