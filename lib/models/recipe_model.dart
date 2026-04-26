class Ingredient {
  final String name;
  final String quantity;

  Ingredient({required this.name, required this.quantity});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'quantity': quantity,
      };
}

class NutritionFacts {
  final double calories;
  final double protein;
  final double carbohydrates;
  final double fat;
  final double? fiber;

  NutritionFacts({
    required this.calories,
    required this.protein,
    required this.carbohydrates,
    required this.fat,
    this.fiber,
  });

  factory NutritionFacts.fromJson(Map<String, dynamic> json) {
    // Robust parsing for AI-generated numbers which might come back as strings
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) {
        return double.tryParse(value.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
      }
      return 0.0;
    }

    return NutritionFacts(
      calories: parseDouble(json['calories']),
      protein: parseDouble(json['protein']),
      carbohydrates: parseDouble(json['carbohydrates']),
      fat: parseDouble(json['fat']),
      fiber: json['fiber'] != null ? parseDouble(json['fiber']) : null,
    );
  }
}

class RecipeStep {
  final int stepNumber;
  final String instruction;

  RecipeStep({required this.stepNumber, required this.instruction});

  factory RecipeStep.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      if (value is String) {
        return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      }
      return 0;
    }

    return RecipeStep(
      stepNumber: parseInt(json['step_number']),
      instruction: json['instruction'] ?? '',
    );
  }
}

class RecipeResponse {
  final String recipeName;
  final int totalTime;
  final List<Ingredient> ingredientsUsed;
  final List<RecipeStep> steps;
  final NutritionFacts nutritionFacts;
  final String? imageUrl; // NEW: Added field for AI Generated Image

  RecipeResponse({
    required this.recipeName,
    required this.totalTime,
    required this.ingredientsUsed,
    required this.steps,
    required this.nutritionFacts,
    this.imageUrl,
  });

  factory RecipeResponse.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value.toInt();
      if (value is String) {
        return int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      }
      return 0;
    }

    return RecipeResponse(
      recipeName: json['recipe_name'] ?? '',
      totalTime: parseInt(json['total_time']),
      ingredientsUsed: (json['ingredients_used'] as List? ?? [])
          .map((e) => Ingredient.fromJson(e))
          .toList(),
      steps: (json['steps'] as List? ?? [])
          .map((e) => RecipeStep.fromJson(e))
          .toList(),
      nutritionFacts:
          NutritionFacts.fromJson(json['nutrition_facts'] ?? {}),
      imageUrl: json['image_url'], // NEW: Parse the URL from backend
    );
  }
}

class RecipeRequest {
  final List<String> ingredients;
  final int? numIngredients;
  final String? dietaryPreferences;

  RecipeRequest({
    required this.ingredients,
    this.numIngredients,
    this.dietaryPreferences,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'ingredients': ingredients,
    };
    if (numIngredients != null) map['num_ingredients'] = numIngredients;
    if (dietaryPreferences != null) {
      map['dietary_preferences'] = dietaryPreferences;
    }
    return map;
  }
}

/// Local ingredient item for the input screen list
class IngredientItem {
  final String name;
  final String? category;
  final double? estimatedCalories;

  IngredientItem({
    required this.name,
    this.category,
    this.estimatedCalories,
  });
}
