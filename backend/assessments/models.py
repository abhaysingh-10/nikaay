from django.db import models
from django.conf import settings

class Assessment(models.Model):
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='assessments'
    )
    answers = models.JSONField()
    result = models.JSONField(null=True,blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"Assessment for {self.user.email} on {self.created_at.strftime('%Y-%m-%d')}"