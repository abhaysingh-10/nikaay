import os
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.parsers import MultiPartParser, FormParser
from .models import Report
from .serializers import ReportUploadSerializer

class ReportUploadView(APIView):
    parser_classes = (MultiPartParser, FormParser)

    def post(self, request, *args, **kwargs):
        serializer = ReportUploadSerializer(data=request.data)
        if serializer.is_valid():
            uploaded_file = request.FILES.get('file')
            if not uploaded_file:
                return Response(
                    {"error": "No file uploaded."},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Extract metadata
            filename = uploaded_file.name
            file_size = uploaded_file.size
            file_type = os.path.splitext(filename)[1].lower().replace('.', '')

            # Saving model with user and extracted metadata
            serializer.save(
                user=request.user,
                filename=filename,
                file_size=file_size,
                file_type=file_type
            )
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def get(self, request, *args, **kwargs):
        reports = Report.objects.filter(user=request.user).order_by('-uploaded_at')
        serializer = ReportUploadSerializer(reports, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class ReportDetailView(APIView):
    def delete(self, request, pk, *args, **kwargs):
        try:
            report = Report.objects.get(pk=pk, user=request.user)
            if report.file:
                report.file.delete(save=False)
            report.delete()
            return Response(
                {"message": "Report deleted successfully."}, 
                status=status.HTTP_204_NO_CONTENT
            )
        except Report.DoesNotExist:
            return Response(
                {"error": "Report not found."}, 
                status=status.HTTP_404_NOT_FOUND
            )
