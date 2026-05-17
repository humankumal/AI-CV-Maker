import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextTheme textTheme(Brightness brightness) {
    final TextTheme base = brightness == Brightness.dark
        ? Typography.whiteMountainView
        : Typography.blackMountainView;
    return GoogleFonts.interTextTheme(base).copyWith(
      displayLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600, letterSpacing: -0.5),
      displayMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600, letterSpacing: -0.4),
      headlineMedium: GoogleFonts.inter(
          fontWeight: FontWeight.w600, letterSpacing: -0.3),
      titleLarge: GoogleFonts.inter(
          fontWeight: FontWeight.w600, letterSpacing: -0.2),
      bodyLarge: GoogleFonts.inter(fontWeight: FontWeight.w400, height: 1.45),
      bodyMedium: GoogleFonts.inter(fontWeight: FontWeight.w400, height: 1.45),
      labelLarge: GoogleFonts.inter(fontWeight: FontWeight.w500),
    );
  }
}
