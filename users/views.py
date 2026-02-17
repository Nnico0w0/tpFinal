from rest_framework import viewsets, mixins
from rest_framework.permissions import AllowAny
from django.contrib.auth.models import User
from .serializers import UserSerializer


class UserListViewSet(mixins.ListModelMixin, viewsets.GenericViewSet):
    """Public API to list all users with their basic information - list only"""
    queryset = User.objects.filter(is_active=True).select_related('profile', 'profile__person')
    serializer_class = UserSerializer
    permission_classes = [AllowAny]
