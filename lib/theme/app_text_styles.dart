import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Headings: Playfair Display
  // Hero titles: 64px, Playfair Display Bold (Scaled for streaming aesthetic)
  static TextStyle get heroTitle => GoogleFonts.playfairDisplay(
        fontSize: 64,
        fontWeight: FontWeight.bold,
        height: 1.1,
        letterSpacing: -1.0,
      );

  // Section headers: 32px, Playfair Display Italic
  static TextStyle get sectionHeader => GoogleFonts.playfairDisplay(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        fontStyle: FontStyle.italic,
        height: 1.2,
      );

  // Card titles: 24px, Playfair Display
  static TextStyle get cardTitle => GoogleFonts.playfairDisplay(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.2,
      );

  // Body: Inter
  // Body copy: 13-15px, Inter Regular
  static TextStyle get bodyCopy => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
      );

  // Metadata: 11px, Inter SemiBold, 1.4px letter-spacing
  static TextStyle get metadata => GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
      );

  // Button labels
  static TextStyle get button => GoogleFonts.inter(
        fontSize: 15,
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
