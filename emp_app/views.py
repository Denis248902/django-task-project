from django.shortcuts import render, get_object_or_404
from django.contrib.auth.decorators import login_required
from .models import EmployeeProfile

def home(request):
    profiles = EmployeeProfile.objects.all()
    return render(request, 'emp_app/home.html', {'profiles': profiles})

def employee_list(request):
    profiles = EmployeeProfile.objects.all()
    return render(request, 'emp_app/employee_list.html', {'profiles': profiles})

@login_required
def employee_detail(request, pk):
    profile = get_object_or_404(EmployeeProfile, pk=pk)
    return render(request, 'emp_app/employee_detail.html', {'profile': profile})

