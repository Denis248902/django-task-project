from django.urls import path
from . import views

urlpatterns = [
    path('', views.employee_list, name='employee_list'),
    path('<int:pk>/', views.employee_detail, name='employee_detail'),
    path('<int:pk>/upload-photo/', views.employee_upload_photo, name='employee_upload_photo'),
    path('export-csv/', views.export_employees_csv, name='export_employees_csv'),
    path('stats/', views.employee_stats, name='employee_stats'),
    path('report/', views.employee_report, name='employee_report'),
]
