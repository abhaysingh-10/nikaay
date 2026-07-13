from rest_framework import serializers
from .models import UserProfile

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ['id', 'firebase_uid', 'email', 'full_name', 'profile_image', 'created_at', 'updated_at']
        read_only_fields = ['id', 'firebase_uid', 'email', 'created_at', 'updated_at']
