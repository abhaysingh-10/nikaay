from ..models import Assessment
from .gemini_service import GeminiService

class AssessmentService:
    @staticmethod
    def process_and_save_assessment(user, answers):
        result = GeminiService.analyze_skin(answers)
        
        assessment = Assessment.objects.create(
            user=user,
            answers=answers,
            result=result
        )
        
        return assessment
