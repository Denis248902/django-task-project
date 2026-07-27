from django.db import models

class Skill(models.Model):
    name = models.CharField(max_length=100)

    def __str__(self):
        return self.name


class EmployeeProfile(models.Model):
    full_name = models.CharField(max_length=200)
    gender = models.CharField(
        max_length=1,
        choices=[('M', 'Мужской'), ('F', 'Женский')],
        default='M'
    )
    position = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return self.full_name


class EmployeeSkill(models.Model):
    employee = models.ForeignKey(EmployeeProfile, related_name='skills', on_delete=models.CASCADE)
    skill = models.ForeignKey(Skill, on_delete=models.CASCADE)
    level = models.PositiveIntegerField(default=1, help_text="Уровень освоения (1–5)")

    class Meta:
        unique_together = ('employee', 'skill')

    def __str__(self):
        return f"{self.employee.full_name} — {self.skill.name} (уровень {self.level})"
