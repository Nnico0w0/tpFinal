from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import AllowAny
from django.contrib.auth.models import User
from .serializers import UserSerializer


class UserListView(APIView):
    """Public API to list all users with their basic information"""
    permission_classes = [AllowAny]
    
    def get(self, request, format=None):
        users = User.objects.filter(is_active=True).select_related('profile', 'profile__person')
        serializer = UserSerializer(users, many=True)
        return Response(serializer.data)
