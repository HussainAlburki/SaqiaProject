import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const teal = Color(0xFF0D9488);
  static const cream = Color(0xFFFAF8F5);
  static const terracotta = Color(0xFFE07A5F);

  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: cream,
      colorScheme: const ColorScheme.light(
        primary: teal,
        secondary: Color(0xFF12B3A4),
        surface: Colors.white,
        error: terracotta,
      ),
      textTheme: GoogleFonts.dmSansTextTheme(base.textTheme).copyWith(
        displaySmall: GoogleFonts.outfit(fontSize: 34, fontWeight: FontWeight.w700, letterSpacing: -0.6),
        headlineMedium: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.w700, letterSpacing: -0.4),
        titleLarge: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.2),
        titleMedium: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.dmSans(fontSize: 15, fontWeight: FontWeight.w500),
        bodyMedium: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 0.7,
        shadowColor: Colors.black12,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          backgroundColor: teal,
          foregroundColor: Colors.white,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: teal.withValues(alpha: 0.14),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.dmSans(
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? teal : Colors.black54,
          ),
        ),
      ),
    );
  }
}
