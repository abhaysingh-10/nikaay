import os
from rest_framework import serializers
from .models import Report

class ReportUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = ['id', 'file', 'filename', 'file_size', 'file_type', 'uploaded_at']
        read_only_fields = ['id', 'filename', 'file_size', 'file_type', 'uploaded_at']

    def validate_file(self, value):
        # 1. Validate File Size
        max_size = 5 * 1024 * 1024
        if value.size > max_size:
            raise serializers.ValidationError("File size must not exceed 5MB.")

        # 2. Validate File Extension
        ext = os.path.splitext(value.name)[1].lower()
        valid_extensions = ['.pdf', '.zip', '.jpg', '.jpeg', '.png']
        if ext not in valid_extensions:
            raise serializers.ValidationError(
                f"Unsupported file format. Supported formats: {', '.join(valid_extensions)}"
            )

        return value
