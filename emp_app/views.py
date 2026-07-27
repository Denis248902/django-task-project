import csv
from io import StringIO
from django.http import HttpResponse
from django.shortcuts import render, get_object_or_404, redirect
from django.contrib import messages
from .models import EmployeeProfile, EmployeeImage
from django.core.paginator import Paginator
from django.db.models import Q
from django.views.decorators.cache import cache_page

@cache_page(60)
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

def employee_upload_photo(request, pk):
    if request.method != 'POST':
        return redirect('employee_detail', pk=pk)

    employee = get_object_or_404(EmployeeProfile, pk=pk)
    image_file = request.FILES.get('image')

    if not image_file:
        messages.error(request, "Файл не выбран.")
        return redirect('employee_detail', pk=pk)

    allowed_types = ['image/jpeg', 'image/png', 'image/gif']
    if image_file.content_type not in allowed_types:
        messages.error(request, "Ошибка: разрешены только JPG, PNG, GIF.")
        return redirect('employee_detail', pk=pk)

    max_size_bytes = 5 * 1024 * 1024
    if image_file.size > max_size_bytes:
        messages.error(request, f"Ошибка: файл слишком большой. Максимум 5 МБ.")
        return redirect('employee_detail', pk=pk)

    order_index = request.POST.get('order_index', 0)
    try:
        order_index = int(order_index) if order_index.isdigit() else 0
    except ValueError:
        order_index = 0

    EmployeeImage.objects.create(
        employee=employee,
        image=image_file,
        order_index=order_index
    )
    messages.success(request, "Фото успешно загружено!")
    return redirect('employee_detail', pk=pk)

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
