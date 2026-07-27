import csv
from io import StringIO
from django.http import HttpResponse
from django.shortcuts import render, get_object_or_404
from .models import EmployeeProfile, EmployeeImage
from django.core.paginator import Paginator
from django.db.models import Q

def employee_list(request):
    query = request.GET.get('q', '')
    employees = EmployeeProfile.objects.all()

    if query:
        employees = employees.filter(
            Q(full_name__icontains=query) |
            Q(position__icontains=query)
        )

    paginator = Paginator(employees, 6)
    page_number = request.GET.get('page', 1)
    page_obj = paginator.get_page(page_number)

    return render(request, 'emp_app/employee_list.html', {
        'page_obj': page_obj,
        'query': query,
    })

def employee_detail(request, pk):
    employee = get_object_or_404(EmployeeProfile, pk=pk)
    images = employee.images.order_by('order_index')
    return render(request, 'emp_app/employee_detail.html', {
        'employee': employee,
        'images': images,
    })

def export_employees_csv(request):
    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="employees.csv"'

    writer = csv.writer(response)
    writer.writerow(['ID', 'Full Name', 'Gender', 'Position', 'Photo URLs (comma-separated)'])

    for emp in EmployeeProfile.objects.all():
        photos = ", ".join([img.image.url for img in emp.images.order_by('order_index')])
        gender_text = 'Мужской' if emp.gender == 'M' else 'Женский'
        writer.writerow([emp.id, emp.full_name, gender_text, emp.position, photos])

    return response
