from django.contrib import admin
from .models import EmployeeProfile, Skill, EmployeeSkillLevel

class EmployeeSkillInline(admin.TabularInline):
    model = EmployeeSkillLevel
    extra = 1  # сколько пустых строк показывать сразу

@admin.register(EmployeeProfile)
class EmployeeProfileAdmin(admin.ModelAdmin):
    list_display = ('first_name', 'last_name', 'middle_name', 'gender', 'get_desk_number')
    search_fields = ('first_name', 'last_name', 'user__username')
    inlines = [EmployeeSkillInline]  # <-- вот это делает навыки видимыми на странице профиля

    def get_desk_number(self, obj):
        if obj.workplace:
            return obj.workplace.desk_number
        return '-'
    get_desk_number.short_description = 'Стол'

@admin.register(Skill)
class SkillAdmin(admin.ModelAdmin):
    list_display = ('name',)

@admin.register(EmployeeSkillLevel)
class EmployeeSkillLevelAdmin(admin.ModelAdmin):
    list_display = ('employee', 'skill', 'level')
    list_filter = ('skill',)
