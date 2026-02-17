from django.db.models import Q, Sum, Count
from django.http import Http404

from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view

from .models import Product, Category
from .serializers import ProductSerializer, CategorySerializer


class TopSellingProductsList(APIView):
    """Return top 3 best-selling products"""
    
    def get(self, request, format=None):
        # Get products with their total sales count
        # 'items' is the related_name from OrderItem to Product
        top_products = Product.objects.annotate(
            total_sales=Count('items')
        ).filter(
            total_sales__gt=0
        ).order_by('-total_sales')[:3]
        
        # If we don't have enough products with sales, fill with latest products
        if top_products.count() < 3:
            latest = Product.objects.exclude(
                id__in=[p.id for p in top_products]
            ).order_by('-date_added')[:3-top_products.count()]
            top_products = list(top_products) + list(latest)
        
        serializer = ProductSerializer(top_products, many=True)
        return Response(serializer.data)

class LatestProductsList(APIView):

    def get(self, request, fromat=None):
        products = Product.objects.all()[0:4]
        serialize = ProductSerializer(products, many=True)
        return Response(serialize.data) 


class AllProductsList(APIView):
    """Return all products from database"""
    
    def get(self, request, format=None):
        products = Product.objects.all()
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data)


class CategoriesList(APIView):
    """Return all categories"""
    
    def get(self, request, format=None):
        categories = Category.objects.all()
        # Return just id, name and slug for categories list
        data = [{'id': cat.id, 'name': cat.name, 'slug': cat.slug} for cat in categories]
        return Response(data)


class ProductDetail(APIView):

    def get_object(self, category_slug, product_slug):
        try:
            return Product.objects.filter(
                category__slug=category_slug).get(slug=product_slug)
        except Product.DoesNotExist:
            return Http404

    def get(self, request, category_slug, product_slug, fromat=None):
        product = self.get_object(category_slug, product_slug)
        serialize = ProductSerializer(product)
        return Response(serialize.data)


class CategoryDetailView(APIView):

    def get_object(self, category_slug):
        try:
            return Category.objects.get(slug=category_slug)
        except Category.DoesNotExist:
            return Http404

    def get(self, request, category_slug, fromat=None):
        category = self.get_object(category_slug)
        serialize = CategorySerializer(category)
        return Response(serialize.data)


@api_view(['POST'])
def search_api(request):
    query = request.data.get('query', '')
    if query:
        products = Product.objects.filter(
            Q(name__icontains=query) | Q(description__icontains=query)
        )
        serializer = ProductSerializer(products, many=True)
        return Response(serializer.data)
    else:
        return Response({'products': []})
