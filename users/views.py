from rest_framework import viewsets
from rest_framework.permissions import AllowAny
from django.contrib.auth.models import User
from .serializers import UserSerializer


class UserListViewSet(viewsets.ReadOnlyModelViewSet):
    """Public API to list all users with their basic information"""
    queryset = User.objects.filter(is_active=True).select_related('profile', 'profile__person')
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
