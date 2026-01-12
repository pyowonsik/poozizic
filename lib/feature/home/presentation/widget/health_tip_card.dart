import 'package:flutter/material.dart';

/// 건강 팁 카드 위젯
///
/// 사용자에게 유용한 건강 팁을 표시합니다.
class HealthTipCard extends StatelessWidget {
  const HealthTipCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: const [
          Text('💡', style: TextStyle(fontSize: 24)),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '축가 팁',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.check,
                      size: 16,
                      color: Color(0xFF27AE60),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '규칙적인 배변 패턴을 보이고 있습니다',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
