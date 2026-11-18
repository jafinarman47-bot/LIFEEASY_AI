import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color bgDark = Color(0xFF05060A);
  static const Color surfaceDark = Color(0xFF131522);
  static const Color neonPurple = Color(0xFF9D4EDD);
  static const Color neonBlue = Color(0xFF00B4D8);
  static const Color neonPink = Color(0xFFF72585);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textMuted = Color(0xFF8B95A7);

  static const LinearGradient userBubbleGradient = LinearGradient(
    colors: [Color(0xFF3A0CA3), Color(0xFF7209B7)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sendButtonGradient = LinearGradient(
    colors: [neonBlue, neonPurple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: bgDark,
      colorScheme: const ColorScheme.dark(
        primary: neonPurple,
        secondary: neonBlue,
        surface: surfaceDark,
        onSurface: textPrimary,
      ),
      textTheme: GoogleFonts.outfitTextTheme(base.textTheme).apply(
        bodyColor: textPrimary,
        displayColor: textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
