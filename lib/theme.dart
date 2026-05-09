import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // CSS Variables mapped
  static const Color bgMain = Color(0xFF0B0E14);
  static const Color bgCard = Color(0xFF15181F);
  static const Color bgInput = Color(0xFF1A1D24);
  static const Color textMain = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF8A8D93);
  static const Color themeGreen = Color(0xFF34C759);
  static const Color borderColor = Color(0xFF23272F);
  static const Color danger = Color(0xFFFF3B30);

  // Global Theme config
  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgMain,
    primaryColor: themeGreen,
    colorScheme: const ColorScheme.dark(
      primary: themeGreen,
      surface: bgMain,
      onSurface: textMain,
      error: danger,
    ),
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: textMain,
      displayColor: textMain,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: bgMain,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: textMain),
      titleTextStyle: TextStyle(
        color: textMain,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    cardTheme: CardThemeData(
      color: bgCard,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: borderColor),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: themeGreen,
      foregroundColor: Colors.black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: bgInput,
      hintStyle: const TextStyle(color: textMuted),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: themeGreen),
      ),
    ),
  );
}
