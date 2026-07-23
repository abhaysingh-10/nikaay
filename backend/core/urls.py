
from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/', include('accounts.urls')),
    path('api/v1/assessments/', include('assessments.urls')),
    path('api/v1/chat/', include('chat.urls')),
]
