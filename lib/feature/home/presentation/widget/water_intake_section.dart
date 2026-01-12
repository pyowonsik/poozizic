import 'package:flutter/material.dart';

/// 오늘 수분 섭취 섹션 위젯
///
/// 수분 섭취 현황과 진행 바를 표시합니다.
class WaterIntakeSection extends StatelessWidget {
  const WaterIntakeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '오늘 수분 섭취',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              Text(
                '1.5L / 2L',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF27AE60),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Stack(
            children: [
              Container(
                height: 24,
                decoration: BoxDecoration(
                  color: const Color(0xFFE0E0E0),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.75,
                child: Container(
                  height: 24,
                  decoration: BoxDecoration(
                    color: const Color(0xFF27AE60),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
