from django.contrib import admin
from .models import Category, Product


@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug']
    prepopulated_fields = {'slug': ('name',)}
    search_fields = ['name']


@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'category', 'price', 'storage_gb', 'ram_gb', 'cpu_cores', 'date_added']
    list_filter = ['category', 'date_added']
    search_fields = ['name', 'description']
    prepopulated_fields = {'slug': ('name',)}
    fieldsets = (
        ('Basic Information', {
            'fields': ('name', 'slug', 'category', 'description', 'price')
        }),
        ('Hosting Specifications', {
            'fields': ('storage_gb', 'ram_gb', 'cpu_cores')
        }),
        ('Images', {
            'fields': ('image', 'thumbnail')
        }),
    )
