from django.contrib import admin
from .models import Order, OrderItem, Subscription


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 0


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = ['id', 'user', 'first_name', 'last_name', 'status', 'paid_amount', 'created_at']
    list_filter = ['status', 'created_at']
    search_fields = ['first_name', 'last_name', 'email', 'user__username']
    inlines = [OrderItemInline]


@admin.register(OrderItem)
class OrderItemAdmin(admin.ModelAdmin):
    list_display = ['id', 'order', 'product', 'price', 'quantity', 'billing_cycle_months']
    list_filter = ['billing_cycle_months']
    search_fields = ['order__id', 'product__name']


@admin.register(Subscription)
class SubscriptionAdmin(admin.ModelAdmin):
    list_display = ['id', 'order_item', 'status', 'start_date', 'end_date', 'domain_name']
    list_filter = ['status', 'start_date', 'end_date']
    search_fields = ['order_item__product__name', 'domain_name']
