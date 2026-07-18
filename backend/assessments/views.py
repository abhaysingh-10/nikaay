from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Assessment
from .serializers import AssessmentSerializer
from .services.assessment_service import AssessmentService

class AssessmentSubmitView(APIView):
    def post(self, request):
        answers = request.data
        if not answers:
            return Response(
                {"error": "Answers are required"},
                status=status.HTTP_400_BAD_REQUEST
            )
        
        assessment = AssessmentService.process_and_save_assessment(
            user=request.user,
            answers=answers
        )
        
        serializer = AssessmentSerializer(assessment)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

    def get(self, request):
        assessments = Assessment.objects.filter(user=request.user).order_by('-created_at')
        serializer = AssessmentSerializer(assessments, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
