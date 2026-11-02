import 'package:flutter/material.dart';

class AppTheme {
  // Brand colors
  static const Color primaryPurple = Color(0xFF6C5CE7);
  static const Color accentPink = Color(0xFFFF6584);
  static const Color accentTeal = Color(0xFF00B894);

  // Light theme colors
  static const Color lightBg = Color(0xFFF7F8FC);
  static const Color lightSurface = Colors.white;
  static const Color lightTextPrimary = Color(0xFF2D3436);
  static const Color lightTextSecondary = Color(0xFF636E72);

  // Dark theme colors
  static const Color darkBg = Color(0xFF0E1117);
  static const Color darkSurface = Color(0xFF1E2230);
  static const Color darkTextPrimary = Color(0xFFF1F2F6);
  static const Color darkTextSecondary = Color(0xFFA4B0BE);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryPurple,
        secondary: accentPink,
        tertiary: accentTeal,
        surface: lightSurface,
        onSurface: lightTextPrimary,
      ),
      scaffoldBackgroundColor: lightBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: lightTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 3,
        shadowColor: primaryPurple.withAlpha(25),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.black.withAlpha(12), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: primaryPurple, width: 1.8),
        ),
        hintStyle: const TextStyle(
          color: lightTextSecondary,
          fontSize: 14,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: const Color(0xFF9D85FF),
        secondary: accentPink,
        tertiary: accentTeal,
        surface: darkSurface,
        onSurface: darkTextPrimary,
      ),
      scaffoldBackgroundColor: darkBg,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: darkTextPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
        iconTheme: IconThemeData(color: darkTextPrimary),
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 4,
        shadowColor: Colors.black.withAlpha(120),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(color: Colors.white.withAlpha(18), width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.white.withAlpha(15), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF9D85FF), width: 1.8),
        ),
        hintStyle: const TextStyle(
          color: darkTextSecondary,
          fontSize: 14,
        ),
      ),
    );
  }
}
