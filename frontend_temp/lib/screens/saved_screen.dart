import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../models/recipe_model.dart';
import 'recipe_detail_screen.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<RecipeResponse> _savedRecipes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedRecipes();
  }

  Future<void> _loadSavedRecipes() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_recipes') ?? [];
    final recipes = <RecipeResponse>[];
    for (final s in saved) {
      try {
        recipes.add(RecipeResponse.fromJson(jsonDecode(s)));
      } catch (_) {}
    }
    if (mounted) {
      setState(() {
        _savedRecipes = recipes;
        _isLoading = false;
      });
    }
  }

  Future<void> _removeRecipe(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('saved_recipes') ?? [];
    if (index < saved.length) {
      saved.removeAt(index);
      await prefs.setStringList('saved_recipes', saved);
      setState(() => _savedRecipes.removeAt(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppTheme.backgroundWhite,
            surfaceTintColor: Colors.transparent,
            toolbarHeight: 64,
            title: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreenDark,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.restaurant_menu_rounded,
                      color: Colors.white, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'NutriSync',
                  style: AppTheme.headlineMedium.copyWith(
                    color: AppTheme.primaryGreen,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: AppTheme.softShadow,
                ),
                child: IconButton(
                  icon: const Icon(Icons.refresh_rounded, size: 22),
                  color: AppTheme.textPrimary,
                  onPressed: _loadSavedRecipes,
                ),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text('Saved Recipes',
                      style: AppTheme.displayMedium.copyWith(fontSize: 26))
                      .animate()
                      .fadeIn(duration: 400.ms)
                      .slideX(begin: -0.05, end: 0, duration: 400.ms),
                  const SizedBox(height: 4),
                  Text(
                    '${_savedRecipes.length} recipe${_savedRecipes.length != 1 ? "s" : ""} saved',
                    style: AppTheme.bodyMedium,
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 400.ms),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTheme.primaryGreen,
                  strokeWidth: 2.5,
                ),
              ),
            )
          else if (_savedRecipes.isEmpty)
            SliverFillRemaining(
              child: _buildEmptyState(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return _buildRecipeCard(_savedRecipes[index], index);
                  },
                  childCount: _savedRecipes.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.surfaceGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.bookmark_border_rounded,
              size: 44,
              color: AppTheme.primaryGreen,
            ),
          )
              .animate()
              .scale(
                begin: const Offset(0.5, 0.5),
                end: const Offset(1.0, 1.0),
                duration: 500.ms,
                curve: Curves.elasticOut,
              )
              .fadeIn(duration: 400.ms),
          const SizedBox(height: 24),
          Text(
            'No saved recipes yet',
            style: AppTheme.headlineLarge.copyWith(fontSize: 20),
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            'Generate a recipe and save it\nto view it here.',
            textAlign: TextAlign.center,
            style: AppTheme.bodyMedium.copyWith(height: 1.6),
          )
              .animate()
              .fadeIn(delay: 300.ms, duration: 400.ms),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.greenGlow,
            ),
            child: Text(
              'Explore Recipes',
              style: AppTheme.labelLarge.copyWith(color: Colors.white),
            ),
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 400.ms)
              .scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1.0, 1.0),
                delay: 400.ms,
                duration: 400.ms,
              ),
        ],
      ),
    );
  }

  Widget _buildRecipeCard(RecipeResponse recipe, int index) {
    final n = recipe.nutritionFacts;
    final tags = <String>[];
    if (n.carbohydrates < 30) tags.add('Low Carb');
    if (n.protein > 25) tags.add('High Protein');
    if (n.calories < 300) tags.add('Low Cal');

    final gradients = [
      [const Color(0xFF2D6A4F), const Color(0xFF40916C)],
      [const Color(0xFF1B4332), const Color(0xFF52B788)],
      [const Color(0xFF0D3B2E), const Color(0xFF2D6A4F)],
    ];
    final gradient = gradients[index % gradients.length];

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(recipe: recipe),
          ),
        );
      },
      child: Dismissible(
        key: Key('${recipe.recipeName}_$index'),
        direction: DismissDirection.endToStart,
        background: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppTheme.errorRed,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete_outline_rounded,
              color: Colors.white, size: 26),
        ),
        onDismissed: (_) => _removeRecipe(index),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: AppTheme.softShadow,
          ),
          child: Row(
            children: [
              // Left accent
              Container(
                width: 80,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: gradient,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.restaurant_rounded,
                    color: Colors.white.withValues(alpha: 0.7),
                    size: 36,
                  ),
                ),
              ),
              // Details
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.recipeName,
                        style: AppTheme.titleMedium.copyWith(fontSize: 14),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.local_fire_department_rounded,
                              size: 14, color: AppTheme.calorieColor),
                          const SizedBox(width: 4),
                          Text(
                            '${n.calories.toStringAsFixed(0)} kcal',
                            style: AppTheme.bodySmall.copyWith(fontSize: 12),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.schedule_rounded,
                              size: 14, color: AppTheme.textTertiary),
                          const SizedBox(width: 4),
                          Text(
                            '${recipe.totalTime} min',
                            style: AppTheme.bodySmall.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      if (tags.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: tags.take(2).map((tag) {
                            return Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.surfaceGreen,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                tag,
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.primaryGreenDark,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 14),
                child: Icon(Icons.chevron_right_rounded,
                    color: AppTheme.textTertiary, size: 22),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: (80 * index).ms, duration: 400.ms)
        .slideX(begin: 0.05, end: 0, delay: (80 * index).ms, duration: 400.ms);
  }
}
