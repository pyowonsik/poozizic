import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// 분석 막대 그룹 위젯
///
/// 주간 배변 빈도 차트의 각 막대 그룹을 생성합니다.
class AnalyticsBarGroup {
  const AnalyticsBarGroup._();

  static BarChartGroupData create(int x, double value) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: value,
          color: const Color(0xFFFF6B35),
          width: 20,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(4),
            topRight: Radius.circular(4),
          ),
        ),
      ],
    );
  }
}
