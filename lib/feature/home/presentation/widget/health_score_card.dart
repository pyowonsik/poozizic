import 'package:flutter/material.dart';
import 'feedback_item.dart';
import 'score_row.dart';

/// 건강 점수 상세 카드 위젯
///
/// 건강 점수와 상세 피드백을 표시합니다.
class HealthScoreCard extends StatefulWidget {
  const HealthScoreCard({super.key});

  @override
  State<HealthScoreCard> createState() => _HealthScoreCardState();
}

class _HealthScoreCardState extends State<HealthScoreCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
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
                      const Text(
                        '91점',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF6B35),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 20),
                const ScoreRow(label: '배변 상태', score: '28/30점'),
                const SizedBox(height: 12),
                const ScoreRow(label: '배변 규칙성', score: '25/25점'),
                const SizedBox(height: 12),
                const ScoreRow(label: '수분 섭취', score: '15/20점'),
                const SizedBox(height: 12),
                const ScoreRow(label: '배변 편안함', score: '13/15점'),
                const SizedBox(height: 12),
                const ScoreRow(label: '배변 빈도', score: '10/10점'),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(
                            Icons.wb_sunny_outlined,
                            size: 20,
                            color: Color(0xFF9B59B6),
                          ),
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
                      const FeedbackItem(
                        text: '이상적인 배변 상태를 유지하고 있습니다',
                        isPositive: true,
                      ),
                      const FeedbackItem(
                        text: '규칙적인 배변 패턴을 보이고 있습니다',
                        isPositive: true,
                      ),
                      const FeedbackItem(
                        text: '물을 조금 더 마셔보세요',
                        isPositive: false,
                      ),
                      const FeedbackItem(
                        text: '편안한 배변을 하고 있습니다',
                        isPositive: true,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
