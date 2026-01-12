import 'package:flutter/material.dart';
import 'package:poozizic/feature/home/domain/entity/daily_summary_entity.dart';

/// 수분 섭취 진행률 섹션 위젯
class WaterProgressSection extends StatelessWidget {
  /// 수분 섭취 진행률 섹션 위젯 생성자
  /// [summary] 일일 요약 엔티티
  const WaterProgressSection({required this.summary, super.key});

  /// 일일 요약 엔티티
  final DailySummaryEntity summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '오늘 수분 섭취',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            Text(
              summary.waterDisplayText,
              style: const TextStyle(
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
              widthFactor: summary.waterProgress,
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
    );
  }
}
