import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Brand Colors ───────────────────────────────────────────────
  static const Color primaryGreen = Color(0xFF2D6A4F);
  static const Color primaryGreenLight = Color(0xFF40916C);
  static const Color primaryGreenDark = Color(0xFF1B4332);
  static const Color accentTeal = Color(0xFF52B788);
  static const Color accentMint = Color(0xFF95D5B2);
  static const Color surfaceGreen = Color(0xFFD8F3DC);
  static const Color backgroundWhite = Color(0xFFFAFAFA);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color dividerColor = Color(0xFFE5E7EB);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color warningAmber = Color(0xFFF59E0B);
  static const Color infoBlue = Color(0xFF3B82F6);

  // Nutrition Colors
  static const Color proteinColor = Color(0xFF2D6A4F);
  static const Color carbsColor = Color(0xFFF59E0B);
  static const Color fatColor = Color(0xFFEF4444);
  static const Color fiberColor = Color(0xFF8B5CF6);
  static const Color calorieColor = Color(0xFFEC6E30);

  // ─── Gradients ──────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryGreen, accentTeal],
  );

  static const LinearGradient subtleGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF0FFF4)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF7FDF9)],
  );

  // ─── Shadows ────────────────────────────────────────────────────
  static List<BoxShadow> get softShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get mediumShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 24,
          offset: const Offset(0, 8),
          spreadRadius: -2,
        ),
      ];

  static List<BoxShadow> get greenGlow => [
        BoxShadow(
          color: primaryGreen.withOpacity(0.3),
          blurRadius: 20,
          offset: const Offset(0, 6),
          spreadRadius: -4,
        ),
      ];

  // ─── Border Radius ──────────────────────────────────────────────
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;
  static const double radiusRound = 50.0;

  // ─── Typography ─────────────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.plusJakartaSans(
        fontSize: 32,
        fontWeight: FontWeight.w800,
        color: textPrimary,
        letterSpacing: -0.5,
        height: 1.2,
      );

  static TextStyle get displayMedium => GoogleFonts.plusJakartaSans(
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.3,
        height: 1.25,
      );

  static TextStyle get headlineLarge => GoogleFonts.plusJakartaSans(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        height: 1.3,
      );

  static TextStyle get headlineMedium => GoogleFonts.plusJakartaSans(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.35,
      );

  static TextStyle get titleMedium => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        height: 1.4,
      );

  static TextStyle get bodyLarge => GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      );

  static TextStyle get bodyMedium => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        height: 1.5,
      );

  static TextStyle get bodySmall => GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textTertiary,
        height: 1.4,
      );

  static TextStyle get labelLarge => GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        color: textTertiary,
        letterSpacing: 1.2,
      );

  static TextStyle get accentItalic => GoogleFonts.playfairDisplay(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        fontStyle: FontStyle.italic,
        color: primaryGreen,
        height: 1.2,
      );

  // ─── Theme Data ─────────────────────────────────────────────────
  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: backgroundWhite,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          secondary: accentTeal,
          surface: cardWhite,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: false,
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: primaryGreen,
          ),
          iconTheme: const IconThemeData(color: textPrimary),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusLarge),
          ),
          color: cardWhite,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radiusMedium),
            ),
            textStyle: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            borderSide: const BorderSide(color: primaryGreen, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: textTertiary,
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: primaryGreen,
          unselectedItemColor: textTertiary,
          type: BottomNavigationBarType.fixed,
          elevation: 0,
        ),
      );
}
