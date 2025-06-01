import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onLogout;
  const ProfileScreen({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return Scaffold(
      appBar: AppBar(title: const Text('내 정보')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 80, color: Color(0xFFA0A0A0)),
            const SizedBox(height: 16),
            const Text(
              '로그인 상태입니다.',
              style: TextStyle(fontSize: 18, color: Color(0xFF333333)),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await authService.signout();
                onLogout?.call();
              },
              child: const Text(
                '로그아웃',
                style: TextStyle(color: Color(0xFFA0A0A0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
