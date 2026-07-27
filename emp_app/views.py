from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from .models import EmployeeProfile

def home(request):
    employees = EmployeeProfile.objects.all()
    return render(request, 'emp_app/home.html', {
        'employees': employees,
        'page_title': 'Главная — Кадровый портал',
    })

def employee_list(request):
    employees = EmployeeProfile.objects.all()
    return render(request, 'emp_app/employee_list.html', {
        'employees': employees,
        'page_title': 'Список сотрудников',
    })

@login_required
def employee_detail(request, pk):
    employee = get_object_or_404(EmployeeProfile, pk=pk)
    skills_with_levels = employee.skills.select_related('skill').all()
    images = employee.images.order_by('order_index') if hasattr(employee, 'images') else []
    return render(request, 'emp_app/employee_detail.html', {
        'employee': employee,
        'skills_with_levels': skills_with_levels,
        'images': images,
        'page_title': f'{employee.full_name} — Подробная карточка',
    })
