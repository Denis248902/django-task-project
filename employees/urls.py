from django.urls import path
from . import views

urlpatterns = [
    path('', views.home_view, name='home'),
    path('list/', views.employee_list_view, name='employee_list'),
    path('<int:pk>/', views.employee_detail_view, name='employee_detail'),
]
