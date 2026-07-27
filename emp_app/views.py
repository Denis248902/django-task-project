from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from .models import EmployeeProfile, EmployeeImage

def employee_list(request):
    employees = EmployeeProfile.objects.all()
    query = request.GET.get('q', '')

    if query:
        employees = employees.filter(
            full_name__icontains=query
        ) | employees.filter(
            position__icontains=query
        )

    return render(request, 'emp_app/employee_list.html', {
        'employees': employees,
        'page_title': 'Список сотрудников',
        'query': query,
    })

@login_required(login_url='login')
def employee_detail(request, pk):
    employee = get_object_or_404(EmployeeProfile, pk=pk)
    # Используем правильное имя связи: skills (из related_name в модели)
    skills_with_levels = employee.skills.select_related('skill').all()
    images = employee.images.order_by('order_index')

    return render(request, 'emp_app/employee_detail.html', {
        'employee': employee,
        'skills_with_levels': skills_with_levels,
        'images': images,
        'page_title': f'Карточка: {employee.full_name}',
    })
from django.shortcuts import render, get_object_or_404
from .models import EmployeeProfile, EmployeeImage

def employee_list(request):
    employees = EmployeeProfile.objects.all()
    return render(request, 'emp_app/employee_list.html', {'employees': employees})

def employee_detail(request, pk):
    employee = get_object_or_404(EmployeeProfile, pk=pk)
    images = EmployeeImage.objects.filter(employee=employee).order_by('order_index')
    return render(request, 'emp_app/employee_detail.html', {
        'employee': employee,
        'images': images,
    })
