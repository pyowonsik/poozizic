import 'package:flutter/material.dart';
import '../../domain/entity/daily_summary_entity.dart';

/// 오늘의 상태 카드 위젯
class TodayStatusCard extends StatelessWidget {
  final DailySummaryEntity summary;

  const TodayStatusCard({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatRow(
            '마지막 배변',
            summary.lastBowelText,
            summary.lastBowelTime != null ? const Color(0xFF27AE60) : null,
          ),
          const SizedBox(height: 16),
          _buildStatRow('연속 기록', summary.consecutiveText, null),
          const SizedBox(height: 16),
          _buildStatRow('이번 주 배변', summary.weeklyBowelText, null),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color? valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}
