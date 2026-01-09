import 'package:flutter/material.dart';
import '../../domain/entity/calendar_statistics.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({
    super.key,
    required this.statistics,
  });

  final CalendarStatistics statistics;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            '${statistics.totalRecordsThisMonth}',
            '이번 달',
            Colors.black,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[200],
          ),
          _buildStatItem(
            '${statistics.healthyPercentage.toStringAsFixed(0)}%',
            '정상 비율',
            const Color(0xFF27AE60),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[200],
          ),
          _buildStatItem(
            '${statistics.averageIntervalDays.toStringAsFixed(1)}일',
            '평균 간격',
            const Color(0xFFFF6B35),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF666666),
          ),
        ),
      ],
    );
  }
}
