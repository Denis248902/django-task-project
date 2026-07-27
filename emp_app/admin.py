from django.contrib import admin
from .models import Skill, EmployeeProfile, EmployeeSkill, EmployeeImage

class EmployeeSkillInline(admin.TabularInline):
    model = EmployeeSkill
    extra = 1

class EmployeeImageInline(admin.StackedInline):
    model = EmployeeImage
    extra = 1

@admin.register(EmployeeProfile)
class EmployeeProfileAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'gender')
    inlines = [EmployeeSkillInline, EmployeeImageInline]

admin.site.register(Skill)
