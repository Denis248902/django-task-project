from django.db import models
from django.core.validators import MinValueValidator, MaxValueValidator
from django.contrib.auth.models import User

class Skill(models.Model):
    name = models.CharField('навык', max_length=50, unique=True)

    def __str__(self):
        return self.name


class EmployeeProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, verbose_name='пользователь')
    first_name = models.CharField('имя', max_length=30)
    last_name = models.CharField('фамилия', max_length=30)
    middle_name = models.CharField('отчество', max_length=30, blank=True, null=True)
    # ВАЖНО: добавили default='M', чтобы старые записи не были NULL
    gender = models.CharField(
        'пол', 
        max_length=1, 
        choices=[('M', 'Мужской'), ('F', 'Женский')], 
        default='M'
    )
    description = models.TextField('описание', blank=True, null=True)

    def __str__(self):
        return f"{self.first_name} {self.middle_name or ''} {self.last_name}".strip()


class EmployeeSkillLevel(models.Model):
    employee = models.ForeignKey(EmployeeProfile, on_delete=models.CASCADE, related_name='skills_levels')
    skill = models.ForeignKey(Skill, on_delete=models.CASCADE)
    level = models.PositiveSmallIntegerField(
        'уровень',
        validators=[MinValueValidator(1), MaxValueValidator(10)]
    )

    class Meta:
        unique_together = ('employee', 'skill')

    def __str__(self):
        return f"{self.employee} — {self.skill}: {self.level}"
