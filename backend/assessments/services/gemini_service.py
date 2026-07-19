import os
import json
import re
import logging
import requests
from ..prompts.skin_analysis_prompt import SKIN_ANALYSIS_PROMPT

logger = logging.getLogger(__name__)

class GeminiService:
    @staticmethod
    def analyze_skin(answers):
        api_key = os.environ.get('GEMINI_API_KEY', '').strip()

        prompt = SKIN_ANALYSIS_PROMPT.format(
            skin_type=answers.get('skin_type', 'Normal'),
            sensitivity=answers.get('sensitivity', 'Tolerant'),
            concern=answers.get('concern', 'None'),
            sun_exposure=answers.get('sun_exposure', 'Medium'),
            habit=answers.get('habit', 'Sometimes')
        )

        if not api_key:
            logger.warning("No GEMINI_API_KEY found in environment. Using fallback data.")
            return GeminiService._get_fallback_data(answers)

        url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key={api_key}"
        headers = {"Content-Type": "application/json"}
        payload = {
            "contents": [{"parts": [{"text": prompt}]}],
            "generationConfig": {
                "responseMimeType": "application/json"
            }
        }

        try:
            response = requests.post(url, headers=headers, json=payload, timeout=12)
            if response.status_code == 200:
                result_json = response.json()
                text_response = result_json['candidates'][0]['content']['parts'][0]['text'].strip()
                
               
                start_idx = text_response.find('{')
                end_idx = text_response.rfind('}')
                if start_idx != -1 and end_idx != -1:
                    text_response = text_response[start_idx:end_idx + 1]
                
                
                text_response = re.sub(r',\s*([\]}])', r'\1', text_response)
                
                parsed = json.loads(text_response)
                
                required_keys = {
                    "predicted_skin_type",
                    "explanation",
                    "am_routine",
                    "pm_routine",
                    "recommended_ingredients",
                    "avoid_ingredients"
                }
                
                if not required_keys.issubset(parsed.keys()):
                    logger.warning(f"Gemini response missing keys: {required_keys - parsed.keys()}")
                    return GeminiService._get_fallback_data(answers)

                parsed["is_fallback"] = False
                return parsed
            else:
                logger.warning(f"Gemini API returned status {response.status_code}: {response.text[:200]}")
                return GeminiService._get_fallback_data(answers)
        except Exception as e:
            logger.error(f"Gemini API call failed: {e}", exc_info=True)
            return GeminiService._get_fallback_data(answers)

    @staticmethod
    def _get_fallback_data(answers):
        skin_type = answers.get('skin_type', 'Combination')
        sensitivity = answers.get('sensitivity', 'Tolerant')

        return {
            "predicted_skin_type": f"{skin_type} ({sensitivity})",
            "explanation": f"Based on your inputs (Concern: {answers.get('concern', 'General maintenance')}), we recommend a balanced organic routine to soothe and protect your skin.",
            "am_routine": [
                "Gentle Chamomile Wash",
                "Hydrating Rose Water",
                "Light SPF Protection"
            ],
            "pm_routine": [
                "Deep Cleansing Gel",
                "Soothing Rosehip Serum",
                "Nourishing Shea Moisturizer"
            ],
            "recommended_ingredients": ["Aloe Vera", "Jojoba Oil", "Chamomile"],
            "avoid_ingredients": ["Parabens", "Harsh Sulfates", "Synthetic Scents"],
            "is_fallback": True
        }