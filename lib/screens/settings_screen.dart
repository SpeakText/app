import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

/// 시각장애인을 위한 접근성 중심의 설정화면
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  /// 로그인 화면으로 이동
  Future<void> _navigateToAuth() async {
    final result = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (context) => const AuthScreen()));

    // 로그인 성공 시 상태 업데이트
    if (result == true) {
      setState(() {});
    }
  }

  /// 로그아웃 처리
  Future<void> _handleLogout() async {
    // 로그아웃 확인 다이얼로그
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('로그아웃'),
            content: const Text('정말 로그아웃하시겠습니까?'),
            actions: [
              Semantics(
                label: "취소 버튼",
                button: true,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('취소'),
                ),
              ),
              Semantics(
                label: "로그아웃 버튼",
                button: true,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('로그아웃'),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      try {
        await _authService.signout();
        setState(() {});
      } catch (e) {
        // 에러 처리
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정'),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 계정 섹션
          _buildSectionHeader('계정'),
          _buildAccountCard(),
          const SizedBox(height: 24),

          // 앱 정보 섹션
          _buildSectionHeader('앱 정보'),
          _buildAppInfoCard(),
        ],
      ),
    );
  }

  /// 섹션 헤더
  Widget _buildSectionHeader(String title) {
    return Semantics(
      header: true,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }

  /// 계정 관련 카드
  Widget _buildAccountCard() {
    final isLoggedIn = _authService.isLoggedIn;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 로그인 상태 표시
            Semantics(
              label: "현재 계정 상태: ${isLoggedIn ? '로그인됨' : '로그인되지 않음'}",
              child: ExcludeSemantics(
                child: Row(
                  children: [
                    Icon(
                      isLoggedIn
                          ? Icons.account_circle
                          : Icons.account_circle_outlined,
                      size: 24,
                      color: isLoggedIn ? Colors.green[600] : Colors.grey[500],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        isLoggedIn ? '로그인됨' : '로그인 안됨',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color:
                              isLoggedIn
                                  ? Colors.green.shade700
                                  : Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 로그인/로그아웃 버튼
            SizedBox(
              width: double.infinity,
              child:
                  isLoggedIn
                      ? Semantics(
                        label: "로그아웃 버튼",
                        hint: "현재 계정에서 로그아웃합니다.",
                        button: true,
                        child: ElevatedButton(
                          onPressed: _handleLogout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.errorContainer,
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                          child: const Text('로그아웃'),
                        ),
                      )
                      : Semantics(
                        label: "로그인 버튼",
                        hint: "로그인 화면으로 이동하여 로그인 또는 회원가입을 진행합니다.",
                        button: true,
                        child: ElevatedButton(
                          onPressed: _navigateToAuth,
                          child: const Text('로그인'),
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  /// 앱 정보 카드
  Widget _buildAppInfoCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoTile(
              icon: Icons.info_outline,
              title: '버전',
              subtitle: '1.0.0',
            ),
            const Divider(),
            _buildInfoTile(
              icon: Icons.accessibility,
              title: '접근성',
              subtitle: 'VoiceOver 최적화',
            ),
            const Divider(),
            _buildInfoTile(
              icon: Icons.headphones,
              title: '오디오북',
              subtitle: '고품질 음성 서비스',
            ),
          ],
        ),
      ),
    );
  }

  /// 정보 타일
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Semantics(
      label: "$title: $subtitle",
      child: ExcludeSemantics(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
