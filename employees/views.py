from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from .models import Employee

def home(request):
    employees = Employee.objects.select_related('user').prefetch_related('employee_skills__skill')[:6]
    return render(request, 'home.html', {'employees': employees})

def employee_list(request):
    employees = Employee.objects.select_related('user').prefetch_related('employee_skills__skill').all()
    return render(request, 'employee_list.html', {'employees': employees})

@login_required
def employee_detail(request, pk):
    employee = get_object_or_404(
        Employee.objects.select_related('user').prefetch_related('employee_skills__skill', 'images'), 
        pk=pk
    )
    return render(request, 'employee_detail.html', {'employee': employee})
