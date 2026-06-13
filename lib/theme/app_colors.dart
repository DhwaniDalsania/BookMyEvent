import 'package:flutter/material.dart';

class AppColors {
  // Brand Palette - Luxury Redesign
  static const Color vanilla = Color(0xFFF1EADA);   // Background base
  static const Color vanillaLight = Color(0xFFFCFAF7); // Highlight for gradients
  static const Color vanillaDark = Color(0xFFE5DBC7);  // Shadow for gradients
  static const Color mahogany = Color(0xFF584738);  // Primary brand, headings
  static const Color tobacco = Color(0xFFB59E7D);   // Secondary, warm accents
  static const Color sand = Color(0xFFCEC1A8);      // Card surfaces
  static const Color mountain = Color(0xFFAAA396);  // Muted text, dividers
  static const Color gold = Color(0xFFC89B3C);      // LUXURY ACCENT

  // Cinematic Overlays & Shadows
  static const Color cinematicOverlay = Color(0xFF1A0F0A); // Dark cinematic overlay for hero images
  static const Color cinematicShadow = Color(0xFF150C07); // Heavy dark shadow for depth
  static const Color cinematicDarkOverlay = Color(0xFF0D0907); // Extremely dark for 75% image visibility fade
  static const Color seatAvailable = sand;
  static const Color seatSelected = gold;
  static const Color seatUnavailable = Color(0xFF2A201A); // Dark muted for unavailable seats

  // Mapping to standard names
  static const Color primary = mahogany;
  static const Color secondary = tobacco;

  static const Color background = vanilla;
  static const Color surface = sand;

  static const Color textPrimary = mahogany;
  static const Color textSecondary = mountain;
  static const Color textOnPrimary = Colors.white;
  static const Color textOnDark = vanilla;

  static const Color divider = Color(0x40AAA396); // Mountain with 25% opacity
}
