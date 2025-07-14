import 'package:flutter/material.dart';

class AppTheme {
  static const Color _lightPrimaryColor = Color(0xFF1E88E5);
  static const Color _lightBackgroundColor = Color(0xFFF2F2F7);
  static const Color _lightSurfaceColor = Colors.white;

  static const Color _darkPrimaryColor = Color(0xFF64B5F6);
  static const Color _darkBackgroundColor = Color(0xFF121212);
  static const Color _darkSurfaceColor = Color(0xFF1E1E1E);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Pretendard',
    colorScheme: ColorScheme.light(
      primary: _lightPrimaryColor,
      secondary: Colors.green.shade600,
      onSecondary: Colors.white,
      surface: _lightSurfaceColor,
      onPrimary: Colors.white,
      onSurface: Colors.black87,
      error: Colors.redAccent,
      errorContainer: Colors.redAccent.withOpacity(0.1),
    ),
    scaffoldBackgroundColor: _lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      color: _lightBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
    cardTheme: CardTheme(
      color: _lightSurfaceColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Pretendard',
    colorScheme: ColorScheme.dark(
      primary: _darkPrimaryColor,
      secondary: Colors.green.shade400,
      onSecondary: Colors.white,
      surface: _darkSurfaceColor,
      onPrimary: Colors.black,
      onSurface: Colors.white70,
      error: Colors.red,
      errorContainer: Colors.red.withOpacity(0.2),
    ),
    scaffoldBackgroundColor: _darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      color: _darkBackgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white70),
      titleTextStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: _darkSurfaceColor,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: const TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );

  static final ThemeData lowVisionTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Pretendard',
    colorScheme: ColorScheme.highContrastDark(
      primary: Colors.white, // 노랑 → 흰색
      secondary: Colors.white,
      onPrimary: Colors.black,
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Colors.red.shade700,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: AppBarTheme(
      color: Colors.black,
      elevation: 2,
      iconTheme: IconThemeData(color: Colors.white, size: 32),
      titleTextStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white, width: 4),
      ),
      shadowColor: Colors.white.withOpacity(0.5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        minimumSize: const Size(120, 56),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white, width: 4),
        ),
        shadowColor: Colors.white.withOpacity(0.5),
        elevation: 8,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: Colors.white,
      filled: true,
      labelStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      hintStyle: TextStyle(color: Colors.black54, fontSize: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white, width: 3),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white, width: 4),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white, width: 3),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 3),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red, width: 4),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white,
      selectionColor: Colors.white24,
      selectionHandleColor: Colors.white,
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(fontSize: 18, color: Colors.white),
      titleLarge: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      titleMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      headlineSmall: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      labelLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    ),
    focusColor: Colors.white,
    highlightColor: Colors.white24,
    splashColor: Colors.white24,
    dividerColor: Colors.white,
  );
}
