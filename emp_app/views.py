from django.shortcuts import render, get_object_or_404
from .models import EmployeeProfile, EmployeeSkill, EmployeeImage

def employee_list(request):
    employees = EmployeeProfile.objects.all()
    return render(request, 'emp_app/employee_list.html', {
        'employees': employees,
        'page_title': 'Список сотрудников'
    })

def employee_detail(request, pk):
    employee = get_object_or_404(EmployeeProfile, pk=pk)
    skills_with_levels = employee.employeeskill_set.select_related('skill').all()
    images = employee.images.order_by('order_index')

    return render(request, 'emp_app/employee_detail.html', {
        'employee': employee,
        'skills_with_levels': skills_with_levels,
        'images': images,
        'page_title': f'Карточка: {employee.full_name}'
    })
