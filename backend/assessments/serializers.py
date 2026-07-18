from rest_framework import serializers
from .models import Assessment

class AssessmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Assessment
        fields = ['id', 'user', 'answers', 'result', 'created_at']
        read_only_fields = ['id', 'user', 'result', 'created_at']
