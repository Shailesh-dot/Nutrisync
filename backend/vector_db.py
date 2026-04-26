import chromadb
from chromadb.utils import embedding_functions
import os
import json
from dotenv import load_dotenv

# Robust environment variable loading using absolute paths
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
load_dotenv(os.path.join(BASE_DIR, ".env"), override=True)

class VectorDB:
    def __init__(self, db_path="./chroma_db"):
        self.client = chromadb.PersistentClient(path=db_path)
        
        api_key = os.getenv("GEMINI_API_KEY")
        if not api_key:
            raise ValueError("GEMINI_API_KEY not found in environment.")
            
        print(f"DEBUG: VectorDB initializing with key starting with: {api_key[:4]}...{api_key[-4:]}")
        
        # Use Google's embedding function
        self.embedding_fn = embedding_functions.GoogleGenerativeAiEmbeddingFunction(
            api_key=api_key,
            model_name=os.getenv("EMBEDDING_MODEL_NAME")
        )
        self.collection = self.client.get_or_create_collection(
            name="recipes",
            embedding_function=self.embedding_fn
        )

    def add_recipes(self, recipes_file):
        with open(recipes_file, "r") as f:
            recipes = json.load(f)
        
        ids = [r["id"] for r in recipes]
        # We'll embed the combination of name and ingredients for better retrieval
        documents = [f"{r['name']} with ingredients: {', '.join(r['ingredients'])}" for r in recipes]
        metadatas = [
            {
                "name": r["name"],
                "prep_time": r["prep_time"],
                "cook_time": r["cook_time"],
                "nutrition": json.dumps(r["nutrition"])
            } 
            for r in recipes
        ]
        
        self.collection.add(
            ids=ids,
            documents=documents,
            metadatas=metadatas
        )
        print(f"Added {len(recipes)} recipes to Vector DB.")

    def query_recipes(self, query_text, n_results=2):
        results = self.collection.query(
            query_texts=[query_text],
            n_results=n_results
        )
        return results

# Initialize and populate if empty
if __name__ == "__main__":
    vdb = VectorDB()
    if vdb.collection.count() == 0:
        vdb.add_recipes("./database/recipes.json")
    
    # Test query
    results = vdb.query_recipes("chicken and garlic")
    print(results)
