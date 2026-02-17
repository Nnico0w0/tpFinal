from django.contrib import admin
from .models import Person, UserProfile


@admin.register(Person)
class PersonAdmin(admin.ModelAdmin):
    list_display = ['first_name', 'last_name', 'email', 'phone']
    search_fields = ['first_name', 'last_name', 'email']


@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ['user', 'person', 'role', 'is_active']
    list_filter = ['role', 'is_active']
    search_fields = ['user__username', 'person__email']
