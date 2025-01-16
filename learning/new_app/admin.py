from django.contrib import admin
from .models import Musician,Album,MusicCompany,State

class AlbumInline(admin.TabularInline):
    model = Album
    extra = 4  

class MusicianAdmin(admin.ModelAdmin):
    list_display = ("first_name", "last_name", "instrument")
    inlines = [AlbumInline]

class MusicCompanyAdmin(admin.ModelAdmin):
    list_display = ("name", "created_at")

class StateAdmin(admin.ModelAdmin):
    list_display = ('state', 'state_name')

# Register your models here.
admin.site.register(Musician,MusicianAdmin)
admin.site.register(MusicCompany,MusicCompanyAdmin)
admin.site.register(State,StateAdmin)
