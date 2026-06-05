import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Nim-siyohrang (dark slate) palette
  static const Color background = Color(0xFF0F1117);
  static const Color surface = Color(0xFF1A1D2E);
  static const Color surfaceVariant = Color(0xFF252840);
  static const Color cardBg = Color(0xFF1E2138);
  static const Color cardBorder = Color(0xFF2E3154);

  // Accent colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF8B84FF);
  static const Color secondary = Color(0xFF00D4AA);
  static const Color accent = Color(0xFFFF6584);

  // Level colors
  static const Color a1Color = Color(0xFF4CAF50);
  static const Color a2Color = Color(0xFF8BC34A);
  static const Color b1Color = Color(0xFF2196F3);
  static const Color b2Color = Color(0xFF9C27B0);
  static const Color c1Color = Color(0xFFFF9800);
  static const Color c2Color = Color(0xFFF44336);

  // Text
  static const Color textPrimary = Color(0xFFE8EAF6);
  static const Color textSecondary = Color(0xFF9FA8DA);
  static const Color textHint = Color(0xFF5C6BC0);

  // Status
  static const Color success = Color(0xFF00C853);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFD740);
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        background: AppColors.background,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onBackground: AppColors.textPrimary,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
          headlineLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          headlineSmall: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          titleLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: AppColors.textPrimary),
          bodyLarge: TextStyle(color: AppColors.textPrimary),
          bodyMedium: TextStyle(color: AppColors.textSecondary),
          labelLarge: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: const BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
      ),
    );
  }

  static Color getLevelColor(String level) {
    switch (level) {
      case 'A1': return AppColors.a1Color;
      case 'A2': return AppColors.a2Color;
      case 'B1': return AppColors.b1Color;
      case 'B2': return AppColors.b2Color;
      case 'C1': return AppColors.c1Color;
      case 'C2': return AppColors.c2Color;
      default: return AppColors.primary;
    }
  }
}
