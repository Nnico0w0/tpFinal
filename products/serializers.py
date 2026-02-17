from rest_framework import serializers
from .models import Category, Product

class ProductSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Product
        fields = (
            'id', 
            'name',
            'category',
            'get_absolute_url',
            'description',
            'price',
            'storage_gb',
            'ram_gb',
            'cpu_cores',
            'get_image',
            'get_thumbnail'
        )

class CategorySerializer(serializers.ModelSerializer):

    products = ProductSerializer(many=True)
    class Meta:
        model = Category
        fields = ('id', 'name', 'get_absolute_url', 'products') # products related name