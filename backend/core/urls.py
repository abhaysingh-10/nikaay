
from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static


urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/v1/', include('accounts.urls')),
    path('api/v1/assessments/', include('assessments.urls')),
    path('api/v1/chat/', include('chat.urls')),
    path('api/v1/reports/', include('reports.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    
