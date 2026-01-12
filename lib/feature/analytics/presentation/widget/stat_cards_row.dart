import 'package:flutter/material.dart';
import '../../domain/entity/analytics_summary_entity.dart';

/// 통계 카드 행 위젯
class StatCardsRow extends StatelessWidget {
  final AnalyticsSummaryEntity summary;

  const StatCardsRow({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            value: summary.healthScoreText,
            label: '건강 점수',
            valueColor: const Color(0xFFFF6B35),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            value: summary.normalRatioText,
            label: '정상 비율',
            valueColor: const Color(0xFF4CAF50),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            value: summary.averageIntervalText,
            label: '평균 간격',
            valueColor: const Color(0xFFFF6B35),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
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
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFF666666)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
