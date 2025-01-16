from django.db import models
from django.utils import timezone

# Create your models here.
class Musician(models.Model):
    first_name = models.CharField(max_length=50)
    last_name = models.CharField(max_length=50)
    instrument = models.CharField(max_length=100)

    def __str__(self):
        return f"{self.first_name} {self.last_name}"

# One to many relationship
class Album(models.Model):
    artist = models.ForeignKey(Musician, on_delete=models.CASCADE)
    name = models.CharField(max_length=100)
    release_date = models.DateField()
    num_stars = models.IntegerField()
    
    def __str__(self):
        return self.name
    
# Many to many relationship
class MusicCompany(models.Model):
    name = models.CharField(max_length=30)
    artists = models.ManyToManyField(Musician)
    created_at = models.DateTimeField()

    def __str__(self):
        return self.name
    
# one to one
class State(models.Model):
    state = models.OneToOneField(Musician, on_delete=models.CASCADE)
    state_name = models.CharField(max_length=50, choices=[
        ("MH", "Maharashtra"),
        ("GJ", "Gujarat"),
        ("DL", "Delhi"),
    ])

    def __str__(self):
        return self.state_name