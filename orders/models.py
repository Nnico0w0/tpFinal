from django.db import models
from django.contrib.auth.models import User

from products.models import Product


class Order(models.Model):
    STATUS_CHOICES = [
        ('PENDING', 'Pending'),
        ('COMPLETED', 'Completed'),
        ('CANCELLED', 'Cancelled'),
    ]
    
    user = models.ForeignKey(User, related_name='orders', on_delete=models.CASCADE)
    first_name = models.CharField(max_length=100)
    last_name = models.CharField(max_length=100)
    email = models.EmailField(max_length=100)
    address = models.TextField(max_length=100)
    zipcode = models.CharField(max_length=20)
    phone = models.CharField(max_length=100)
    place = models.CharField(max_length=100, null=True, blank=True)
    paid_amount = models.DecimalField(max_digits=8, decimal_places=2, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    stripe_token = models.CharField(max_length=100, blank=True, null=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='PENDING')

    class Meta:
        ordering = ('-created_at',)

    def __str__(self):
        return f'{self.first_name} {self.last_name} - {self.status}'

class OrderItem(models.Model):
    order = models.ForeignKey(Order, related_name='items', on_delete=models.CASCADE)
    product = models.ForeignKey(Product, related_name='items', on_delete=models.CASCADE)
    price = models.DecimalField(max_digits=8, decimal_places=2)
    quantity = models.IntegerField(default=1)
    billing_cycle_months = models.IntegerField(default=1, help_text='Billing cycle in months')

    def __str__(self):
        return f'{self.order} - {self.product}'


class Subscription(models.Model):
    STATUS_CHOICES = [
        ('ACTIVE', 'Active'),
        ('EXPIRED', 'Expired'),
        ('SUSPENDED', 'Suspended'),
    ]
    
    order_item = models.OneToOneField(OrderItem, on_delete=models.CASCADE, related_name='subscription')
    start_date = models.DateTimeField(auto_now_add=True)
    end_date = models.DateTimeField()
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='ACTIVE')
    domain_name = models.CharField(max_length=255, blank=True, null=True)

    def __str__(self):
        return f'{self.order_item.product.name} - {self.status}'

