from django.contrib import admin
from .models import EmployeeProfile, Skill, EmployeeSkill, EmployeeImage

class EmployeeImageInline(admin.TabularInline):
    model = EmployeeImage
    extra = 1
    fields = ['image', 'order_index']
    ordering = ['order_index']

@admin.register(EmployeeProfile)
class EmployeeProfileAdmin(admin.ModelAdmin):
    list_display = ['full_name', 'position', 'gender']
    inlines = [EmployeeImageInline]

admin.site.register(Skill)
admin.site.register(EmployeeSkill)
