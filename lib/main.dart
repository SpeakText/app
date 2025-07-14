import 'package:flutter/material.dart';
import 'package:speaktext/theme.dart';
import 'screens/auth_screen.dart';

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
      theme: AppTheme.lowVisionTheme,
      home: const AuthScreen(),
    );
  }
}
