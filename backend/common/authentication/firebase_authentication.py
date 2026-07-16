import os
import firebase_admin
from firebase_admin import auth, credentials
from django.conf import settings
from django.contrib.auth.models import User
from rest_framework import authentication
from rest_framework import exceptions

# Initialize Firebase Admin SDK (only once)
try:
    cred_path = os.environ.get('FIREBASE_CREDENTIALS_PATH')
    if cred_path:
        full_path = os.path.join(settings.BASE_DIR, cred_path)
        if os.path.exists(full_path):
            cred = credentials.Certificate(full_path)
            firebase_admin.initialize_app(cred)
        else:
            # Fallback to default configuration
            firebase_admin.initialize_app()
    else:
        firebase_admin.initialize_app()
except ValueError:
    # Firebase App already initialized
    pass


class FirebaseAuthentication(authentication.BaseAuthentication):
    def authenticate(self, request):
        auth_header = request.META.get('HTTP_AUTHORIZATION')
        if not auth_header:
            return None

        parts = auth_header.split()
        if parts[0].lower() != 'bearer':
            return None

        if len(parts) == 1:
            raise exceptions.AuthenticationFailed('Invalid token header. No credentials provided.')
        elif len(parts) > 2:
            raise exceptions.AuthenticationFailed('Invalid token header. Token string should not contain spaces.')

        token = parts[1]

        try:
            # Verify the Firebase ID Token
            decoded_token = auth.verify_id_token(token)
        except Exception as e:
            raise exceptions.AuthenticationFailed(f'Invalid Firebase Token: {str(e)}')

        uid = decoded_token.get('uid')
        email = decoded_token.get('email')

        if not uid or not email:
            raise exceptions.AuthenticationFailed('Firebase Token missing required claims (uid/email).')
        
        user, created = User.objects.get_or_create(
            username=uid,
            defaults={'email': email}
        )

        return (user, None)
