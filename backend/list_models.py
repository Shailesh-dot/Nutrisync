import google.generativeai as genai
import os
from dotenv import load_dotenv

load_dotenv(override=True)

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))

print("--- Checking ALL Available Models for your API Key ---")
try:
    for m in genai.list_models():
        # Check for generation capability OR embedding
        methods = m.supported_generation_methods
        if 'generateContent' in methods or 'embedContent' in methods:
            print(f"Model ID: {m.name} | Supports: {', '.join(methods)}")
except Exception as e:
    print(f"Error listing models: {e}")
