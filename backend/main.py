import os
import json
import traceback
from contextlib import asynccontextmanager
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv

# Robust environment variable loading using absolute paths
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
load_dotenv(os.path.join(BASE_DIR, ".env"), override=True)

# Import local modules
from models import RecipeRequest, RecipeResponse
from vector_db import VectorDB
from ai_service import GeminiService

# -----------------------------------------------------------------------------
# Lifespan Management
# -----------------------------------------------------------------------------
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup logic
    api_key = os.getenv("GEMINI_API_KEY")
    key_peek = f"{api_key[:4]}...{api_key[-4:]}" if api_key else "NOT FOUND"
    print(f"Nutrisync API starting up... (Using API Key: {key_peek})")
    
    global vdb, gemini
    try:
        vdb = VectorDB()
        gemini = GeminiService()
        
        if vdb.collection.count() == 0:
            print("Populating initial recipe database...")
            vdb.add_recipes("./database/recipes.json")
        else:
            print(f"Database contains {vdb.collection.count()} recipes.")
    except Exception as e:
        print(f"CRITICAL STARTUP ERROR: {e}")
        traceback.print_exc()

    yield
    # Shutdown logic
    print("Nutrisync API shutting down...")

app = FastAPI(
    title="Nutrisync API",
    description="Backend for Recipe Generation and Nutritional Analysis using Gemini 1.5 and RAG.",
    version="1.0.0",
    lifespan=lifespan
)

# Enable CORS for frontend integration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Global variables for services
vdb = None
gemini = None

# -----------------------------------------------------------------------------
# Endpoints
# -----------------------------------------------------------------------------

@app.get("/")
async def root():
    return {"message": "Welcome to Nutrisync API. Visit /docs for Swagger UI documentation."}

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

@app.post("/api/v1/generate-recipe", response_model=RecipeResponse)
async def generate_recipe(request: RecipeRequest):
    if vdb is None or gemini is None:
        raise HTTPException(status_code=503, detail="Services not initialized")
        
    try:
        print(f"--- Generating recipe for: {request.ingredients} ---")
        
        # 1. Query the VectorDB for context
        query_text = f"Recipe with {', '.join(request.ingredients)}"
        search_results = vdb.query_recipes(query_text, n_results=2)
        
        # Prepare context for the AI
        context_recipes = []
        if search_results and "metadatas" in search_results and search_results["metadatas"]:
            for meta in search_results["metadatas"][0]:
                if "nutrition" in meta and isinstance(meta["nutrition"], str):
                    meta["nutrition"] = json.loads(meta["nutrition"])
                context_recipes.append(meta)

        # 2. Generate the recipe using Gemini
        recipe_response = gemini.generate_recipe(request, context_recipes)
        
        # 3. Generate the image URL (Synchronous as requested)
        print(f"Generating image for: {recipe_response.recipe_name}")
        image_url = gemini.get_image_url(recipe_response.recipe_name, request.ingredients)
        recipe_response.image_url = image_url
        
        print(f"Successfully generated: {recipe_response.recipe_name}")
        return recipe_response

    except Exception as e:
        print("!!! ERROR GENERATING RECIPE !!!")
        print(f"Error Type: {type(e).__name__}")
        print(f"Error Message: {str(e)}")
        # Print the full traceback so we can see the exact line that failed
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    # Bind to 0.0.0.0 so the server is reachable from:
    # - Android Emulator via: http://10.0.2.2:8000
    # - Physical device on same WiFi via: http://<your-pc-local-ip>:8000
    # - Same machine (desktop Flutter) via: http://127.0.0.1:8000
    uvicorn.run(app, host="0.0.0.0", port=8000)
