import 'package:flutter/material.dart';

/// 이상적인 배변 상태 카드 위젯
///
/// 현재 배변 상태에 대한 피드백을 표시합니다.
class IdealBowelCard extends StatelessWidget {
  const IdealBowelCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFD5F5E3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: const [
            Icon(
              Icons.check_circle,
              color: Color(0xFF27AE60),
              size: 24,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                '이상적인 배변 상태를 유지하고 있습니다',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1E8449),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
