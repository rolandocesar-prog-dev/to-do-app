import 'package:flutter/material.dart';

class AppColors {
  // Colores principales - Paleta azul suave y amigable
  static const Color primary = Color(0xFF4A90E2); // Azul suave y confiable
  static const Color secondary = Color(0xFF87CEEB); // Azul claro y relajante
  static const Color accent = Color(0xFF7ED321); // Verde menta fresco
  
  // Colores de superficie
  static const Color surface = Color(0xFFFAFAFA); // Blanco cálido
  static const Color background = Color(0xFFF8F9FA); // Gris muy claro
  static const Color card = Color(0xFFFFFFFF); // Blanco para tarjetas
  
  // Colores de texto
  static const Color textPrimary = Color(0xFF2C3E50); // Gris oscuro suave
  static const Color textSecondary = Color(0xFF7F8C8D); // Gris medio
  static const Color textLight = Color(0xFFBDC3C7); // Gris claro
  
  // Colores de estado
  static const Color success = Color(0xFF27AE60); // Verde suave
  static const Color warning = Color(0xFFF39C12); // Naranja suave
  static const Color error = Color(0xFFE74C3C); // Rojo suave
  static const Color info = Color(0xFF3498DB); // Azul información
  
  // Colores de interacción
  static const Color hover = Color(0xFFE8F4FD); // Azul muy claro para hover
  static const Color selected = Color(0xFFD6EAF8); // Azul claro para selección
  static const Color border = Color(0xFFE1E8ED); // Borde suave
}

class AppTheme {
  // Cache del tema para evitar recreaciones
  static ThemeData? _cachedTheme;
  
  static ThemeData get theme {
    _cachedTheme ??= _buildTheme();
    return _cachedTheme!;
  }
  
  static ThemeData _buildTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,

      // AppBar más suave y amigable
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.card,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),

      // FloatingActionButton más suave
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.card,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Tarjetas más suaves y amigables
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 2,
        shadowColor: AppColors.primary.withAlpha(20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),

      // Chips más amigables
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.background,
        selectedColor: AppColors.selected,
        labelStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.border),
        ),
      ),

      // Botones más suaves
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.card,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Input fields más amigables
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.background,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Textos más legibles
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          color: AppColors.textLight,
        ),
      ),
    );
  }
}
