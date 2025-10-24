import 'package:flutter/material.dart';

class AppColors {
  // Colores principales - Paleta azul suave y amigable
  static const Color primary = Color(0xFF4A90E2); // Azul suave y confiable
  static const Color secondary = Color(0xFF87CEEB); // Azul claro y relajante
  static const Color accent = Color(0xFF7ED321); // Verde menta fresco
  
  // Colores de superficie - Modo Claro
  static const Color surfaceLight = Color(0xFFFAFAFA); // Blanco cálido
  static const Color backgroundLight = Color(0xFFF8F9FA); // Gris muy claro
  static const Color cardLight = Color(0xFFFFFFFF); // Blanco para tarjetas
  
  // Colores de superficie - Modo Oscuro
  static const Color surfaceDark = Color(0xFF1E1E1E); // Negro suave
  static const Color backgroundDark = Color(0xFF121212); // Negro profundo
  static const Color cardDark = Color(0xFF2D2D2D); // Gris oscuro para tarjetas
  
  // Colores de texto - Modo Claro
  static const Color textPrimaryLight = Color(0xFF2C3E50); // Gris oscuro suave
  static const Color textSecondaryLight = Color(0xFF7F8C8D); // Gris medio
  static const Color textLightLight = Color(0xFFBDC3C7); // Gris claro
  
  // Colores de texto - Modo Oscuro
  static const Color textPrimaryDark = Color(0xFFE8E8E8); // Blanco suave
  static const Color textSecondaryDark = Color(0xFFB0B0B0); // Gris claro
  static const Color textLightDark = Color(0xFF808080); // Gris medio
  
  // Colores de estado (funcionan en ambos modos)
  static const Color success = Color(0xFF27AE60); // Verde suave
  static const Color warning = Color(0xFFF39C12); // Naranja suave
  static const Color error = Color(0xFFE74C3C); // Rojo suave
  static const Color info = Color(0xFF3498DB); // Azul información
  
  // Colores de interacción - Modo Claro
  static const Color hoverLight = Color(0xFFE8F4FD); // Azul muy claro para hover
  static const Color selectedLight = Color(0xFFD6EAF8); // Azul claro para selección
  static const Color borderLight = Color(0xFFE1E8ED); // Borde suave
  
  // Colores de interacción - Modo Oscuro
  static const Color hoverDark = Color(0xFF2A3A4A); // Azul oscuro para hover
  static const Color selectedDark = Color(0xFF1A2A3A); // Azul muy oscuro para selección
  static const Color borderDark = Color(0xFF404040); // Borde oscuro
}

class AppTheme {
  // Cache de temas para evitar recreaciones
  static ThemeData? _cachedLightTheme;
  static ThemeData? _cachedDarkTheme;
  
  static ThemeData get lightTheme {
    _cachedLightTheme ??= _buildLightTheme();
    return _cachedLightTheme!;
  }
  
  static ThemeData get darkTheme {
    _cachedDarkTheme ??= _buildDarkTheme();
    return _cachedDarkTheme!;
  }
  
  static ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,

      // AppBar optimizado para modo claro
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.cardLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.cardLight,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Card theme optimizado para modo claro
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 2,
        shadowColor: AppColors.textLightLight.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // FloatingActionButton optimizado para modo claro
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.cardLight,
        elevation: 4,
      ),

      // Text theme optimizado para modo claro
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: AppColors.textPrimaryLight),
        bodyMedium: TextStyle(color: AppColors.textSecondaryLight),
        bodySmall: TextStyle(color: AppColors.textLightLight),
      ),

      // Input decoration optimizado para modo claro
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Elevated button optimizado para modo claro
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.cardLight,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Chip theme para modo claro
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundLight,
        selectedColor: AppColors.selectedLight,
        labelStyle: const TextStyle(
          color: AppColors.textPrimaryLight,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
    );
  }
  
  static ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // AppBar optimizado para modo oscuro
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.cardDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: AppColors.cardDark,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Card theme optimizado para modo oscuro
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),

      // FloatingActionButton optimizado para modo oscuro
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.cardDark,
        elevation: 4,
      ),

      // Text theme optimizado para modo oscuro
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: AppColors.textPrimaryDark),
        bodyMedium: TextStyle(color: AppColors.textSecondaryDark),
        bodySmall: TextStyle(color: AppColors.textLightDark),
      ),

      // Input decoration optimizado para modo oscuro
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Elevated button optimizado para modo oscuro
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.cardDark,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),

      // Chip theme para modo oscuro
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.backgroundDark,
        selectedColor: AppColors.selectedDark,
        labelStyle: const TextStyle(
          color: AppColors.textPrimaryDark,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
    );
  }
}
