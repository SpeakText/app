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
      debugShowCheckedModeBanner: false,
      title: 'AudioBook',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme(
          primary: Color(0xFFA0A0A0), // 아이콘/버튼
          primaryContainer: Color(0xFFD0D0D0), // 비활성
          secondary: Color(0xFF4A4A4A), // 포인트 강조 텍스트
          secondaryContainer: Color(0xFFF5F5F5), // 배경
          surface: Color(0xFFF5F5F5), // 배경
          onPrimary: Color(0xFFF5F5F5), // 배경(버튼 텍스트 등)
          onSecondary: Color(0xFF4A4A4A), // 포인트 강조 텍스트
          onSurface: Color(0xFF333333), // 기본 텍스트
          error: Color(0xFFD32F2F),
          onError: Color(0xFFF5F5F5),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Color(0xFFF5F5F5),
        textTheme: TextTheme(
          headlineSmall: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Color(0xFF4A4A4A), // 포인트 강조 텍스트
          ),
          titleLarge: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF4A4A4A), // 포인트 강조 텍스트
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF333333),
          ), // 기본 텍스트
          bodyMedium: TextStyle(
            fontSize: 14,
            color: Color(0xFF333333),
          ), // 기본 텍스트
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFA0A0A0), // 아이콘/버튼
            foregroundColor: Color(0xFFF5F5F5), // 배경(버튼 텍스트)
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
          backgroundColor: Color(0xFFF5F5F5),
          foregroundColor: Color(0xFF4A4A4A),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFF4A4A4A),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Color(0xFFA0A0A0)),
        ),
        cardTheme: CardTheme(
          color: Color(0xFFF5F5F5),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFFA0A0A0),
          contentTextStyle: TextStyle(color: Color(0xFFF5F5F5)),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFA0A0A0),
          foregroundColor: Color(0xFFF5F5F5),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme(
          primary: Color(0xFFFF6F00),
          primaryContainer: Color(0xFFFFB74D),
          secondary: Color(0xFFFFA726),
          secondaryContainer: Color(0xFFFFE0B2),
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
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFFFFE0B2)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6F00),
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
          foregroundColor: Color(0xFFFFA726),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Color(0xFFFFA726),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
          iconTheme: IconThemeData(color: Color(0xFFFFA726)),
        ),
        cardTheme: CardTheme(
          color: Color(0xFF393E46),
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        snackBarTheme: SnackBarThemeData(
          backgroundColor: Color(0xFFFF6F00),
          contentTextStyle: TextStyle(color: Colors.white),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFA726),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: MainScreen(),
    );
  }
}
