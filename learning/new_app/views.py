from django.shortcuts import render,get_object_or_404
from .models import Musician,State
from .forms import Form

def newFunc(request):
    egs = Musician.objects.all()
    return render(request,'new_app/new.html', {'egs':egs})

def getObj(request, id):
    obj = get_object_or_404(Musician,id=id)
    return render(request,'new_app/item.html', {'eg':obj})

def form(request):
    musicians = None
    if request.method == "POST":
        form_data = Form(request.POST)
        if form_data.is_valid():
            form_data.cleaned_data['musicians']     # from the forms.py in Form class and attribute musicians
            musicians = Musician.objects.first()
    else:
        musicians = Form()      # else build form

    return render(request,'new_app/form.html', {'musician':musicians})