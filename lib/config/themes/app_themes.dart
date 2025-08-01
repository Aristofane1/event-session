import 'package:flutter/material.dart';

class AppThemes {
  // Palette minimaliste
  static const Color primaryColor = Color(0xFFECAE4C);
  static const Color secondaryColor = Color(0xFFB01C26);

  // Arrière-plans
  static const Color background = Color(0xFFFAFAFA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFF0F0F0);

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    fontFamily: "Manrope-Medium",
    brightness: Brightness.light,
    scaffoldBackgroundColor: background,

    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surface,
      onPrimary: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
    ),

    textTheme: const TextTheme(
      headlineSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
      bodySmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w400),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: border),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      ),
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: border, width: 0.5),
      ),
    ),

    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primaryColor,
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),

    dividerTheme: const DividerThemeData(color: border, thickness: 0.5),
  );

  // Styles minimalistes
  static BoxDecoration get cardDecoration => const BoxDecoration(
    color: surface,
    borderRadius: BorderRadius.all(Radius.circular(12)),
  );

  static BoxDecoration get activeTab => BoxDecoration(
    color: secondaryColor,
    borderRadius: BorderRadius.circular(16),
  );

  static BoxDecoration get badge =>
      BoxDecoration(color: border, borderRadius: BorderRadius.circular(4));
}
