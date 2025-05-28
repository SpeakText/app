import 'package:flutter/material.dart';
import 'screens/main_screen.dart';

void main() {
  runApp(const AudioBookApp());
}

/// 오디오북 앱의 루트 위젯입니다.
class AudioBookApp extends StatelessWidget {
  const AudioBookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AudioBook',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: Color(0xFF3949AB), // Indigo 600
          primaryContainer: Color(0xFF5C6BC0),
          secondary: Color(0xFF4DB6AC), // Teal 300
          secondaryContainer: Color(0xFFB2DFDB), // Gray 50
          surface: Color(0xFFF5F5F5), // Gray 100
          onPrimary: Colors.white,
          onSecondary: Colors.white, // Gray 900
          onSurface: Color(0xFF212121),
          error: Color(0xFFD32F2F),
          onError: Colors.white,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Color(0xFFFAFAFA),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF212121),
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF212121),
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF212121)),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF757575)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3949AB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            elevation: 2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Color(0xFFF5F5F5),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF3949AB),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF3949AB),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Color(0xFF3949AB)),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF3949AB),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF4DB6AC),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          primary: Color(0xFF3949AB),
          primaryContainer: Color(0xFF5C6BC0),
          secondary: Color(0xFF4DB6AC),
          secondaryContainer: Color(0xFF00695C),
          surface: Color(0xFF232946),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          error: Color(0xFFD32F2F),
          onError: Colors.white,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Color(0xFF232946),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.white,
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFB8C1EC)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3949AB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: TextStyle(fontWeight: FontWeight.bold),
            elevation: 2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Color(0xFF393E46),
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF232946),
          foregroundColor: Color(0xFF4DB6AC),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF4DB6AC),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Color(0xFF4DB6AC)),
        ),
        cardTheme: CardTheme(
          color: Color(0xFF393E46),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFF3949AB),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF4DB6AC),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}
