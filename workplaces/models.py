from django.db import models
from employees.models import EmployeeProfile


class Workplace(models.Model):
    desk_number = models.CharField(max_length=10, unique=True)
    extra_info = models.TextField(blank=True, null=True)
    employee = models.ForeignKey(
        EmployeeProfile,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='workplaces'
    )

    def __str__(self):
        return f"Стол {self.desk_number}"
