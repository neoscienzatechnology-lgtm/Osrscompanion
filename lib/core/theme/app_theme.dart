import 'package:flutter/material.dart';

class AppTheme {
  // OSRS-inspired color scheme
  static const Color osrsGold = Color(0xFFFFD700);
  static const Color osrsDarkBrown = Color(0xFF2C1810);
  static const Color osrsBrown = Color(0xFF4A3728);
  static const Color osrsLightBrown = Color(0xFF6B4E3D);
  static const Color osrsStone = Color(0xFF5C5C5C);
  static const Color osrsLightGold = Color(0xFFFFF4CC);
  static const Color osrsRed = Color(0xFFDC143C);
  static const Color osrsGreen = Color(0xFF228B22);
  
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: osrsGold,
        secondary: osrsLightGold,
        surface: osrsDarkBrown,
        background: Color(0xFF1A1410),
        onPrimary: osrsDarkBrown,
        onSecondary: osrsDarkBrown,
        onSurface: osrsLightGold,
        onBackground: osrsLightGold,
        error: osrsRed,
      ),
      
      // App bar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: osrsBrown,
        foregroundColor: osrsGold,
        elevation: 4,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: osrsGold,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Card theme
      cardTheme: CardTheme(
        color: osrsBrown,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: osrsGold, width: 1),
        ),
      ),
      
      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: osrsGold,
          foregroundColor: osrsDarkBrown,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: osrsGold,
        ),
      ),
      
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: osrsLightBrown,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: osrsGold),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: osrsLightGold),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: osrsGold, width: 2),
        ),
        labelStyle: const TextStyle(color: osrsLightGold),
        hintStyle: TextStyle(color: osrsLightGold.withOpacity(0.6)),
      ),
      
      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: osrsBrown,
        selectedColor: osrsGold,
        labelStyle: const TextStyle(color: osrsLightGold),
        side: const BorderSide(color: osrsGold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      
      // List tile theme
      listTileTheme: const ListTileThemeData(
        textColor: osrsLightGold,
        iconColor: osrsGold,
      ),
      
      // Icon theme
      iconTheme: const IconThemeData(
        color: osrsGold,
      ),
      
      // Text theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: osrsGold, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: osrsGold, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: osrsGold, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: osrsGold, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: osrsGold, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(color: osrsGold),
        titleLarge: TextStyle(color: osrsLightGold, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: osrsLightGold, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: osrsLightGold),
        bodyLarge: TextStyle(color: osrsLightGold),
        bodyMedium: TextStyle(color: osrsLightGold),
        bodySmall: TextStyle(color: osrsLightGold),
      ),
      
      // Floating action button theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: osrsGold,
        foregroundColor: osrsDarkBrown,
      ),
      
      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: osrsBrown,
        selectedItemColor: osrsGold,
        unselectedItemColor: osrsLightGold,
      ),
      
      // Scaffold background
      scaffoldBackgroundColor: const Color(0xFF1A1410),
    );
  }
  
  static ThemeData get lightTheme {
    // Light theme for optional use
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: osrsGold,
        secondary: osrsBrown,
      ),
    );
  }
}
