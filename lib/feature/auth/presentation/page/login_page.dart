import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 로그인 페이지
class LoginPage extends StatelessWidget {
  /// 로그인 페이지 생성자
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFFFF), Color(0xFFFFF5F0)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),

                // 로고
                Image.asset(
                  'assets/image/뿌지직.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),

                // // 캘린더 이미지
                // Image.asset(
                //   'assets/image/calender.png',
                //   height: 200,
                //   fit: BoxFit.contain,
                // ),
                const SizedBox(height: 32),

                // 앱 설명
                const Text(
                  '건강한 배변 습관을 위한\n똑똑한 건강 관리',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF666666),
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 16),

                // 부제
                const Text(
                  '매일의 기록으로 더 건강한 내일을',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
                ),

                const Spacer(),

                // 소셜 로그인 버튼들
                Column(
                  children: [
                    // 카카오 로그인
                    _SocialLoginButton(
                      onTap: () {
                        // TODO: 카카오 로그인 구현
                        debugPrint('카카오 로그인');
                      },
                      backgroundColor: const Color(0xFFFFE812),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/image/btn_kakao.svg',
                            width: 38,
                            height: 38,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            '카카오로 시작하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 구글 로그인
                    _SocialLoginButton(
                      onTap: () {
                        // TODO: 구글 로그인 구현
                        debugPrint('구글 로그인');
                      },
                      backgroundColor: Colors.white,
                      borderColor: const Color(0xFFE0E0E0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/image/btn_google.svg',
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Google로 시작하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 애플 로그인
                    _SocialLoginButton(
                      onTap: () {
                        // TODO: 애플 로그인 구현
                        debugPrint('애플 로그인');
                      },
                      backgroundColor: const Color(0xFF000000),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/image/btn_apple.png',
                            width: 34,
                            height: 34,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Apple로 시작하기',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 약관 동의 텍스트
                Text.rich(
                  TextSpan(
                    text: '로그인 시 ',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF999999),
                    ),
                    children: [
                      TextSpan(
                        text: '이용약관',
                        style: TextStyle(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.8),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: ' 및 '),
                      TextSpan(
                        text: '개인정보처리방침',
                        style: TextStyle(
                          color: const Color(0xFFFF6B35).withValues(alpha: 0.8),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      const TextSpan(text: '에 동의하게 됩니다.'),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 소셜 로그인 버튼 위젯
class _SocialLoginButton extends StatelessWidget {
  /// 소셜 로그인 버튼 생성자
  const _SocialLoginButton({
    required this.onTap,
    required this.backgroundColor,
    required this.child,
    this.borderColor,
  });

  /// 탭 콜백
  final VoidCallback onTap;

  /// 배경색
  final Color backgroundColor;

  /// 테두리 색 (옵션)
  final Color? borderColor;

  /// 자식 위젯
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: borderColor != null
              ? Border.all(color: borderColor!, width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }
}
