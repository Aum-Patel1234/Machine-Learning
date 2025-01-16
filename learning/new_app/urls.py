from django.urls import path
from . import views

# this will be the url - http://127.0.0.1:8000/new_app/

urlpatterns = [
    path('',views.newFunc, name='new_app'),        
    path('musician/',views.getObj, name='newApp_item'),        
    path('form/',views.form, name='form'),        
]