from django.contrib import admin
from .models import Workplace

@admin.register(Workplace)
class WorkplaceAdmin(admin.ModelAdmin):
    list_display = ('desk_number', 'extra_info', 'get_employee_full_name')
    search_fields = ('desk_number', 'employee__first_name', 'employee__last_name')

    def get_employee_full_name(self, obj):
        if obj.employee:
            emp = obj.employee
            return f"{emp.first_name} {emp.middle_name} {emp.last_name}"
        return '-'
    get_employee_full_name.short_description = 'Сотрудник'
