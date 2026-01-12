import 'package:flutter/material.dart';
import '../../domain/entity/calendar_statistics.dart';
import 'stat_item.dart';

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
          StatItem(
            value: '${statistics.totalRecordsThisMonth}',
            label: '이번 달',
            valueColor: Colors.black,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[200],
          ),
          StatItem(
            value: '${statistics.healthyPercentage.toStringAsFixed(0)}%',
            label: '정상 비율',
            valueColor: const Color(0xFF27AE60),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey[200],
          ),
          StatItem(
            value: '${statistics.averageIntervalDays.toStringAsFixed(1)}일',
            label: '평균 간격',
            valueColor: const Color(0xFFFF6B35),
          ),
        ],
      ),
    );
  }
}
