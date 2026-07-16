from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from .models import UserProfile
from .serializers import UserProfileSerializer

class ProfileSyncView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        email = user.email
        uid = user.username  
        full_name = request.data.get('full_name', '')

        
        try:
            profile = UserProfile.objects.get(firebase_uid=uid)
            created = False
        except UserProfile.DoesNotExist:
            
            try:
                existing_profile = UserProfile.objects.get(email=email)
               
                existing_profile.delete()
            except UserProfile.DoesNotExist:
                pass
            
            profile = UserProfile.objects.create(
                firebase_uid=uid,
                email=email,
                full_name=full_name
            )
            created = True

        if not created and full_name and profile.full_name != full_name:
            profile.full_name = full_name
            profile.save()

        serializer = UserProfileSerializer(profile)
        return Response({
            'profile': serializer.data,
            'synced': True,
            'created': created
        }, status=status.HTTP_201_CREATED if created else status.HTTP_200_OK)


class ProfileDetailView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        try:
            profile = UserProfile.objects.get(firebase_uid=user.username)
            serializer = UserProfileSerializer(profile)
            return Response(serializer.data)
        except UserProfile.DoesNotExist:
            return Response({'error': 'Profile not found'}, status=status.HTTP_404_NOT_FOUND)

    def patch(self, request):
        user = request.user
        try:
            profile = UserProfile.objects.get(firebase_uid=user.username)
            serializer = UserProfileSerializer(profile, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except UserProfile.DoesNotExist:
            return Response({'error': 'Profile not found'}, status=status.HTTP_404_NOT_FOUND)
