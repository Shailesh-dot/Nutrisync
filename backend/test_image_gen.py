import sys
import os
from dotenv import load_dotenv

# Add current directory to path
sys.path.append(os.path.dirname(os.path.abspath(__file__)))

from ai_service import gemini_service
from models import RecipeRequest

def test_image_generation():
    print("Testing Image Generation Prompt...")
    recipe_name = "Gourmet Tropical Protein Clafoutis"
    ingredients = ["eggs", "protein powder", "vanilla", "milk", "tropical fruits"]
    
    prompt = gemini_service.generate_image_prompt(recipe_name, ingredients)
    print(f"Generated Image Prompt: {prompt}")
    
    image_url = gemini_service.get_image_url(recipe_name, ingredients)
    print(f"Generated Image URL: {image_url}")
    
    if "pollinations.ai" in image_url:
        print("SUCCESS: Image URL is from Pollinations AI.")
    else:
        print("FAILURE: Image URL is incorrect.")

if __name__ == "__main__":
    load_dotenv(override=True)
    test_image_generation()
