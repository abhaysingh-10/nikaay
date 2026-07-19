from rest_framework import serializers
from .models import Assessment

SKIN_TYPE_CHOICES = ['Normal', 'Dry', 'Oily', 'Combination', 'Sensitive']
SENSITIVITY_CHOICES = ['Tolerant', 'Slightly Sensitive', 'Very Sensitive']
CONCERN_CHOICES = ['Acne', 'Aging', 'Hyperpigmentation', 'Dryness', 'Redness', 'None']

class AssessmentInputSerializer(serializers.Serializer):
    skin_type = serializers.ChoiceField(choices=SKIN_TYPE_CHOICES)
    sensitivity = serializers.ChoiceField(choices=SENSITIVITY_CHOICES)
    concern = serializers.ChoiceField(choices=CONCERN_CHOICES)
    sun_exposure = serializers.CharField(max_length=50, required=False, default='Medium')
    habit = serializers.CharField(max_length=50, required=False, default='Sometimes')

class AssessmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Assessment
        fields = ['id', 'user', 'answers', 'result', 'created_at']
        read_only_fields = ['id', 'user', 'result', 'created_at']
