import 'package:flutter/material.dart';

/// 재사용 가능한 하단 네비게이션 바 위젯입니다.
class BottomNavBarWidget extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const BottomNavBarWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '하단 네비게이션 바. 홈, 검색, 라이브러리, 프로필 탭이 있습니다.',
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF4A4A4A),
        unselectedItemColor: const Color(0xFFA0A0A0),
        backgroundColor: Color(0xFFF5F5F5),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '홈',
            tooltip: '홈 탭',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '검색',
            tooltip: '검색 탭',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: '라이브러리',
            tooltip: '내 라이브러리 탭',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '프로필',
            tooltip: '프로필 탭',
          ),
        ],
      ),
    );
  }
}
