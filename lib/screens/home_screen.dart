import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _moodChips = [
    {'label': 'Energizing', 'icon': Icons.bolt_rounded},
    {'label': 'Calm & Digest', 'icon': Icons.spa_rounded},
    {'label': 'Focus', 'icon': Icons.psychology_rounded},
    {'label': 'Anti-Inflammatory', 'icon': Icons.local_fire_department_rounded},
    {'label': 'High Protein', 'icon': Icons.fitness_center_rounded},
    {'label': 'Low Carb', 'icon': Icons.eco_rounded},
  ];

  final List<Map<String, dynamic>> _featuredRecipes = [
    {
      'name': 'Emerald Garden\nBuddha Bowl',
      'subtitle': 'Rich in magnesium and antioxidants,\nfeaturing cold-pressed olive oil.',
      'tags': ['SEASONAL PICK', '15 MIN PREP'],
      'gradient': [const Color(0xFF2D6A4F), const Color(0xFF40916C)],
      'icon': Icons.eco_rounded,
      'image': 'assets/images/hero_bowl.png',
    },
    {
      'name': 'Mediterranean\nQuinoa Salad',
      'subtitle': 'Loaded with vitamins and fiber,\nfresh herbs and lemon dressing.',
      'tags': ['TRENDING', '10 MIN PREP'],
      'gradient': [const Color(0xFF1B4332), const Color(0xFF52B788)],
      'icon': Icons.restaurant_rounded,
    },
  ];

  final List<Map<String, dynamic>> _recommendedRecipes = [
    {
      'name': 'Asian Noodle Bowl',
      'cal': '380 kcal',
      'time': '15 min',
      'color': const Color(0xFF4A7C59),
      'image': 'assets/images/noodle_bowl.png',
    },
    {
      'name': 'Lentil Curry Soup',
      'cal': '290 kcal',
      'time': '25 min',
      'color': const Color(0xFFB8860B),
      'image': 'assets/images/curry_soup.png',
    },
    {
      'name': 'Grilled Chicken Wrap',
      'cal': '420 kcal',
      'time': '12 min',
      'color': const Color(0xFF8B4513),
    },
    {
      'name': 'Veggie Stir Fry',
      'cal': '310 kcal',
      'time': '18 min',
      'color': const Color(0xFF2E8B57),
    },
  ];

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ─── App Bar ──────────────────────────────────
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
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.restaurant_menu_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
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
                  icon: const Icon(Icons.notifications_none_rounded, size: 22),
                  color: AppTheme.textPrimary,
                  onPressed: () {},
                ),
              ),
            ],
          ),

          // ─── Body Content ─────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Greeting
                  Text(
                    _getGreeting(),
                    style: AppTheme.displayLarge.copyWith(fontSize: 30),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: -0.05, end: 0, duration: 500.ms),
                  Text(
                    'Chef!',
                    style: AppTheme.displayLarge.copyWith(fontSize: 30),
                  )
                      .animate()
                      .fadeIn(delay: 100.ms, duration: 500.ms)
                      .slideX(begin: -0.05, end: 0, delay: 100.ms, duration: 500.ms),

                  const SizedBox(height: 8),
                  Text(
                    'Ready to curate today\'s botanical menu? Your\npersonalized nutrition insights are waiting.',
                    style: AppTheme.bodyMedium.copyWith(
                      height: 1.6,
                      color: AppTheme.textSecondary,
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 500.ms),

                  const SizedBox(height: 24),

                  // Search Bar
                  _buildSearchBar()
                      .animate()
                      .fadeIn(delay: 300.ms, duration: 500.ms)
                      .slideY(begin: 0.1, end: 0, delay: 300.ms, duration: 500.ms),

                  const SizedBox(height: 28),

                  // Featured Recipe Card
                  _buildFeaturedCarousel()
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 600.ms)
                      .slideY(begin: 0.1, end: 0, delay: 400.ms, duration: 600.ms),

                  const SizedBox(height: 32),

                  // Daily Balance
                  _buildDailyBalance()
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 500.ms)
                      .slideY(begin: 0.1, end: 0, delay: 500.ms, duration: 500.ms),

                  const SizedBox(height: 32),

                  // Explore by Mood
                  _buildMoodSection()
                      .animate()
                      .fadeIn(delay: 600.ms, duration: 500.ms)
                      .slideY(begin: 0.1, end: 0, delay: 600.ms, duration: 500.ms),

                  const SizedBox(height: 32),

                  // Recommended
                  _buildRecommendedSection()
                      .animate()
                      .fadeIn(delay: 700.ms, duration: 500.ms)
                      .slideY(begin: 0.1, end: 0, delay: 700.ms, duration: 500.ms),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
        border: Border.all(color: AppTheme.dividerColor.withValues(alpha: 0.5)),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search recipes, ingredients, or nutrients...',
          hintStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.textTertiary),
          prefixIcon: const Padding(
            padding: EdgeInsets.only(left: 16, right: 12),
            child: Icon(Icons.search_rounded, color: AppTheme.textTertiary, size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildFeaturedCarousel() {
    return SizedBox(
      height: 260,
      child: PageView.builder(
        itemCount: _featuredRecipes.length,
        controller: PageController(viewportFraction: 1.0),
        itemBuilder: (context, index) {
          final recipe = _featuredRecipes[index];
          return _buildFeaturedCard(recipe);
        },
      ),
    );
  }

  Widget _buildFeaturedCard(Map<String, dynamic> recipe) {
    return Container(
      margin: const EdgeInsets.only(right: 0),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: AppTheme.mediumShadow,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          if (recipe['image'] != null)
            Image.asset(
              recipe['image'] as String,
              fit: BoxFit.cover,
            )
          else
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: recipe['gradient'] as List<Color>,
                ),
              ),
            ),

          // Gradient Overlay for readability
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.7),
                ],
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tags
                Row(
                  children: (recipe['tags'] as List<String>).map((tag) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        tag,
                        style: AppTheme.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 10,
                          letterSpacing: 0.5,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const Spacer(),
                Text(
                  recipe['name'] as String,
                  style: AppTheme.displayMedium.copyWith(
                    color: Colors.white,
                    fontSize: 28,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  recipe['subtitle'] as String,
                  style: AppTheme.bodySmall.copyWith(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: AppTheme.softShadow,
                      ),
                      child: Text(
                        'Start Cooking',
                        style: AppTheme.labelLarge.copyWith(
                          color: AppTheme.primaryGreen,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.bookmark_border_rounded, color: Colors.white, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDailyBalance() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Balance', style: AppTheme.headlineLarge.copyWith(fontSize: 20)),
          const SizedBox(height: 20),
          _buildProgressBar('Proteins', 0.64, AppTheme.proteinColor, '64%'),
          const SizedBox(height: 16),
          _buildProgressBar('Fiber', 0.82, AppTheme.accentTeal, '82%'),
          const SizedBox(height: 16),
          _buildProgressBar('Carbs', 0.45, AppTheme.carbsColor, '45%'),
          const SizedBox(height: 16),
          _buildProgressBar('Fat', 0.38, AppTheme.fatColor, '38%'),
        ],
      ),
    );
  }

  Widget _buildProgressBar(
      String label, double value, Color color, String percentage) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w500, color: AppTheme.textPrimary)),
            Text(
              percentage,
              style: AppTheme.labelLarge.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: value),
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeOutCubic,
          builder: (context, val, _) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: val,
                backgroundColor: color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation(color),
                minHeight: 8,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMoodSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Explore by Mood', style: AppTheme.headlineLarge.copyWith(fontSize: 20)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _moodChips.map((chip) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceGreen.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.accentMint.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(chip['icon'] as IconData, size: 16, color: AppTheme.primaryGreen),
                    const SizedBox(width: 6),
                    Text(
                      chip['label'] as String,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.primaryGreenDark,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recommended for you',
                  style: AppTheme.headlineLarge.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  'Based on your metabolic profile',
                  style: AppTheme.bodySmall.copyWith(fontSize: 13),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                'View All',
                style: AppTheme.labelLarge.copyWith(
                  color: AppTheme.primaryGreen,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.82,
          ),
          itemCount: _recommendedRecipes.length,
          itemBuilder: (context, index) {
            final recipe = _recommendedRecipes[index];
            return _buildRecipeCard(recipe, index);
          },
        ),
      ],
    );
  }

  Widget _buildRecipeCard(Map<String, dynamic> recipe, int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder with gradient
          Container(
            height: 110,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (recipe['color'] as Color).withValues(alpha: 0.8),
                  (recipe['color'] as Color),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.restaurant_rounded,
                size: 40,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe['name'] as String,
                  style: AppTheme.titleMedium.copyWith(fontSize: 13),
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
                      recipe['cal'] as String,
                      style: AppTheme.bodySmall.copyWith(fontSize: 11),
                    ),
                    const SizedBox(width: 10),
                    Icon(Icons.schedule_rounded,
                        size: 14, color: AppTheme.textTertiary),
                    const SizedBox(width: 4),
                    Text(
                      recipe['time'] as String,
                      style: AppTheme.bodySmall.copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: (100 * index).ms, duration: 400.ms)
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.0, 1.0),
          delay: (100 * index).ms,
          duration: 400.ms,
        );
  }
}
