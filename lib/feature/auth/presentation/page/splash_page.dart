import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/auth/di/auth_providers.dart';
import 'package:poozizic/feature/auth/presentation/page/login_page.dart';
import 'package:poozizic/feature/auth/presentation/provider/auth_state.dart';
import 'package:poozizic/main.dart';

/// 스플래시 화면
class SplashPage extends ConsumerWidget {
  /// 스플래시 화면 생성자
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (context) => const MainScreen()),
        );
      } else if (next.status == AuthStatus.unauthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (context) => const LoginPage()),
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xFF5D4037),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 똥 이모지
            const Text(
              '💩',
              style: TextStyle(fontSize: 100),
            ),
            const SizedBox(height: 24),
            // 앱 이름
            const Text(
              '뿌지직',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '배변 건강 관리',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 60),
            // 로딩
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
