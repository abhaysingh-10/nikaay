import os
import requests
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from assessments.models import Assessment
from .prompts.chatbot_prompt import CHATBOT_SYSTEM_PROMPT

class ChatbotView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        message = request.data.get('message', '').strip()
        if not message:
            return Response({"error": "Message is required"}, status=status.HTTP_400_BAD_REQUEST)

        history = request.data.get('history', [])

       
        latest_assessment = Assessment.objects.filter(user=request.user).order_by('-created_at').first()
        skin_context = ""
        if latest_assessment and latest_assessment.result:
            result = latest_assessment.result
            skin_type = result.get('predicted_skin_type', 'Not specified')
            explanation = result.get('explanation', '')
            recommended = ", ".join(result.get('recommended_ingredients', []))
            avoid = ", ".join(result.get('avoid_ingredients', []))
            skin_context = (
                f"\nUser Skin Profile Context:\n"
                f"- Skin Type: {skin_type}\n"
                f"- Notes: {explanation}\n"
                f"- Recommended Ingredients: {recommended}\n"
                f"- Ingredients to Avoid: {avoid}\n"
            )

       
        api_key = os.environ.get('GEMINI_API_KEY', '').strip()
        
        system_instruction = CHATBOT_SYSTEM_PROMPT
        if skin_context:
            system_instruction += f"\n{skin_context}"

        
        contents = []
        for msg in history:
            sender = msg.get('sender')
            text = msg.get('text', '').strip()
            if not text:
                continue
            role = 'user' if sender == 'user' else 'model'
            contents.append({
                "role": role,
                "parts": [{"text": text}]
            })
        
        # Append current user message
        contents.append({
            "role": "user",
            "parts": [{"text": message}]
        })

        # Fallback if GEMINI_API_KEY is missing
        if not api_key:
            return Response({
                "text": "Hello! I am your Nikaay Assistant. To get personalized, real-time AI recommendations, please configure the Gemini API key. In the meantime, I can assist you with general skincare questions.",
                "is_fallback": True
            })

        # Call the Gemini API
        url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key={api_key}"
        payload = {
            "contents": contents,
            "systemInstruction": {
                "parts": [{"text": system_instruction}]
            },
            "generationConfig": {
                "maxOutputTokens": 800,
                "temperature": 0.7,
            }
        }
        
        try:
            response = requests.post(url, json=payload, timeout=12)
            if response.status_code == 200:
                result_json = response.json()
                reply_text = result_json['candidates'][0]['content']['parts'][0]['text'].strip()
                return Response({
                    "text": reply_text,
                    "is_fallback": False
                })
            else:
                return Response({
                    "text": "I'm sorry, I'm having trouble connecting to my knowledge base right now. Please try again in a moment.",
                    "is_fallback": True
                })
        except Exception as e:
            return Response({
                "text": "I'm sorry, I encountered an error processing your chat. Please try again.",
                "is_fallback": True
            })


