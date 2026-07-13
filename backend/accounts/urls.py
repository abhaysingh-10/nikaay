from django.urls import path
from .views import ProfileSyncView, ProfileDetailView

urlpatterns = [
    path('auth/sync/', ProfileSyncView.as_view(), name='profile-sync'),
    path('profile/', ProfileDetailView.as_view(), name='profile-detail'),
]
