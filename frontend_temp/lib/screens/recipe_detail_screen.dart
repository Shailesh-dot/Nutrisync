import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/app_theme.dart';
import '../models/recipe_model.dart';

class RecipeDetailScreen extends StatefulWidget {
  final RecipeResponse recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final n = recipe.nutritionFacts;

    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── HERO HEADER ───────────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 380,
            pinned: true,
            stretch: true,
            backgroundColor: AppTheme.primaryGreen,
            elevation: 0,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 20),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // --- Fixed AI Image Loader ---
                  if (recipe.imageUrl != null && recipe.imageUrl!.isNotEmpty)
                    Image.network(
                      recipe.imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Shimmer.fromColors(
                          baseColor: AppTheme.surfaceGreen,
                          highlightColor: Colors.white,
                          child: Container(
                            color: Colors.white,
                            child: const Center(
                              child: Icon(Icons.auto_awesome_rounded, color: AppTheme.primaryGreen, size: 50),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) => Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [AppTheme.primaryGreen, AppTheme.primaryGreenDark],
                          ),
                        ),
                        child: const Center(
                          child: Icon(Icons.restaurant_rounded, color: Colors.white, size: 50),
                        ),
                      ),
                    )
                  else
                    // Final Fallback
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [AppTheme.primaryGreen, AppTheme.accentTeal],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 50),
                      ),
                    ),

                  // Gradient Overlay
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.transparent,
                          Colors.black87,
                        ],
                        stops: [0, 0.4, 1.0],
                      ),
                    ),
                  ),
                  // Header Content (Overlay Text)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            _buildTag('AI CUSTOM', AppTheme.accentTeal),
                            const SizedBox(width: 8),
                            _buildTag('${recipe.totalTime} MIN', AppTheme.warningAmber),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          recipe.recipeName,
                          style: AppTheme.displayLarge.copyWith(
                            color: Colors.white,
                            fontSize: 28,
                            height: 1.1,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'A delicious, chef-curated gourmet recipe designed specifically for your nutrition goals.',
                          style: AppTheme.bodySmall.copyWith(
                            color: Colors.white70,
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ─── MAIN CONTENT ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppTheme.backgroundWhite,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),

                  // ── Nutrition Grid ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.6,
                      children: [
                        _buildMacroCard('CALORIES', n.calories.toStringAsFixed(0), 'total', AppTheme.calorieColor),
                        _buildMacroCard('PROTEIN', '${n.protein.toStringAsFixed(0)}g', 'per serving', AppTheme.proteinColor),
                        _buildMacroCard('CARBS', '${n.carbohydrates.toStringAsFixed(0)}g', 'low carb', AppTheme.carbsColor),
                        _buildMacroCard('FATS', '${n.fat.toStringAsFixed(0)}g', 'healthy fats', AppTheme.fatColor),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Ingredients List ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ingredients', style: AppTheme.headlineMedium),
                        Text('${recipe.ingredientsUsed.length} items', style: AppTheme.bodySmall),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...recipe.ingredientsUsed.asMap().entries.map((entry) {
                    return _buildIngredientItem(entry.value, entry.key)
                        .animate()
                        .fadeIn(delay: (entry.key * 50).ms, duration: 400.ms)
                        .slideX(begin: 0.05, end: 0, delay: (entry.key * 50).ms, duration: 400.ms);
                  }),

                  const SizedBox(height: 24),

                  // Add to Grocery Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        onPressed: () {},
                        child: const Text('Add to Grocery List', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // ── Instructions ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Instructions', style: AppTheme.headlineMedium),
                  ),
                  const SizedBox(height: 24),
                  ...recipe.steps.asMap().entries.map((entry) {
                    return _buildStepItem(entry.value, entry.key == recipe.steps.length - 1)
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 500.ms);
                  }),

                  const SizedBox(height: 48),

                  // ── Serve With ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text('Serve with...', style: AppTheme.headlineMedium),
                  ),
                  const SizedBox(height: 20),
                  _buildServeWithSection(),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5),
      ),
    );
  }

  Widget _buildMacroCard(String label, String value, String subLabel, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.1), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: AppTheme.labelSmall.copyWith(color: color, fontSize: 10)),
          const SizedBox(height: 6),
          Text(value, style: AppTheme.displayMedium.copyWith(color: AppTheme.textPrimary, fontSize: 24)),
          Text(subLabel, style: AppTheme.bodySmall.copyWith(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildIngredientItem(Ingredient ingredient, int index) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(_getIngredientIcon(ingredient.name), color: AppTheme.primaryGreen, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(ingredient.name, style: AppTheme.titleMedium.copyWith(fontSize: 15)),
          ),
          Text(ingredient.quantity, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildStepItem(RecipeStep step, bool isLast) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryGreen,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('${step.stepNumber}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 80,
                  color: AppTheme.primaryGreen.withOpacity(0.1),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Step ${step.stepNumber}', style: AppTheme.titleMedium.copyWith(color: AppTheme.primaryGreenDark)),
                const SizedBox(height: 8),
                Text(
                  step.instruction,
                  style: AppTheme.bodyMedium.copyWith(height: 1.6, color: AppTheme.textPrimary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServeWithSection() {
    final demos = [
      {'name': 'Garden Salad', 'sub': 'Fresh & Antioxidant', 'icon': Icons.eco},
      {'name': 'Roasted Asparagus', 'sub': '15 min • 45 kcal', 'icon': Icons.grain},
      {'name': 'Lemon Quinoa', 'sub': '12 min • 220 kcal', 'icon': Icons.auto_awesome_mosaic},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: demos.map((item) {
          return Container(
            width: 240,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppTheme.softShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(item['icon'] as IconData, color: AppTheme.primaryGreen, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['name'] as String, style: AppTheme.titleMedium.copyWith(fontSize: 14)),
                      Text(item['sub'] as String, style: AppTheme.bodySmall.copyWith(fontSize: 11)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIngredientIcon(String name) {
    name = name.toLowerCase();
    if (name.contains('salmon') || name.contains('fish')) return Icons.set_meal_rounded;
    if (name.contains('lemon') || name.contains('lime')) return Icons.brightness_high_rounded;
    if (name.contains('herb') || name.contains('rosemary') || name.contains('thyme')) return Icons.eco_rounded;
    if (name.contains('oil')) return Icons.opacity_rounded;
    if (name.contains('garlic')) return Icons.vaping_rooms_rounded;
    return Icons.restaurant_rounded;
  }
}
