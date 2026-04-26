import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_theme.dart';
import 'main_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _navigateToHome();
  }

  void _navigateToHome() async {
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (_, __, ___) => const MainNavigation(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
        ),
      );
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1B4332),
              Color(0xFF2D6A4F),
              Color(0xFF40916C),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background circles decoration
            Positioned(
              top: -80,
              right: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                  duration: 2000.ms,
                  curve: Curves.easeOut,
                )
                .fadeIn(duration: 1000.ms),
            Positioned(
              bottom: -100,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1.0, 1.0),
                  duration: 2000.ms,
                  delay: 300.ms,
                  curve: Curves.easeOut,
                )
                .fadeIn(duration: 1000.ms),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            )
                .animate()
                .scale(
                  begin: const Offset(0.3, 0.3),
                  end: const Offset(1.0, 1.0),
                  duration: 1800.ms,
                  delay: 500.ms,
                  curve: Curves.easeOut,
                )
                .fadeIn(duration: 800.ms),

            // Main Content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        size: 48,
                        color: AppTheme.primaryGreen,
                      ),
                    ),
                  )
                      .animate()
                      .scale(
                        begin: const Offset(0.0, 0.0),
                        end: const Offset(1.0, 1.0),
                        duration: 800.ms,
                        curve: Curves.elasticOut,
                      )
                      .fadeIn(duration: 400.ms),

                  const SizedBox(height: 28),

                  // App Name
                  Text(
                    'NutriSync',
                    style: AppTheme.displayLarge.copyWith(
                      color: Colors.white,
                      fontSize: 38,
                      letterSpacing: -1,
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: 400.ms,
                        duration: 600.ms,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        delay: 400.ms,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 8),

                  Text(
                    'AI-Powered Nutrition',
                    style: AppTheme.bodyLarge.copyWith(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 16,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: 700.ms,
                        duration: 600.ms,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0,
                        delay: 700.ms,
                        duration: 600.ms,
                        curve: Curves.easeOut,
                      ),

                  const SizedBox(height: 60),

                  // Loading indicator
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withValues(alpha: 0.6),
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: 1200.ms,
                        duration: 500.ms,
                      )
                      .scale(
                        begin: const Offset(0.5, 0.5),
                        end: const Offset(1.0, 1.0),
                        delay: 1200.ms,
                        duration: 500.ms,
                      ),
                ],
              ),
            ),

            // Bottom tagline
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Text(
                'Sync your ingredients. Discover recipes.',
                textAlign: TextAlign.center,
                style: AppTheme.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              )
                  .animate()
                  .fadeIn(delay: 1500.ms, duration: 800.ms),
            ),
          ],
        ),
      ),
    );
  }
}
