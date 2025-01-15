from django.shortcuts import render

def newFunc(request):
    return render(request,'new_app/new.html')