import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import 'package:poozizic/feature/analytics/domain/entity/weekly_frequency_entity.dart';

/// 주간 배변 빈도 차트 위젯
class WeeklyFrequencyChart extends StatelessWidget {
  /// 주간 배변 빈도 차트 위젯 생성자
  /// [weeklyFrequency] 주간 배변 빈도 엔티티
  const WeeklyFrequencyChart({required this.weeklyFrequency, super.key});

  /// 주간 배변 빈도 엔티티
  final WeeklyFrequencyEntity weeklyFrequency;

  /// 주간 배변 빈도 차트 위젯 생성자
  @override
  Widget build(BuildContext context) {
    final maxY = (weeklyFrequency.maxDailyCount + 1).toDouble();

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '주간 배변 빈도',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: maxY > 0 ? maxY : 2.5,
                barTouchData: BarTouchData(enabled: false),
                gridData: FlGridData(
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey[200], strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 &&
                            value.toInt() <
                                WeeklyFrequencyEntity.dayLabels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              WeeklyFrequencyEntity.dayLabels[value.toInt()],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value % 1 == 0) {
                          return Text(
                            '${value.toInt()}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF999999),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(7, (index) {
      final count = index < weeklyFrequency.dailyCounts.length
          ? weeklyFrequency.dailyCounts[index]
          : 0;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: count.toDouble(),
            color: const Color(0xFFFF6B35),
            width: 20,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(4),
              topRight: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }
}
