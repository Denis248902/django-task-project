from django.contrib import admin
from .models import EmployeeProfile, EmployeeImage, Skill, EmployeeSkillLevel


@admin.register(EmployeeProfile)
class EmployeeProfileAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'gender', 'user')
    search_fields = ('first_name', 'last_name')


@admin.register(EmployeeImage)
class EmployeeImageAdmin(admin.ModelAdmin):
    list_display = ('employee', 'order')
    list_filter = ('employee',)


@admin.register(Skill)
class SkillAdmin(admin.ModelAdmin):
    list_display = ('name',)
    search_fields = ('name',)


@admin.register(EmployeeSkillLevel)
class EmployeeSkillLevelAdmin(admin.ModelAdmin):
    list_display = ('employee', 'skill', 'level')
    list_filter = ('skill',)
