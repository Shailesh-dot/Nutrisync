import google.generativeai as genai
import os
import json
import traceback
import time
import urllib.parse
from dotenv import load_dotenv
from models import RecipeResponse, RecipeRequest
from typing import List, Dict

# Force override
load_dotenv(override=True)

class GeminiService:
    def __init__(self):
        self.api_key = os.getenv("GEMINI_API_KEY")
        # Default to gemini-1.5-flash if not specified
        primary_model = os.getenv("MODEL_NAME", "gemini-1.5-flash")
        self.preferred_models = [primary_model, "gemini-1.5-flash", "gemini-pro"]
        genai.configure(api_key=self.api_key)

    def generate_recipe(self, request: RecipeRequest, context_recipes: List[Dict]) -> RecipeResponse:
        ingredients_str = ", ".join(request.ingredients)
        context_str = json.dumps(context_recipes, indent=2)
        
        prompt = f"""
        You are an expert nutritionist and world-class chef with mastery over ALL Global Cuisines (Indian, Asian, Mediterranean, Latin, etc.).
        
        A user has provided these ingredients: {ingredients_str}.
        Dietary preferences: {request.dietary_preferences if request.dietary_preferences else 'None'}.

        INSTRUCTIONS:
        1. Create an AUTHENTIC gourmet recipe. If the ingredients suggest a specific cuisine (e.g., North Indian, Thai, Italian), follow the authentic techniques for that style.
        2. We do NOT care about time limits anymore; focus entirely on the BEST and most accurate recipe (even if it takes hours or overnight for things like Dosa/Biryani).
        3. Explain each step in VERY SIMPLE English.
        4. If the provided ingredients do not perfectly match the local database context below, use your VAST INTERNAL GLOBAL KNOWLEDGE to create the correct recipe.

        JSON structure ONLY:
        {{
            "recipe_name": "Authentic Name",
            "total_time": 45, 
            "ingredients_used": [{{"name": "Ingredient", "quantity": "Amount"}}],
            "steps": [{{"step_number": 1, "instruction": "Simple clear sentence"}}],
            "nutrition_facts": {{"calories": 0, "protein": 0, "carbohydrates": 0, "fat": 0, "fiber": 0}}
        }}

        Reference Context (Use for grounding, but prioritize authenticity):
        {context_str}
        """

        last_error = None
        for model_name in self.preferred_models:
            try:
                full_model_name = model_name if model_name.startswith("models/") else f"models/{model_name}"
                model = genai.GenerativeModel(full_model_name)
                response = model.generate_content(prompt)
                
                if not response.text: continue
                    
                text = response.text
                json_start = text.find("{")
                json_end = text.rfind("}") + 1
                recipe_data = json.loads(text[json_start:json_end])
                
                return RecipeResponse(**recipe_data)

            except Exception as e:
                last_error = e
                error_msg = str(e).lower()
                if "429" in error_msg or "resource_exhausted" in error_msg:
                    time.sleep(2)
                    continue
                else: continue

        raise last_error if last_error else Exception("Failed to generate recipe.")
        
    def generate_image_prompt(self, recipe_name: str, ingredients: List[str]) -> str:
        """Generates a high-quality food photography prompt based on the recipe."""
        ingredients_str = ", ".join(ingredients)
        prompt = f"""
        Given the recipe name: {recipe_name}
        And ingredients: {ingredients_str}
        
        Write a ONE SENTENCE descriptive prompt for a professional food photographer.
        Include details about the colors, textures, lighting, and plating style.
        Focus on making it look DELICIOUS and GOURMET.
        """
        
        try:
            model = genai.GenerativeModel("gemini-1.5-flash")
            response = model.generate_content(prompt)
            if response.text:
                return response.text.strip()
        except:
            pass
            
        # Fallback prompt if Gemini fails
        return f"Professional food photography of {recipe_name}, featuring {ingredients_str}, gourmet plating, high resolution, soft cinematic lighting."

    def get_image_url(self, recipe_name: str, ingredients: List[str]) -> str:
        """Returns a Pollinations AI image URL for the recipe."""
        visual_prompt = self.generate_image_prompt(recipe_name, ingredients)
        
        # CLEAN PROMPT: Remove newlines, leading/trailing whitespace, and multiple spaces
        clean_prompt = visual_prompt.replace('\n', ' ').replace('\r', ' ').strip()
        while '  ' in clean_prompt:
            clean_prompt = clean_prompt.replace('  ', ' ')
            
        # Ensure the prompt is safe for URL
        encoded_prompt = urllib.parse.quote(clean_prompt)
        
        # Add some random seed to avoid caching if needed
        seed = int(time.time()) % 1000
        
        # Use the DEDICATED image endpoint (image.pollinations.ai) which is more stable for direct loading
        url = f"https://image.pollinations.ai/prompt/{encoded_prompt}?width=1024&height=1024&seed={seed}&model=flux&nologo=true&private=true"
        print(f"Generated Image URL: {url}")
        return url

# Singleton instance
gemini_service = GeminiService()
