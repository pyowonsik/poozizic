import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widget/widget.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '분석',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '최근 30일 데이터 기준',
              style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
            ),
            const SizedBox(height: 16),

            // 상단 통계 카드 3개
            const Row(
              children: [
                Expanded(
                  child: StatCard(
                    value: '85',
                    label: '건강 점수',
                    valueColor: Color(0xFFFF6B35),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    value: '90%',
                    label: '정상 비율',
                    valueColor: Color(0xFF4CAF50),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    value: '1.2일',
                    label: '평균 간격',
                    valueColor: Color(0xFFFF6B35),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // 배변 상태 분포 (도넛 차트)
            Container(
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
                    '배변 상태 분포',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    height: 200,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: PieChart(
                            PieChartData(
                              sectionsSpace: 3,
                              centerSpaceRadius: 50,
                              startDegreeOffset: -90,
                              sections: [
                                PieChartSectionData(
                                  value: 1,
                                  title: '',
                                  color: const Color(0xFFFF9800),
                                  radius: 35,
                                ),
                                PieChartSectionData(
                                  value: 4,
                                  title: '',
                                  color: const Color(0xFF4CAF50),
                                  radius: 35,
                                ),
                                PieChartSectionData(
                                  value: 0.1,
                                  title: '',
                                  color: const Color(0xFFE0E0E0),
                                  radius: 35,
                                ),
                                PieChartSectionData(
                                  value: 0.1,
                                  title: '',
                                  color: const Color(0xFFE0E0E0),
                                  radius: 35,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Expanded(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              LegendItem(
                                label: 'Type 1-2',
                                value: '1회',
                                color: Color(0xFFFF9800),
                              ),
                              SizedBox(height: 12),
                              LegendItem(
                                label: 'Type 3-4',
                                value: '4회',
                                color: Color(0xFF4CAF50),
                              ),
                              SizedBox(height: 12),
                              LegendItem(
                                label: 'Type 5-6',
                                value: '0회',
                                color: Color(0xFFE0E0E0),
                              ),
                              SizedBox(height: 12),
                              LegendItem(
                                label: 'Type 7',
                                value: '0회',
                                color: Color(0xFFE0E0E0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 주간 배변 빈도 (막대 그래프)
            Container(
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
                        maxY: 2.5,
                        barTouchData: BarTouchData(enabled: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 0.5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.grey[200]!,
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                const days = [
                                  '월',
                                  '화',
                                  '수',
                                  '목',
                                  '금',
                                  '토',
                                  '일',
                                ];
                                if (value.toInt() >= 0 &&
                                    value.toInt() < days.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      days[value.toInt()],
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
                              interval: 0.5,
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
                        barGroups: [
                          AnalyticsBarGroup.create(0, 1),
                          AnalyticsBarGroup.create(1, 1),
                          AnalyticsBarGroup.create(2, 2),
                          AnalyticsBarGroup.create(3, 1),
                          AnalyticsBarGroup.create(4, 1),
                          AnalyticsBarGroup.create(5, 0),
                          AnalyticsBarGroup.create(6, 1),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 인사이트 카드들
            const InsightCard(
              icon: Icons.check_circle,
              iconColor: Color(0xFF4CAF50),
              backgroundColor: Color(0xFFE8F5E9),
              title: '정상 패턴 유지',
              description: '최근 배변 상태가 이상적인 범위에 있습니다.',
            ),

            const SizedBox(height: 12),

            const InsightCard(
              icon: Icons.water_drop,
              iconColor: Color(0xFF2196F3),
              backgroundColor: Color(0xFFE3F2FD),
              title: '수분 섭취 우수',
              description: '충분한 수분 섭취가 건강한 배변을 돕고 있습니다.',
            ),

            const SizedBox(height: 12),

            const InsightCard(
              icon: Icons.access_time,
              iconColor: Color(0xFFFF9800),
              backgroundColor: Color(0xFFFFF3E0),
              title: '규칙적인 시간',
              description: '일정한 시간대에 배변하는 습관이 좋습니다.',
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

}
