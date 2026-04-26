import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../theme/app_theme.dart';
import '../models/recipe_model.dart';
import '../services/api_service.dart';
import 'recipe_detail_screen.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen>
    with TickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();
  final List<IngredientItem> _addedIngredients = [];
  final ApiService _apiService = ApiService();

  // Speech to Text
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _speechText = '';

  // Animation controllers
  late AnimationController _micPulseController;
  late AnimationController _loadingController;

  bool _isGenerating = false;
  bool _speechInitialized = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _micPulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    _speechInitialized = await _speech.initialize(
      onError: (error) {
        // Only stop on critical errors, not on silence
        if (error.errorMsg != 'error_speech_timeout' &&
            error.errorMsg != 'error_no_match') {
          if (mounted) {
            setState(() => _isListening = false);
            _micPulseController.stop();
          }
        }
      },
      onStatus: (status) {
        // Do NOT stop on 'done' or 'notListening' — user controls the mic
        // We only reflect the state if the OS truly kills the session (e.g. phone call)
        if (status == 'notListening' && _isListening) {
          // Re-listen to keep session alive while user hasn't tapped stop
          if (_speechInitialized && _isListening) {
            _restartListening();
          }
        }
      },
    );
  }

  /// Restarts listening without changing the UI state, to keep mic alive.
  void _restartListening() {
    if (!_isListening || !_speechInitialized) return;
    _speech.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _speechText = result.recognizedWords;
            _textController.text = _speechText;
          });
        }
      },
      listenFor: const Duration(seconds: 60),
      pauseFor: const Duration(seconds: 20),
      cancelOnError: false,
    );
  }

  Future<void> _startListening() async {
    if (!_speechInitialized) {
      _initSpeech();
      return;
    }
    setState(() {
      _isListening = true;
      _speechText = '';
    });
    _micPulseController.repeat(reverse: true);
    HapticFeedback.mediumImpact();

    _speech.listen(
      onResult: (result) {
        if (mounted) {
          setState(() {
            _speechText = result.recognizedWords;
            _textController.text = _speechText;
          });
        }
      },
      listenFor: const Duration(seconds: 120),
      pauseFor: const Duration(seconds: 20),
      cancelOnError: false,
    );
  }

  void _stopListening() {
    _speech.stop();
    _micPulseController.stop();
    final text = _textController.text.trim();
    if (mounted) {
      setState(() {
        _isListening = false;
        _speechText = '';
      });
    }
    HapticFeedback.lightImpact();
    // Automatically add what was spoken as an ingredient
    if (text.isNotEmpty) {
      _addIngredientsFromText(text);
      _textController.clear();
    }
  }

  void _addIngredient() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;
    _addIngredientsFromText(text);
    _textController.clear();
    _speechText = '';
    HapticFeedback.lightImpact();
  }

  void _addIngredientsFromText(String text) {
    final items = text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty);
    setState(() {
      for (final item in items) {
        _addedIngredients.add(IngredientItem(
          name: item,
          category: _guessCategory(item),
          estimatedCalories: _estimateCalories(item),
        ));
      }
    });
  }

  String _guessCategory(String item) {
    final lower = item.toLowerCase();
    if (['chicken', 'beef', 'fish', 'egg', 'salmon', 'shrimp', 'turkey', 'pork', 'lamb', 'protein', 'powder']
        .any((e) => lower.contains(e))) return 'Proteins';
    if (['rice', 'bread', 'pasta', 'noodle', 'oat', 'wheat', 'flour']
        .any((e) => lower.contains(e))) return 'Carbs';
    if (['tomato', 'onion', 'garlic', 'pepper', 'carrot', 'broccoli', 'spinach', 'lettuce']
        .any((e) => lower.contains(e))) return 'Vegetables';
    if (['apple', 'banana', 'mango', 'berry', 'orange', 'lemon', 'honey']
        .any((e) => lower.contains(e))) return 'Fruits';
    if (['oil', 'butter', 'cheese', 'cream', 'milk', 'yogurt']
        .any((e) => lower.contains(e))) return 'Dairy/Fats';
    return 'Other';
  }

  double _estimateCalories(String item) {
    final lower = item.toLowerCase();
    if (lower.contains('chicken')) return 239;
    if (lower.contains('egg')) return 155;
    if (lower.contains('rice')) return 130;
    if (lower.contains('bread')) return 265;
    if (lower.contains('salmon')) return 208;
    if (lower.contains('milk')) return 42;
    if (lower.contains('cheese')) return 402;
    if (lower.contains('tomato')) return 18;
    if (lower.contains('onion')) return 40;
    if (lower.contains('banana')) return 89;
    if (lower.contains('honey')) return 304;
    return 50;
  }

  void _removeIngredient(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _addedIngredients.removeAt(index);
    });
  }

  Future<void> _generateRecipe() async {
    if (_addedIngredients.isEmpty) {
      _showSnackBar('Please add at least one ingredient');
      return;
    }

    setState(() => _isGenerating = true);
    _loadingController.repeat();

    try {
      final request = RecipeRequest(
        ingredients: _addedIngredients.map((e) => e.name).toList(),
        dietaryPreferences: null,
      );

      final response = await _apiService.generateRecipe(request);

      if (mounted) {
        Navigator.of(context).push(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => RecipeDetailScreen(recipe: response),
            transitionsBuilder: (_, animation, __, child) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                )),
                child: child,
              );
            },
          ),
        );
      }
    } on ApiException catch (e) {
      _showSnackBar('Error: ${e.message}');
    } catch (e) {
      _showSnackBar('Failed to connect. Please check the backend is running.');
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
        _loadingController.stop();
        _loadingController.reset();
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTheme.bodyMedium.copyWith(color: Colors.white)),
        backgroundColor: AppTheme.primaryGreenDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Proteins':
        return Icons.egg_rounded;
      case 'Carbs':
        return Icons.bakery_dining_rounded;
      case 'Vegetables':
        return Icons.eco_rounded;
      case 'Fruits':
        return Icons.apple;
      case 'Dairy/Fats':
        return Icons.water_drop_rounded;
      default:
        return Icons.restaurant_rounded;
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _micPulseController.dispose();
    _loadingController.dispose();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundWhite,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // ── App Bar ──────────────────────────────────────────────
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
                    gradient: AppTheme.primaryGradient,
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
                  icon: const Icon(Icons.notifications_none_rounded, size: 22),
                  color: AppTheme.textPrimary,
                  onPressed: () {},
                ),
              ),
            ],
          ),

          // ── Body ─────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),

                  // ── Heading ─────────────────────────────────────
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Tell us what's in\nyour ",
                          style: AppTheme.displayLarge.copyWith(fontSize: 28),
                        ),
                        TextSpan(
                          text: 'pantry.',
                          style: AppTheme.accentItalic.copyWith(fontSize: 28),
                        ),
                      ],
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 500.ms)
                      .slideX(begin: -0.05, end: 0, duration: 500.ms),

                  const SizedBox(height: 8),
                  Text(
                    'Speak naturally or type your ingredients\nto sync your nutrition profile.',
                    style: AppTheme.bodyMedium.copyWith(height: 1.6),
                  ).animate().fadeIn(delay: 100.ms, duration: 500.ms),

                  const SizedBox(height: 28),

                  // ── Microphone Section ───────────────────────────
                  _buildMicSection()
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 600.ms),

                  const SizedBox(height: 28),

                  // ── Manual Entry Heading ─────────────────────────
                  Text(
                    'Manual Entry',
                    style: AppTheme.headlineLarge.copyWith(fontSize: 18),
                  ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

                  const SizedBox(height: 12),

                  // ── Text Input ───────────────────────────────────
                  _buildTextInput()
                      .animate()
                      .fadeIn(delay: 350.ms, duration: 500.ms)
                      .slideY(begin: 0.05, end: 0, delay: 350.ms, duration: 500.ms),

                  const SizedBox(height: 14),

                  // ── Add Ingredient Button ────────────────────────
                  _buildAddButton()
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 500.ms)
                      .scale(
                        begin: const Offset(0.95, 0.95),
                        end: const Offset(1.0, 1.0),
                        delay: 400.ms,
                        duration: 400.ms,
                      ),

                  const SizedBox(height: 28),

                  // ── Ingredients List ─────────────────────────────
                  if (_addedIngredients.isNotEmpty) ...[
                    Row(
                      children: [
                        Text(
                          'Your Ingredients',
                          style: AppTheme.headlineLarge.copyWith(fontSize: 18),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.surfaceGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_addedIngredients.length} items',
                            style: AppTheme.bodySmall.copyWith(
                              color: AppTheme.primaryGreen,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    ..._addedIngredients.asMap().entries.map((entry) {
                      return _buildIngredientTile(entry.value, entry.key)
                          .animate()
                          .fadeIn(duration: 300.ms)
                          .slideX(begin: 0.1, end: 0, duration: 300.ms);
                    }),
                    const SizedBox(height: 24),

                    // ── Generate Recipe Button ───────────────────
                    _buildGenerateButton(),
                  ],

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── MIC SECTION ────────────────────────────────────────────────────
  Widget _buildMicSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: _isListening
            ? AppTheme.surfaceGreen.withOpacity(0.5)
            : const Color(0xFFF5F5F0),
        borderRadius: BorderRadius.circular(24),
        border: _isListening
            ? Border.all(color: AppTheme.accentMint, width: 1.5)
            : null,
      ),
      child: Column(
        children: [
          // Mic button with pulse ring
          GestureDetector(
            onTap: _isListening ? _stopListening : _startListening,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer pulse ring (only when listening)
                if (_isListening)
                  AnimatedBuilder(
                    animation: _micPulseController,
                    builder: (context, child) {
                      return Container(
                        width: 90 + (_micPulseController.value * 24),
                        height: 90 + (_micPulseController.value * 24),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppTheme.primaryGreen
                              .withOpacity(0.12 * (1 - _micPulseController.value)),
                        ),
                      );
                    },
                  ),
                // Mic circle
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: _isListening
                        ? AppTheme.errorRed
                        : AppTheme.primaryGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (_isListening
                                ? AppTheme.errorRed
                                : AppTheme.primaryGreen)
                            .withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Icon(
                    _isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _isListening ? 'Listening...' : 'Tap to Speak',
            style: AppTheme.titleMedium.copyWith(
              color: _isListening ? AppTheme.primaryGreen : AppTheme.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isListening
                ? (_speechText.isEmpty
                    ? 'Say your ingredients...'
                    : _speechText)
                : 'Tap mic, speak, then tap again to add',
            style: AppTheme.bodySmall.copyWith(
              color: _isListening
                  ? AppTheme.primaryGreenLight
                  : AppTheme.textTertiary,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
          ),
          // Live recognised text preview when listening
          if (_isListening && _speechText.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppTheme.primaryGreen.withOpacity(0.3)),
              ),
              child: Text(
                '"$_speechText"',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.textPrimary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ── TEXT INPUT ──────────────────────────────────────────────────────
  Widget _buildTextInput() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.dividerColor.withOpacity(0.4)),
      ),
      child: TextField(
        controller: _textController,
        maxLines: 2,
        style: AppTheme.bodyMedium.copyWith(color: AppTheme.textPrimary),
        decoration: InputDecoration(
          hintText: 'e.g. 2 large avocados, 500g chicken breast...',
          hintStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textTertiary,
            fontSize: 14,
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.all(16),
        ),
        onSubmitted: (_) => _addIngredient(),
      ),
    );
  }

  // ── ADD INGREDIENT BUTTON ───────────────────────────────────────────
  Widget _buildAddButton() {
    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: _addIngredient,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: AppTheme.surfaceGreen,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppTheme.primaryGreen.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppTheme.primaryGreen,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Add Ingredient',
                style: AppTheme.titleMedium.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── INGREDIENT TILE ─────────────────────────────────────────────────
  Widget _buildIngredientTile(IngredientItem item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.softShadow,
        border: Border.all(color: AppTheme.dividerColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppTheme.surfaceGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getCategoryIcon(item.category ?? 'Other'),
              color: AppTheme.primaryGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTheme.titleMedium.copyWith(fontSize: 14),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.category ?? "Other"} • ${item.estimatedCalories?.toInt() ?? 0} kcal est.',
                  style: AppTheme.bodySmall.copyWith(fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _removeIngredient(index),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_outline_rounded,
                  color: AppTheme.errorRed, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  // ── GENERATE BUTTON ─────────────────────────────────────────────────
  Widget _buildGenerateButton() {
    return GestureDetector(
      onTap: _isGenerating ? null : _generateRecipe,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: _isGenerating ? null : AppTheme.primaryGradient,
          color: _isGenerating ? AppTheme.textTertiary : null,
          borderRadius: BorderRadius.circular(18),
          boxShadow: _isGenerating ? [] : AppTheme.greenGlow,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isGenerating) ...[
              SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation(Colors.white.withOpacity(0.8)),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Generating Recipe...',
                style: AppTheme.titleMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ] else ...[
              const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 22),
              const SizedBox(width: 10),
              Text(
                'Generate AI Recipe',
                style: AppTheme.titleMedium.copyWith(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms, duration: 500.ms)
        .slideY(begin: 0.1, end: 0, delay: 200.ms, duration: 500.ms);
  }
}
