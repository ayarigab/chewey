import 'package:flutter/material.dart';

const lightColorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color.fromARGB(255, 69, 101, 93),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFEADDFF),
  onPrimaryContainer: Color(0xFF002A00),
  secondary:
      Color.fromARGB(255, 214, 214, 214), //sample on search button bg on home
  onSecondary: Color.fromARGB(255, 221, 220, 220),
  secondaryContainer: Color(0xFFEEF9EE),
  onSecondaryContainer: Color(0xFF1D2B19),
  tertiary: Color(0xFF527D5E),
  onTertiary: Color(
      0xFFFFFFFF), // Pure white to Dark grey as used on Selected menus card
  tertiaryContainer: Color(0xFFFFD8E4),
  onTertiaryContainer: Color(0xFF31111D),
  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),
  outline: Color(0xFF777E74),
  surface: Color(0xFFFFFBFE), // White to Dark for Backgrounds/
  onSurface: Color(0xFF1C1B1F),
  surfaceContainerHighest: Color(0xFFE2ECE0),
  onSurfaceVariant: Color(0xFF474F45),
  inverseSurface: Color(0xFF313330),
  onInverseSurface: Color(0xFFF4EFF4),
  inversePrimary: Color(0xFFCBFFBC),
  shadow: Color.fromARGB(255, 35, 35, 35), //Black to white for Icons/Texts
  surfaceTint: Color(0xFF5FA450),
);

const darkColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color.fromARGB(255, 0, 0, 0),
  onPrimary: Color(0xFF2B721E),
  primaryContainer: Color(0xFF3D8B37),
  onPrimaryContainer: Color(0xFFE3FFDD),
  secondary: Color.fromARGB(255, 48, 48, 48),
  onSecondary: Color.fromARGB(255, 33, 33, 33),
  secondaryContainer: Color(0xFF485844),
  onSecondaryContainer: Color(0xFFE2F8DE),
  tertiary: Color(0xFFEFB8C8),
  onTertiary: Color.fromARGB(255, 48, 48, 48),
  tertiaryContainer: Color(0xFF633B48),
  onTertiaryContainer: Color(0xFFFFD8E4),
  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  errorContainer: Color(0xFF8C1D18),
  onErrorContainer: Color(0xFFF9DEDC),
  outline: Color(0xFF91998F),
  surface: Color(0xFF1C1B1F),
  onSurface: Color(0xFFE6E1E5),
  surfaceContainerHighest: Color(0xFF464F45),
  onSurfaceVariant: Color(0xFFC6D0C4),
  inverseSurface: Color(0xFFE1E6E3),
  onInverseSurface: Color(0xFF313330),
  inversePrimary: Color(0xFF5DA450),
  shadow: Color.fromARGB(255, 225, 225, 225),
  surfaceTint: Color(0xFFCEFFBC),
);

class NielCol {
  // Original Colors
  static const Color mainCol = Color(0xFFE03B34);
  static const Color secCol = Color(0xFFFF7E00);
  static const Color otherCol = Color(0xFFFF4B75);
  static const Color gradCol = Color(0xFF008080);
  static const Color torCol = Color(0xFF40E0D0);

  static const Color people = Color(0xFF4B0082);
  static const Color pinky = Color(0xFFEE82EE);
  static const Color nature = Color(0xFF005B00);
  static const Color lime = Color(0xFF00FF00);
  static const Color rose = Color(0xFFBC8F8F);

  // Shades of White
  static const Color white = Color(0xFFFFFFFF);
  static const Color smoke = Color(0xFFF5F5F5);
  static const Color snow = Color(0xFFFFFAFA);
  static const Color ivory = Color(0xFFFFFFF0);
  static const Color shell = Color(0xFFFFF5EE);
  static const Color floral = Color(0xFFFFFAF0);
  static const Color ghost = Color(0xFFF8F8FF);

  // Dark Mode Colors
  static const Color darkMainCol = Color(0xFF8B0000);
  static const Color darkSecCol = Color(0xFFFF4500);
  static const Color darkOtherCol = Color(0xFF8B004F);
  static const Color darkLightCol = Color(0xFF303030);
  static const Color darkGradCol = Color(0xFF004D4D);
  static const Color darkTorCol = Color(0xFF206060);

  static const Color dPeople = Color(0xFF6A00A3);
  static const Color dPinky = Color(0xFFCC66CC);
  static const Color dLime = Color(0xFF00CC00);
  static const Color dRose = Color(0xFF996666);

  // Shades of Black and Grey
  static const Color black = Color(0xFF000000);
  static const Color dark = Color(0xFFA9A9A9);
  static const Color dim = Color(0xFF696969);
  static const Color grey = Color(0xFF808080);
  static const Color lightGrey = Color(0xFFD3D3D3);
  static const Color slate = Color(0xFF708090);
  static const Color jet = Color(0xFF343434);
}
