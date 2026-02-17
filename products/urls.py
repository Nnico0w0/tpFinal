from django.urls import path, include
from rest_framework.routers import DefaultRouter
from products import views

router = DefaultRouter()
router.register(r'all', views.ProductListViewSet, basename='product')

urlpatterns = [
    path('', include(router.urls)),
    path('latest', views.LatestProductsList.as_view()),
    path('top-selling', views.TopSellingProductsList.as_view()),
    path('categories/', views.CategoriesList.as_view()),
    path('search/', views.search_api),
    path('<slug:category_slug>/<slug:product_slug>/', views.ProductDetail.as_view()),
    path('<slug:category_slug>/', views.CategoryDetailView.as_view()),
]