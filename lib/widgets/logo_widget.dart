import 'package:flutter/material.dart';

/// 앱 로고를 표시하는 재사용 가능한 위젯입니다.
/// 실제 로고가 있다면 Icon 대신 Image.asset으로 교체하세요.
class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '앱 로고',
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Icon(Icons.book, size: 36, color: Color(0xFF4A4A4A)),
      ),
    );
  }
}
