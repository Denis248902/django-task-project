from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_delete
from django.dispatch import receiver

class Skill(models.Model):
    name = models.CharField(max_length=100, unique=True)

    def __str__(self):
        return self.name


class EmployeeProfile(models.Model):
    GENDER_CHOICES = [('M', 'Мужской'), ('F', 'Женский')]

    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    middle_name = models.CharField(max_length=50, blank=True, null=True)
    gender = models.CharField(max_length=1, choices=GENDER_CHOICES, blank=True, null=True)
    description = models.TextField(blank=True, null=True)

    skills = models.ManyToManyField(Skill, through='EmployeeSkill')

    def __str__(self):
        return f"{self.first_name} {self.last_name}"


class EmployeeSkill(models.Model):
    employee = models.ForeignKey(EmployeeProfile, on_delete=models.CASCADE)
    skill = models.ForeignKey(Skill, on_delete=models.CASCADE)
    level = models.IntegerField(default=1, help_text="1–10")

    class Meta:
        unique_together = ('employee', 'skill')


class EmployeeImage(models.Model):
    employee = models.ForeignKey(EmployeeProfile, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to='employee_images/')
    order_index = models.PositiveIntegerField(default=0)

    class Meta:
        ordering = ['order_index']


@receiver(post_delete, sender=EmployeeImage)
def delete_image_file(sender, instance, **kwargs):
    if instance.image:
        instance.image.delete(save=False)
