// theme/admin_theme.dart
import 'package:flutter/material.dart';

class AdminTheme {
  // ==================== BRIGHT MODE COLORS ====================
  static const Color brightPrimary = Color(0xFFFFA500); // Orange
  static const Color brightSecondary = Color(0xFFFFD700); // Gold
  static const Color brightAccent = Color(0xFFFF8C00); // Dark Orange
  static const Color brightBackground = Color(0xFFFFFAF0); // Floral White
  static const Color brightSurface = Color(0xFFFFFFFF); // White
  static const Color brightTextPrimary = Color(0xFF2C2C2C); // Dark Grey
  static const Color brightTextSecondary = Color(0xFF666666); // Medium Grey
  static const Color brightError = Color(0xFFD32F2F); // Red
  static const Color brightSuccess = Color(0xFF388E3C); // Green
  static const Color brightWarning = Color(0xFFF57C00); // Orange
  static const Color brightCardBackground = Color(0xFFFFF8E1); // Light Yellow

  // ==================== DARK MODE COLORS ====================
  static const Color darkPrimary = Color(0xFFFFB347); // Light Orange
  static const Color darkSecondary = Color(0xFFFFD54F); // Light Gold
  static const Color darkAccent = Color(0xFFFFA726); // Medium Orange
  static const Color darkBackground = Color(0xFF1A1A1A); // Very Dark Grey
  static const Color darkSurface = Color(0xFF2C2C2C); // Dark Grey
  static const Color darkTextPrimary = Color(0xFFFFFAF0); // Light
  static const Color darkTextSecondary = Color(0xFFCCCCCC); // Light Grey
  static const Color darkError = Color(0xFFEF5350); // Light Red
  static const Color darkSuccess = Color(0xFF66BB6A); // Light Green
  static const Color darkWarning = Color(0xFFFFB74D); // Light Orange
  static const Color darkCardBackground = Color(0xFF3A3A3A); // Medium Dark Grey

  // ==================== BRIGHT THEME ====================
  static ThemeData get brightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color Scheme
      colorScheme: const ColorScheme.light(
        primary: brightPrimary,
        secondary: brightSecondary,
        surface: brightSurface,
        error: brightError,
        onPrimary: Colors.white,
        onSecondary: brightTextPrimary,
        onSurface: brightTextPrimary,
        onError: Colors.white,
      ),

      // Scaffold
      scaffoldBackgroundColor: brightBackground,

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: brightPrimary,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brightPrimary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: brightPrimary,
          side: const BorderSide(color: brightPrimary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: brightPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: brightSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: brightAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: brightAccent.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: brightPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: brightError),
        ),
        labelStyle: const TextStyle(color: brightTextSecondary),
        hintStyle: TextStyle(color: brightTextSecondary.withOpacity(0.6)),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: brightTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: brightTextPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: brightTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: brightTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: brightTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: brightTextPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: brightTextPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: brightTextSecondary),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: brightTextPrimary,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: brightPrimary, size: 24),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: brightPrimary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: brightTextSecondary.withOpacity(0.2),
        thickness: 1,
      ),

      // List Tile
      listTileTheme: const ListTileThemeData(
        textColor: brightTextPrimary,
        iconColor: brightPrimary,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return brightPrimary;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return brightPrimary.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return brightPrimary;
          }
          return null;
        }),
      ),
    );
  }

  // ==================== DARK THEME ====================
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: darkPrimary,
        secondary: darkSecondary,
        surface: darkSurface,
        error: darkError,
        onPrimary: darkTextPrimary,
        onSecondary: darkTextPrimary,
        onSurface: darkTextPrimary,
        onError: darkTextPrimary,
      ),

      // Scaffold
      scaffoldBackgroundColor: darkBackground,

      // App Bar
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: darkPrimary,
        elevation: 2,
        centerTitle: true,
        iconTheme: IconThemeData(color: darkPrimary),
        titleTextStyle: TextStyle(
          color: darkPrimary,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: darkTextPrimary,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimary,
          side: const BorderSide(color: darkPrimary, width: 2),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: darkPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: darkAccent.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: darkError),
        ),
        labelStyle: const TextStyle(color: darkTextSecondary),
        hintStyle: TextStyle(color: darkTextSecondary.withOpacity(0.6)),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        displaySmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: darkTextPrimary,
        ),
        headlineMedium: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkTextPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkTextPrimary,
        ),
        bodyLarge: TextStyle(fontSize: 16, color: darkTextPrimary),
        bodyMedium: TextStyle(fontSize: 14, color: darkTextSecondary),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: darkTextPrimary,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(color: darkPrimary, size: 24),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkPrimary,
        foregroundColor: darkTextPrimary,
        elevation: 4,
      ),

      // Divider
      dividerTheme: DividerThemeData(
        color: darkTextSecondary.withOpacity(0.2),
        thickness: 1,
      ),

      // List Tile
      listTileTheme: const ListTileThemeData(
        textColor: darkTextPrimary,
        iconColor: darkPrimary,
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimary;
          }
          return Colors.grey;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimary.withOpacity(0.5);
          }
          return Colors.grey.withOpacity(0.3);
        }),
      ),

      // Checkbox
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return darkPrimary;
          }
          return null;
        }),
      ),
    );
  }
}
