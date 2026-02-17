from rest_framework import serializers

from .models import Order, OrderItem, Subscription
from products.serializers import ProductSerializer


class SubscriptionSerializer(serializers.ModelSerializer):
    product_name = serializers.CharField(source='order_item.product.name', read_only=True)
    
    class Meta:
        model = Subscription
        fields = (
            'id',
            'product_name',
            'start_date',
            'end_date',
            'status',
            'domain_name',
        )


class MyOrderItemSerializer(serializers.ModelSerializer):
    product = ProductSerializer()
    subscription = SubscriptionSerializer(read_only=True)
    
    class Meta:
        model = OrderItem
        fields = (
            'price',
            'product',
            'quantity',
            'billing_cycle_months',
            'subscription',
        )

class MyOrderSerializer(serializers.ModelSerializer):

    items = MyOrderItemSerializer(many=True)

    class Meta:
        model = Order
        fields = (
            'id',
            'first_name',
            'last_name',
            'email',
            'address',
            'zipcode',
            'place',
            'phone',
            'stripe_token',
            'items',
            'paid_amount',
            'status',
            'created_at',
        )

    def create(self, validated_data):
        """ override create method """
        items_data = validated_data.pop('items') # remove items from validated_data
        # order create 
        order = Order.objects.create(**validated_data)

        # order_item save 
        for item_data in items_data:
            OrderItem.objects.create(order=order, **item_data)
        
        return order


class OrderItemSerializer(serializers.ModelSerializer):

    class Meta:
        model = OrderItem
        fields = (
            'price',
            'product',
            'quantity',
            'billing_cycle_months',
        )


class OrderSerializer(serializers.ModelSerializer):

    items = OrderItemSerializer(many=True)

    class Meta:
        model = Order
        fields = (
            'id',
            'first_name',
            'last_name',
            'email',
            'address',
            'zipcode',
            'place',
            'phone',
            'stripe_token',
            'items',
        )

    def create(self, validated_data):
        """ override create method """
        items_data = validated_data.pop('items') # remove items from validated_data
        # order create 
        order = Order.objects.create(**validated_data)

        # order_item save 
        for item_data in items_data:
            OrderItem.objects.create(order=order, **item_data)
        
        return order