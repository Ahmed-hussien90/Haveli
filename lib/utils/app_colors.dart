import 'package:flutter/material.dart';

class AppColor {
  const AppColor._();

  static const darkOrange = Color(0xFFEC6813);
  static const lightOrange = Color(0xFFf8b89a);

  static const darkGrey = Color(0xFFA6A3A0);
  static const lightGrey = Color(0xFFE5E6E8);

  static ThemeData lightAppTheme = ThemeData(
    primaryColor: const Color(0xFFf16b26),
    hintColor: const Color(0xFFf16b26),
    brightness: Brightness.light,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: const Color(0xFFf16b26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFA6A3A0)),
    textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        displayMedium: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        headlineSmall: TextStyle(fontSize: 15, color: Colors.grey),
        titleLarge: TextStyle(fontSize: 12)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
  );

  static ThemeData darkAppTheme = ThemeData(
    primaryColor: const Color(0xFFf16b26),
    hintColor: const Color(0xFFf16b26),
    brightness: Brightness.dark,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: const Color(0xFFf16b26),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // <-- Radius
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Colors.deepOrange),
    ),
    iconTheme: const IconThemeData(color: Color(0xFFA6A3A0)),
    textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        displaySmall: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        headlineMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        headlineSmall: TextStyle(fontSize: 15, color: Colors.grey),
        titleLarge: TextStyle(fontSize: 12)),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
  );
}
