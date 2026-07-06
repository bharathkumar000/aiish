import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand colors from web globals.css
  static const Color primary = Color(0xFFFFB347);
  static const Color primaryDark = Color(0xFFFF9B1A);
  static const Color secondary = Color(0xFF77DD77);
  static const Color secondaryDark = Color(0xFF5EC45E);

  // Pastels
  static const Color pastelPeach = Color(0xFFFFDAB9);
  static const Color pastelGreen = Color(0xFFB4E197);
  static const Color pastelBlue = Color(0xFFAEC6CF);
  static const Color pastelPink = Color(0xFFFFB7B2);
  static const Color pastelYellow = Color(0xFFFDFD96);
  static const Color headerBlue = Color(0xFFC5D4E1);

  // Background and Text
  static const Color bgPrimary = Color(0xFFF8F1E5); // Sand / Light Beige
  static const Color textMain = Color(0xFF4A4036);
  static const Color textMuted = Color(0xFF8B7355);
  static const Color errorRed = Color(0xFFFF6961);
  static const Color borderDark = Color(0xFF4A4036);

  // Solid 3D Claymorphic BoxShadow
  static List<BoxShadow> clayShadow({double offsetY = 6.0}) => [
    BoxShadow(
      color: borderDark,
      offset: Offset(0, offsetY),
      blurRadius: 0,
    ),
  ];

  static TextStyle get font => GoogleFonts.fredoka(
    color: textMain,
    fontWeight: FontWeight.bold,
  );

  static ThemeData get themeData {
    final baseTextTheme = GoogleFonts.fredokaTextTheme();
    return ThemeData(
      scaffoldBackgroundColor: bgPrimary,
      primaryColor: primary,
      textTheme: baseTextTheme.apply(
        bodyColor: textMain,
        displayColor: textMain,
      ),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        surface: bgPrimary,
      ),
      useMaterial3: true,
    );
  }
}
