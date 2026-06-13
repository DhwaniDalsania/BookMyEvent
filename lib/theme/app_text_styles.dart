import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Use Inter instead of Playfair Display for a simpler, professional look.

  static TextStyle get heroTitle => GoogleFonts.inter(
        fontSize: 48,
        fontWeight: FontWeight.bold,
        height: 1.1,
        letterSpacing: -1.0,
      );

  static TextStyle get sectionHeader => GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  static TextStyle get cardTitle => GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
      );

  static TextStyle get bodyCopy => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  static TextStyle get metadata => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  static TextStyle get button => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      );

  // Maintain standard heading getters for theme fallback but adjust sizes
  static TextStyle get h1 => heroTitle;
  static TextStyle get h2 => sectionHeader;
  static TextStyle get h3 => cardTitle;
  static TextStyle get bodyLarge => GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get bodyMedium => bodyCopy;
  static TextStyle get bodySmall => metadata;
}
