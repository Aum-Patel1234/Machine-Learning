from django.db import models
from django.utils import timezone

# Create your models here.
class NewAppMode(models.Model):
    CHOICES = [('ML','Machine Learning'), ('AD','Android Development')]

    name = models.CharField(max_length=50)
    image = models.ImageField(upload_to="imgs/")
    created_at = models.DateTimeField(default=timezone.now)
    type = models.CharField(max_length=2, choices=CHOICES)
    
