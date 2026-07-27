import os
from django.db import models
from django.conf import settings
from django.core.files.storage import default_storage
from django.contrib.auth.models import User


class EmployeeProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    middle_name = models.CharField(max_length=50, blank=True, null=True)
    gender = models.CharField(
        max_length=1,
        choices=[('M', 'Мужской'), ('F', 'Женский')],
        blank=True,
        null=True
    )
    description = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"


class Skill(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class EmployeeSkillLevel(models.Model):
    employee = models.ForeignKey(EmployeeProfile, on_delete=models.CASCADE, related_name='employee_skill_levels')
    skill = models.ForeignKey(Skill, on_delete=models.CASCADE)
    level = models.PositiveSmallIntegerField()

    class Meta:
        unique_together = ('employee', 'skill')

    def __str__(self):
        return f"{self.employee} — {self.skill}: {self.level}"


class EmployeeImage(models.Model):
    employee = models.ForeignKey(EmployeeProfile, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to='employee_photos/')
    order = models.PositiveIntegerField(default=0, help_text="Порядок отображения")

    class Meta:
        ordering = ['order']

    def delete(self, *args, **kwargs):
        if self.image:
            if default_storage.exists(self.image.name):
                default_storage.delete(self.image.name)
        super().delete(*args, **kwargs)

    def __str__(self):
        return f"Фото {self.order} для {self.employee}"
