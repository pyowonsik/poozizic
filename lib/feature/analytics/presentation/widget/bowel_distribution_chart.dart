import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:poozizic/feature/analytics/domain/entity/bowel_distribution_entity.dart';

/// 배변 상태 분포 차트 위젯
class BowelDistributionChart extends StatelessWidget {
  /// 배변 상태 분포 차트 위젯 생성자
  /// [distribution] 배변 상태 분포 엔티티
  const BowelDistributionChart({required this.distribution, super.key});

  /// 배변 상태 분포 차트 위젯
  final BowelDistributionEntity distribution;

  @override
  Widget build(BuildContext context) {
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
                      sections: _buildSections(),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLegendItem(
                        'Type 1-2',
                        distribution.type1_2Text,
                        const Color(0xFFFF9800),
                      ),
                      const SizedBox(height: 12),
                      _buildLegendItem(
                        'Type 3-4',
                        distribution.type3_4Text,
                        const Color(0xFF4CAF50),
                      ),
                      const SizedBox(height: 12),
                      _buildLegendItem(
                        'Type 5-6',
                        distribution.type5_6Text,
                        const Color(0xFF9E9E9E),
                      ),
                      const SizedBox(height: 12),
                      _buildLegendItem(
                        'Type 7',
                        distribution.type7Text,
                        const Color(0xFFE0E0E0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final sections = <PieChartSectionData>[];

    // 데이터가 없으면 빈 차트 표시
    if (distribution.total == 0) {
      return [
        PieChartSectionData(
          value: 1,
          title: '',
          color: const Color(0xFFE0E0E0),
          radius: 35,
        ),
      ];
    }

    // Type 1-2 (딱딱)
    if (distribution.type1_2Count > 0) {
      sections.add(
        PieChartSectionData(
          value: distribution.type1_2Count.toDouble(),
          title: '',
          color: const Color(0xFFFF9800),
          radius: 35,
        ),
      );
    }

    // Type 3-4 (정상)
    if (distribution.type3_4Count > 0) {
      sections.add(
        PieChartSectionData(
          value: distribution.type3_4Count.toDouble(),
          title: '',
          color: const Color(0xFF4CAF50),
          radius: 35,
        ),
      );
    }

    // Type 5-6 (무른)
    if (distribution.type5_6Count > 0) {
      sections.add(
        PieChartSectionData(
          value: distribution.type5_6Count.toDouble(),
          title: '',
          color: const Color(0xFF9E9E9E),
          radius: 35,
        ),
      );
    }

    // Type 7 (설사)
    if (distribution.type7Count > 0) {
      sections.add(
        PieChartSectionData(
          value: distribution.type7Count.toDouble(),
          title: '',
          color: const Color(0xFFE0E0E0),
          radius: 35,
        ),
      );
    }

    // 최소 1개 섹션 보장
    if (sections.isEmpty) {
      sections.add(
        PieChartSectionData(
          value: 1,
          title: '',
          color: const Color(0xFFE0E0E0),
          radius: 35,
        ),
      );
    }

    return sections;
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}
