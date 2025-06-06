import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFFD700); // Amarillo dorado
  static const Color secondary = Color(0xFFFFF59D); // Amarillo claro
  static const Color accent = Color(0xFFFFE082); // Amarillo suave
  // static const Color dark = Color(0xFF212121);
  static const Color dark = Color(0xFF000000); // Negro suave
  static const Color darkGrey = Color(0xFF424242);
  static const Color light = Color(0xFFFFFFFF); // Blanco
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFF44336);
  static const Color warning = Color(0xFFFF9800);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.light,
        onSurface: AppColors.dark,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.dark,
        foregroundColor: AppColors.light,
        elevation: 0,
        centerTitle: true,
      ),

      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.dark,
      ),

      cardTheme: CardTheme(
        color: AppColors.light,
        elevation: 4,
        shadowColor: AppColors.dark.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightGrey,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(color: AppColors.dark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
