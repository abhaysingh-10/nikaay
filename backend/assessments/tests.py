from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status
from .models import Assessment
from .services.gemini_service import GeminiService

User = get_user_model()

class AssessmentAPITests(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(
            username='testuser',
            email='testuser@example.com',
            password='testpassword123'
        )
        self.valid_payload = {
            "skin_type": "Oily",
            "sensitivity": "Tolerant",
            "concern": "Acne",
            "sun_exposure": "High",
            "habit": "Daily"
        }
        self.url = reverse('assessment-submit')

    def test_submit_assessment_unauthenticated(self):
        response = self.client.post(self.url, self.valid_payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_submit_assessment_success(self):
        self.client.force_authenticate(user=self.user)
        response = self.client.post(self.url, self.valid_payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Assessment.objects.count(), 1)
        
        assessment = Assessment.objects.first()
        self.assertEqual(assessment.user, self.user)
        self.assertEqual(assessment.answers['skin_type'], 'Oily')
        self.assertIn('is_fallback', assessment.result)

    def test_submit_assessment_invalid_choice(self):
        self.client.force_authenticate(user=self.user)
        invalid_payload = {
            "skin_type": "InvalidSkinType",
            "sensitivity": "Tolerant",
            "concern": "Acne"
        }
        response = self.client.post(self.url, invalid_payload, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('skin_type', response.data['details'])

    def test_submit_assessment_missing_required_fields(self):
        self.client.force_authenticate(user=self.user)
        response = self.client.post(self.url, {}, format='json')
        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('error', response.data)

    def test_gemini_fallback_flag(self):
        fallback_result = GeminiService._get_fallback_data(self.valid_payload)
        self.assertTrue(fallback_result['is_fallback'])
        self.assertEqual(fallback_result['predicted_skin_type'], "Oily (Tolerant)")
