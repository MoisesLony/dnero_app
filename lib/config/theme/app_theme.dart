import 'package:flutter/material.dart';

class AppTheme {
  // Define the colors used in the app
  static const Color primaryColor = Color(0xFF7606D1); // Main purple
  static const Color secondaryColor = Color(0xFF7DFC92); // Green for buttons
  static const Color backgroundColor = Color(0xFF1C2F56); // Dark background
  static const Color textPrimaryColor = Color.fromARGB(255, 28, 47, 86); // Main text color
  static const Color accentColor = Color(0xFF125292); // Accent color (blue)
  static const Color appBarTheme = Colors.white;

  // Define the light theme for the app
  static ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: 'Poppins', // Custom font
    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimaryColor,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        color: textPrimaryColor,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor, // Green button
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textPrimaryColor,
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      labelStyle: TextStyle(
        color: textPrimaryColor,
        fontSize: 16,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: textPrimaryColor),
      ),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: appBarTheme, // Background color for the AppBar
      elevation: 0, // Removes the shadoW
    ),
  );
}
