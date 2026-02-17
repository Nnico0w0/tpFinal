from django.urls import path, include
from rest_framework.routers import DefaultRouter
from orders import views

router = DefaultRouter()
router.register(r'all', views.OrderListViewSet, basename='order')

urlpatterns = [
    path('checkout/', views.checkout, name='checkout'),
    path('list/', views.OrderListApi.as_view(), name='order_list'),
    path('subscriptions/', views.SubscriptionListApi.as_view(), name='subscription_list'),
    path('', include(router.urls)),
]