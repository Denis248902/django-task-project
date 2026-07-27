from django.db import models
from django.conf import settings
from django.db.models.signals import pre_delete
from django.dispatch import receiver

GENDER_CHOICES = [
    ('M', 'Мужской'),
    ('F', 'Женский'),
    ('O', 'Другой'),
]

class Skill(models.Model):
    name = models.CharField('Название навыка', max_length=100, unique=True)

    class Meta:
        verbose_name = 'Навык'
        verbose_name_plural = 'Навыки'

    def __str__(self):
        return self.name


class EmployeeSkill(models.Model):
    employee = models.ForeignKey('Employee', on_delete=models.CASCADE, related_name='employee_skills')
    skill = models.ForeignKey(Skill, on_delete=models.CASCADE, related_name='employee_skills')
    level = models.PositiveSmallIntegerField('Уровень освоения', default=1)
    description = models.TextField('Описание', blank=True)

    class Meta:
        verbose_name = 'Навык сотрудника'
        verbose_name_plural = 'Навыки сотрудников'
        unique_together = ('employee', 'skill')

    def __str__(self):
        return f'{self.employee} — {self.skill} (уровень {self.level})'


class Employee(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='profile')
    gender = models.CharField('Пол', max_length=1, choices=GENDER_CHOICES, blank=True)
    first_name = models.CharField('Имя', max_length=150, blank=True)
    last_name = models.CharField('Фамилия', max_length=150, blank=True)
    middle_name = models.CharField('Отчество', max_length=150, blank=True)

    class Meta:
        verbose_name = 'Сотрудник'
        verbose_name_plural = 'Сотрудники'

    def __str__(self):
        return f'{self.last_name} {self.first_name}'.strip()


class EmployeeImage(models.Model):
    employee = models.ForeignKey(Employee, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField('Изображение', upload_to='employee_images/')
    order = models.PositiveIntegerField('Порядок', default=0)

    class Meta:
        ordering = ['order']
        verbose_name = 'Изображение сотрудника'
        verbose_name_plural = 'Изображения сотрудников'

    def __str__(self):
        return f"Фото {self.order} для {self.employee}"


@receiver(pre_delete, sender=EmployeeImage)
def delete_image_file(sender, instance, **kwargs):
    if instance.image:
        instance.image.delete(save=False)
