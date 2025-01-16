from django import forms
from .models import Musician

class Form(forms.Form):
    name = forms.CharField(initial="class")
    musicians = forms.ModelChoiceField(queryset=Musician.objects.all())
    
    