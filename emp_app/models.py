from django.db import models
from django.conf import settings

class EmployeeProfile(models.Model):
    GENDER_CHOICES = [('M', 'Мужской'), ('F', 'Женский')]
    full_name = models.CharField(max_length=255)
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES)
    position = models.CharField(max_length=255)

    def __str__(self):
        return self.full_name


class EmployeeImage(models.Model):
    employee = models.ForeignKey(
        EmployeeProfile,
        on_delete=models.CASCADE,
        related_name='images'
    )
    image = models.ImageField(upload_to='employee_images/', blank=True, null=True)
    order_index = models.PositiveIntegerField(default=0)

    class Meta:
        ordering = ['order_index']

    def __str__(self):
        return f"{self.employee.full_name} — фото #{self.order_index}"
