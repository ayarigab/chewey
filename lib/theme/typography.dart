import 'package:flutter/material.dart';

const textTheme = TextTheme(
  displayLarge: TextStyle(
    fontVariations: [FontVariation('wght', 400)],
    fontSize: 45,
    height: 64 / 45,
    letterSpacing: -0.25,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  displayMedium: TextStyle(
    fontVariations: [FontVariation('wght', 400)],
    fontSize: 45,
    height: 52 / 45,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  displaySmall: TextStyle(
    fontVariations: [FontVariation('wght', 400)],
    fontSize: 36,
    height: 44 / 36,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  headlineLarge: TextStyle(
    fontVariations: [FontVariation('wght', 400)],
    fontSize: 32,
    height: 40 / 32,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  headlineMedium: TextStyle(
    fontVariations: [FontVariation('wght', 400)],
    fontSize: 28,
    height: 36 / 28,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  headlineSmall: TextStyle(
    fontVariations: [FontVariation('wght', 400)],
    fontSize: 24,
    height: 32 / 24,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  titleLarge: TextStyle(
    fontVariations: [FontVariation('wght', 700)],
    fontSize: 22,
    height: 28 / 22,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  titleMedium: TextStyle(
    fontVariations: [FontVariation('wght', 600)],
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: 0.1,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  titleSmall: TextStyle(
    fontVariations: [FontVariation('wght', 600)],
    fontSize: 14,
    height: 20 / 14,
    letterSpacing: 0.1,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  labelLarge: TextStyle(
    fontVariations: [FontVariation('wght', 700)],
    fontSize: 14,
    height: 20 / 14,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  labelMedium: TextStyle(
    fontVariations: [FontVariation('wght', 700)],
    fontSize: 12,
    height: 16 / 12,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  labelSmall: TextStyle(
    fontVariations: [FontVariation('wght', 700)],
    fontSize: 11,
    height: 16 / 11,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  bodyLarge: TextStyle(
    fontVariations: [FontVariation('wght', 400)],
    fontSize: 16,
    height: 24 / 16,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  bodyMedium: TextStyle(
    fontVariations: [FontVariation('wght', 400)],
    fontSize: 14,
    height: 20 / 14,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
  bodySmall: TextStyle(
    fontVariations: [FontVariation('wght', 400)],
    fontSize: 12,
    height: 16 / 12,
    fontFamily: 'DMSans',
    decoration: TextDecoration.none,
  ),
);

class NielText {
  NielText._();
  static const String fontFamily = "DMSans";

  // Font styles
  static const TextStyle title1 = TextStyle(
    fontSize: 60,
    fontWeight: FontWeight.w800,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle title2 = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle title3 = TextStyle(
    fontSize: 34,
    fontWeight: FontWeight.w900,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle headLine = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle subHeadline = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w800,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle body = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle bodyBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w800,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle smallBody = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle smallBodyBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle buttonLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );
  static const TextStyle buttonExtraLarge = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w800,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );

  static const TextStyle buttonSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );
  static const TextStyle buttonExtraSmall = TextStyle(
    fontSize: 8,
    fontWeight: FontWeight.w800,
    fontFamily: fontFamily,
    decoration: TextDecoration.none,
    letterSpacing: 1.0,
  );
}
