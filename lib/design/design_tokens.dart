/// Raqim Design Tokens
/// Source of truth for all color, typography, spacing, radius, and elevation values.
/// Every UI component derives directly from this file — no magic numbers anywhere.

import 'package:flutter/material.dart';

/// MARK: - Color System
/// Complete coral ramp + supporting palette per design spec.
/// Dark mode is NOT an inversion — coral remains untouched, only surfaces swap.
abstract class RaqimColors {
  // Coral ramp (primary accent system)
  static const Color coral50 = Color(0xFFFFF3ED);
  static const Color coral100 = Color(0xFFFFE1D3);
  static const Color coral300 = Color(0xFFFFAB8A);
  static const Color coral500 = Color(0xFFFF7F50); // PRIMARY ACCENT
  static const Color coral600 = Color(0xFFF26B3A); // hover state
  static const Color coral700 = Color(0xFFD9542A); // active state
  static const Color roseGold = Color(0xFFE8B4A0); // secondary accent

  // Light mode surfaces
  static const Color ivory = Color(0xFFFAFAFA); // background
  static const Color paper = Color(0xFFFFFFFF); // card surfaces

  // Dark mode surfaces
  static const Color charcoal900 = Color(0xFF121212); // background
  static const Color charcoal800 = Color(0xFF1B1B1B); // card surface
  static const Color charcoal700 = Color(0xFF262626); // elevated surface

  // Text (light mode)
  static const Color slate900 = Color(0xFF1C1E21); // primary text
  static const Color slate600 = Color(0xFF5B6168); // secondary text
  static const Color slate400 = Color(0xFF9BA1A8); // placeholder, disabled

  // Text (dark mode)
  static const Color ivory900 = Color(0xFFF2F1EE); // primary text
  static const Color ivory600 = Color(0xFFB8B4AE); // secondary text

  // Status colors
  static const Color success = Color(0xFF4A9B7F); // synced
  static const Color warning = Color(0xFFE0A339); // pending
  static const Color danger = Color(0xFFD9534A); // destructive
}

/// MARK: - Typography
/// Premium sans-serif (Inter/SF Pro) for UI, serif (Merriweather) for document,
/// monospace (IBM Plex Mono) for metadata.
abstract class RaqimTypography {
  // Font families (platform-adaptive defaults provided)
  static const String fontUIFamily = 'Inter';
  static const String fontDocumentFamily = 'Merriweather';
  static const String fontDisplayFamily = 'Playfair Display';
  static const String fontMetaFamily = 'IBMPlexMono';

  // Type scale (based on 16px)
  // Display: 2.25rem / 36px, weight 600
  static final TextStyle display = TextStyle(
    fontFamily: fontDisplayFamily,
    fontSize: 36,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // H1: 1.5rem / 24px, weight 700
  static final TextStyle h1 = TextStyle(
    fontFamily: fontUIFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    letterSpacing: 0,
  );

  // H2: 1.125rem / 18px, weight 600
  static final TextStyle h2 = TextStyle(
    fontFamily: fontUIFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  // Body (document): 1.0625rem / 17px, weight 400, line-height 1.7
  static final TextStyle bodyDoc = TextStyle(
    fontFamily: fontDocumentFamily,
    fontSize: 17,
    fontWeight: FontWeight.w400,
    height: 1.7,
    letterSpacing: 0,
  );

  // Body (UI): 0.9375rem / 15px, weight 400
  static final TextStyle bodyUI = TextStyle(
    fontFamily: fontUIFamily,
    fontSize: 15,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
  );

  // Caption: 0.8125rem / 13px, weight 500, mono
  static final TextStyle caption = TextStyle(
    fontFamily: fontMetaFamily,
    fontSize: 13,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.02,
  );
}

/// MARK: - Spacing Scale
/// 4px as the base unit. All margins, padding derive from this.
abstract class RaqimSpacing {
  static const double space1 = 4;
  static const double space2 = 8;
  static const double space3 = 12;
  static const double space4 = 16;
  static const double space5 = 24;
  static const double space6 = 32;
  static const double space7 = 48;
  static const double space8 = 64;
}

/// MARK: - Border Radius
/// Floor: 16px (cards, inputs). Ceiling: 24px (modals, sheets).
/// Pill: 999px for pills, docks, rounded buttons.
abstract class RaqimRadius {
  static const double radiusSm = 12;
  static const double radiusMd = 16;
  static const double radiusLg = 24;
  static const double radiusPill = 999;
}

/// MARK: - Elevation & Shadows
/// Shadows are slate-900 at low opacity (not pure black), creating soft separation.
abstract class RaqimShadows {
  // Card shadow: 0 4px 24px -8px rgba(28, 30, 33, 0.08)
  static final BoxShadow shadowCard = BoxShadow(
    color: RaqimColors.slate900.withOpacity(0.08),
    offset: const Offset(0, 4),
    blurRadius: 24,
    spreadRadius: -8,
  );

  // Float shadow: 0 8px 32px -8px rgba(28, 30, 33, 0.12)
  static final BoxShadow shadowFloat = BoxShadow(
    color: RaqimColors.slate900.withOpacity(0.12),
    offset: const Offset(0, 8),
    blurRadius: 32,
    spreadRadius: -8,
  );

  // Modal shadow: 0 16px 48px -12px rgba(28, 30, 33, 0.18)
  static final BoxShadow shadowModal = BoxShadow(
    color: RaqimColors.slate900.withOpacity(0.18),
    offset: const Offset(0, 16),
    blurRadius: 48,
    spreadRadius: -12,
  );

  // Dark mode card shadow
  static final BoxShadow shadowDarkCard = BoxShadow(
    color: Colors.black.withOpacity(0.4),
    offset: const Offset(0, 4),
    blurRadius: 24,
    spreadRadius: -8,
  );

  // Collections for convenience
  static final List<BoxShadow> cardShadow = [shadowCard];
  static final List<BoxShadow> floatShadow = [shadowFloat];
  static final List<BoxShadow> modalShadow = [shadowModal];
  static final List<BoxShadow> darkCardShadow = [shadowDarkCard];
}

/// MARK: - Glassmorphism System
/// Exact recipe: 72% opacity + 20px blur + 180% saturation + faint coral border.
/// Used for floating dock, contextual toolbar, bottom sheets.
class RaqimGlass {
  /// Light mode glass recipe
  static BoxDecoration glassLight() {
    return BoxDecoration(
      color: RaqimColors.ivory.withOpacity(0.72),
      borderRadius: BorderRadius.circular(RaqimRadius.radiusMd),
      border: Border.all(
        color: RaqimColors.coral500.withOpacity(0.12),
        width: 1,
      ),
      boxShadow: RaqimShadows.floatShadow,
    );
  }

  /// Dark mode glass recipe
  static BoxDecoration glassDark() {
    return BoxDecoration(
      color: RaqimColors.charcoal900.withOpacity(0.72),
      borderRadius: BorderRadius.circular(RaqimRadius.radiusMd),
      border: Border.all(
        color: RaqimColors.coral500.withOpacity(0.16),
        width: 1,
      ),
      boxShadow: [RaqimShadows.shadowDarkCard],
    );
  }

  /// Glass decoration with custom radius
  static BoxDecoration glassPill({required Brightness brightness}) {
    final isDark = brightness == Brightness.dark;
    return BoxDecoration(
      color: (isDark ? RaqimColors.charcoal900 : RaqimColors.ivory)
          .withOpacity(0.72),
      borderRadius: BorderRadius.circular(RaqimRadius.radiusPill),
      border: Border.all(
        color: RaqimColors.coral500
            .withOpacity(isDark ? 0.16 : 0.12),
        width: 1,
      ),
      boxShadow: isDark
          ? [RaqimShadows.shadowDarkCard]
          : RaqimShadows.floatShadow,
    );
  }
}

/// MARK: - Animation Durations & Curves
/// Single source of motion vocabulary. No duration in the app should exceed 300ms.
abstract class RaqimAnimation {
  // Micro interactions (button press, hover)
  static const Duration durationMicro = Duration(milliseconds: 150);
  static const Curve curveMicro = Curves.easeOut;

  // Reveal (toolbar, popovers)
  static const Duration durationReveal = Duration(milliseconds: 150);
  static const Curve curveReveal = Curves.easeOut;

  // Sheet/Modal entrance (sheet specific: deceleration curve)
  static const Duration durationSheet = Duration(milliseconds: 280);
  static const Curve curveSheet = Cubic(0.32, 0.72, 0, 1);

  // Ambient (scroll-driven, header background fade)
  static const Duration durationAmbient = Duration(milliseconds: 300);
  static const Curve curveAmbient = Curves.ease;
}

/// MARK: - Theme Builder
/// Constructs complete ThemeData for light and dark modes using tokens above.
abstract class RaqimTheme {
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: RaqimColors.ivory,
      colorScheme: ColorScheme.light(
        primary: RaqimColors.coral500,
        surface: RaqimColors.paper,
        background: RaqimColors.ivory,
      ),
      textTheme: TextTheme(
        displayLarge: RaqimTypography.display
            .copyWith(color: RaqimColors.slate900),
        headlineSmall: RaqimTypography.h1
            .copyWith(color: RaqimColors.slate900),
        titleMedium: RaqimTypography.h2
            .copyWith(color: RaqimColors.slate900),
        bodyMedium: RaqimTypography.bodyUI
            .copyWith(color: RaqimColors.slate900),
        bodyLarge: RaqimTypography.bodyDoc
            .copyWith(color: RaqimColors.slate900),
        labelSmall: RaqimTypography.caption
            .copyWith(color: RaqimColors.slate600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RaqimColors.coral50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RaqimRadius.radiusMd),
          borderSide: const BorderSide(color: RaqimColors.coral300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RaqimRadius.radiusMd),
          borderSide: const BorderSide(color: RaqimColors.coral300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RaqimRadius.radiusMd),
          borderSide: const BorderSide(color: RaqimColors.coral500, width: 2),
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: RaqimColors.charcoal900,
      colorScheme: ColorScheme.dark(
        primary: RaqimColors.coral500,
        surface: RaqimColors.charcoal800,
        background: RaqimColors.charcoal900,
      ),
      textTheme: TextTheme(
        displayLarge: RaqimTypography.display
            .copyWith(color: RaqimColors.ivory900),
        headlineSmall: RaqimTypography.h1
            .copyWith(color: RaqimColors.ivory900),
        titleMedium: RaqimTypography.h2
            .copyWith(color: RaqimColors.ivory900),
        bodyMedium: RaqimTypography.bodyUI
            .copyWith(color: RaqimColors.ivory900),
        bodyLarge: RaqimTypography.bodyDoc
            .copyWith(color: RaqimColors.ivory900),
        labelSmall: RaqimTypography.caption
            .copyWith(color: RaqimColors.ivory600),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RaqimColors.charcoal800.withOpacity(0.6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RaqimRadius.radiusMd),
          borderSide: const BorderSide(color: RaqimColors.charcoal700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RaqimRadius.radiusMd),
          borderSide: const BorderSide(color: RaqimColors.charcoal700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(RaqimRadius.radiusMd),
          borderSide: const BorderSide(color: RaqimColors.coral500, width: 2),
        ),
      ),
    );
  }
}
