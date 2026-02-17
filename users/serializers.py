from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Person, UserProfile


class PersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = ('id', 'first_name', 'last_name', 'email', 'phone')


class UserSerializer(serializers.ModelSerializer):
    person = PersonSerializer(source='profile.person', read_only=True)
    role = serializers.CharField(source='profile.role', read_only=True)
    
    class Meta:
        model = User
        fields = ('id', 'username', 'person', 'role', 'date_joined')
