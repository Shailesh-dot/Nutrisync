import google.generativeai as genai
import os
from dotenv import load_dotenv

# Test current .env key first
load_dotenv(override=True)
env_key = os.getenv("GEMINI_API_KEY")

variations = [
    env_key,
    "AIzaSyDyEfq7b0BfjK40V0U_ljInja7FnAHA9Hs",
    "AIzaSyCgakhRZEShEWmA50YCrPvbTjbO5jnglxE",
    "AIzaSyCgakhRZEShEWmA50YCrPvbTjbO5jnglxe", # lowercase lxe
    "AIzaSyCgakhRZEShEWmA50YCrPvbTjbO5jng1xe", # 1xe
    "AIzaSyCgakhRZESnEWmA50YCrPvbTjbO5jnglxE", # n instead of h
]

# Remove duplicates
variations = list(set([v for v in variations if v]))

print("--- Nutrisync API Key Final Diagnostic ---")
valid_key = None

for i, key in enumerate(variations):
    print(f"Testing Key {i+1}: {key[:10]}...{key[-5:]}")
    try:
        genai.configure(api_key=key)
        # Try to actually generate a tiny bit of content to verify FULL API access
        model = genai.GenerativeModel("gemini-1.5-flash")
        response = model.generate_content("Say OK")
        if response.text:
            print(f"✅ SUCCESS! Key {i+1} is fully FUNCTIONAL.")
            valid_key = key
            break
    except Exception as e:
        print(f"❌ Failed: {e}")

if valid_key:
    print(f"\n[INFO] Found working key: {valid_key}")
    with open(".env", "w") as f:
        f.write(f"GEMINI_API_KEY={valid_key}\n")
        f.write("MODEL_NAME=gemini-1.5-flash\n")
        f.write("EMBEDDING_MODEL_NAME=models/embedding-001\n")
    print("[INFO] .env file updated in backend.")
else:
    print("\n❌ NO VALID KEY FOUND. Please check Google AI Studio.")

print("\nDiagnostic complete.")
