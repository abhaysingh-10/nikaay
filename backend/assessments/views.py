from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.throttling import ScopedRateThrottle
from .models import Assessment
from .serializers import AssessmentSerializer, AssessmentInputSerializer
from .services.assessment_service import AssessmentService

class AssessmentHourlyThrottle(ScopedRateThrottle):
    scope = 'assessment_hourly'

class AssessmentDailyThrottle(ScopedRateThrottle):
    scope = 'assessment_daily'

class AssessmentSubmitView(APIView):
    throttle_classes = [AssessmentHourlyThrottle, AssessmentDailyThrottle]

    def post(self, request):
        serializer = AssessmentInputSerializer(data=request.data)
        if not serializer.is_valid():
            return Response(
                {"error": "Invalid assessment payload", "details": serializer.errors},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        assessment = AssessmentService.process_and_save_assessment(
            user=request.user,
            answers=serializer.validated_data
        )
        
        output_serializer = AssessmentSerializer(assessment)
        return Response(output_serializer.data, status=status.HTTP_201_CREATED)

    def get(self, request):
        assessments = Assessment.objects.filter(user=request.user).order_by('-created_at')
        serializer = AssessmentSerializer(assessments, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
