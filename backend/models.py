from pydantic import BaseModel, Field
from typing import List, Optional

class Ingredient(BaseModel):
    name: str = Field(..., example="Chicken Breast")
    quantity: str = Field(..., example="200g")

class Nutrition(BaseModel):
    calories: float = Field(..., description="Total calories in kcal")
    protein: float = Field(..., description="Protein in grams")
    carbohydrates: float = Field(..., description="Carbohydrates in grams")
    fat: float = Field(..., description="Fat in grams")
    fiber: Optional[float] = Field(None, description="Fiber in grams")

class RecipeStep(BaseModel):
    step_number: int
    instruction: str

class RecipeResponse(BaseModel):
    recipe_name: str
    total_time: int = Field(..., description="Total time in minutes (Target: 10-15 mins)")
    ingredients_used: List[Ingredient]
    steps: List[RecipeStep]
    nutrition_facts: Nutrition
    image_url: Optional[str] = None

class RecipeRequest(BaseModel):
    ingredients: List[str] = Field(..., min_items=1, example=["chicken", "onion", "garlic"])
    num_ingredients: Optional[int] = Field(None, description="Optional limit on number of ingredients to use")
    dietary_preferences: Optional[str] = Field(None, example="Low carb, Keto, Vegan")
