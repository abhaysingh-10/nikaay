from django.urls import path
from .views import ReportUploadView, ReportDetailView

urlpatterns = [
    path('upload/', ReportUploadView.as_view(), name='report-upload'),
    path('<int:pk>/', ReportDetailView.as_view(), name='report-detail'),
]
