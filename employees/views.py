from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from .models import EmployeeProfile, EmployeeSkillLevel, EmployeeImage


def home_view(request):
    employees = EmployeeProfile.objects.all()[:6]
    return render(request, 'home.html', {'employees': employees})


def employee_list_view(request):
    employees = EmployeeProfile.objects.all()
    return render(request, 'employee_list.html', {'employees': employees})


@login_required
def employee_detail_view(request, pk):
    employee = get_object_or_404(EmployeeProfile, pk=pk)
    skills = EmployeeSkillLevel.objects.filter(employee=employee).select_related('skill')
    images = employee.images.all()  # отсортированы по order
    return render(request, 'employee_detail.html', {
        'employee': employee,
        'skills': skills,
        'images': images,
    })
