from django.db import models
from employees.models import EmployeeProfile

class Workplace(models.Model):
    desk_number = models.CharField('номер стола', max_length=20, unique=True)
    extra_info = models.TextField('доп. информация', blank=True, null=True)
    employee = models.OneToOneField(
        EmployeeProfile,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='workplace',
        verbose_name='сотрудник'
    )

    def __str__(self):
        return f"Стол {self.desk_number}"
