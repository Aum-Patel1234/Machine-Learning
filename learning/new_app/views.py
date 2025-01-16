from django.shortcuts import render,get_object_or_404
from .models import NewAppMode

def newFunc(request):
    egs = NewAppMode.objects.all()
    return render(request,'new_app/new.html', {'egs':egs})

def getObj(request, id):
    obj = get_object_or_404(NewAppMode,id=id)
    return render(request,'new_app/item.html', {'eg':obj})