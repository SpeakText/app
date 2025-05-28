import 'package:flutter/material.dart';

/// 앱 로고를 표시하는 재사용 가능한 위젯입니다.
/// 실제 로고가 있다면 Icon 대신 Image.asset으로 교체하세요.
class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 8.0),
      child: Icon(Icons.headphones, size: 40, color: Colors.deepPurple),
    );
  }
}
