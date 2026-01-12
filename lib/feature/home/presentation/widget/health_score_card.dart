import 'package:flutter/material.dart';
import 'package:poozizic/feature/home/domain/entity/health_score_entity.dart';

/// 건강 점수 카드 위젯
class HealthScoreCard extends StatelessWidget {
  /// 건강 점수 카드 위젯 생성자
  /// 건강 점수 카드 위젯 생성자
  /// [healthScore] 건강 점수 엔티티
  /// [isExpanded] 건강 점수 카드 위젯 확장 여부
  /// [onTap] 건강 점수 카드 위젯 확장 탭 콜백
  const HealthScoreCard({
    required this.healthScore,
    required this.isExpanded,
    required this.onTap,
    super.key,
  });

  /// 건강 점수 엔티티
  final HealthScoreEntity healthScore;

  /// 건강 점수 카드 위젯 확장 여부
  final bool isExpanded;

  /// 건강 점수 카드 위젯 확장 탭 콜백
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 이상적인 상태 배너
        if (healthScore.isIdeal)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFD5F5E3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '이상적인 배변 상태를 유지하고 있습니다',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E8449),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

        // 점수 카드
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: double.infinity,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '건강 점수 상세',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '${healthScore.totalScore}점',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B35),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_right,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ],
                ),
                if (isExpanded) ...[
                  const SizedBox(height: 20),
                  _buildScoreRow('배변 상태', healthScore.bowelConditionText),
                  const SizedBox(height: 12),
                  _buildScoreRow('배변 규칙성', healthScore.bowelRegularityText),
                  const SizedBox(height: 12),
                  _buildScoreRow('수분 섭취', healthScore.waterIntakeText),
                  const SizedBox(height: 12),
                  _buildScoreRow('배변 편안함', healthScore.bowelComfortText),
                  const SizedBox(height: 12),
                  _buildScoreRow('배변 빈도', healthScore.bowelFrequencyText),
                  const SizedBox(height: 20),
                  _buildFeedbackSection(),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreRow(String label, String score) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        Text(
          score,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  Widget _buildFeedbackSection() {
    final allFeedbacks = [
      ...healthScore.positiveFeedbacks.map((f) => (f, true)),
      ...healthScore.negativeFeedbacks.map((f) => (f, false)),
    ];

    if (allFeedbacks.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.wb_sunny_outlined, size: 20, color: Color(0xFF9B59B6)),
              SizedBox(width: 8),
              Text(
                '피드백',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...allFeedbacks.map((f) => _buildFeedbackItem(f.$1, f.$2)),
        ],
      ),
    );
  }

  Widget _buildFeedbackItem(String text, bool isPositive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isPositive ? Icons.check : Icons.warning_amber_rounded,
            size: 16,
            color: isPositive
                ? const Color(0xFF27AE60)
                : const Color(0xFFF39C12),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 13, color: Color(0xFF666666)),
            ),
          ),
        ],
      ),
    );
  }
}
