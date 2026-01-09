import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isHealthScoreExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Image.asset(
          'assets/image/뿌지직.png',
          height: 50,
          fit: BoxFit.contain,
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFF8F9FA),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // 오늘의 상태
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '오늘의 상태',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
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
                              '2시간 전',
                              const Color(0xFF27AE60),
                            ),
                            const SizedBox(height: 16),
                            _buildStatRow('연속 기록', '7일째 🔥', null),
                            const SizedBox(height: 16),
                            _buildStatRow('이번 주 배변', '5회', null),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // 오늘 수분 섭취
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            '오늘 수분 섭취',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF000000),
                            ),
                          ),
                          Text(
                            '1.5L / 2L',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF27AE60),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Stack(
                        children: [
                          Container(
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E0E0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.75,
                            child: Container(
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF27AE60),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // 이상적인 배변 상태 카드
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD5F5E3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: const [
                        Icon(
                          Icons.check_circle,
                          color: Color(0xFF27AE60),
                          size: 24,
                        ),
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
                ),

                const SizedBox(height: 20),

                // 건강 점수 상세
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isHealthScoreExpanded = !_isHealthScoreExpanded;
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
                                    _isHealthScoreExpanded
                                        ? Icons.keyboard_arrow_up
                                        : Icons.keyboard_arrow_right,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (_isHealthScoreExpanded) ...[
                            const SizedBox(height: 20),
                            _buildScoreRow('배변 상태', '28/30점'),
                            const SizedBox(height: 12),
                            _buildScoreRow('배변 규칙성', '25/25점'),
                            const SizedBox(height: 12),
                            _buildScoreRow('수분 섭취', '15/20점'),
                            const SizedBox(height: 12),
                            _buildScoreRow('배변 편안함', '13/15점'),
                            const SizedBox(height: 12),
                            _buildScoreRow('배변 빈도', '10/10점'),
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
                                  _buildFeedbackItem(
                                    '이상적인 배변 상태를 유지하고 있습니다',
                                    true,
                                  ),
                                  _buildFeedbackItem(
                                    '규칙적인 배변 패턴을 보이고 있습니다',
                                    true,
                                  ),
                                  _buildFeedbackItem('물을 조금 더 마셔보세요', false),
                                  _buildFeedbackItem('편안한 배변을 하고 있습니다', true),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 최근 기록
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '최근 기록',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          children: [
                            const Text(
                              '캘린더로 보기',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.chevron_right,
                              size: 18,
                              color: Colors.grey[400],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // 날짜 네비게이션
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () {
                            setState(() {
                              _selectedDate = _selectedDate.subtract(
                                const Duration(days: 1),
                              );
                            });
                          },
                        ),
                        Text(
                          _getDateText(_selectedDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF000000),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () {
                            setState(() {
                              _selectedDate = _selectedDate.add(
                                const Duration(days: 1),
                              );
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // 기록 목록
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _buildRecordCard(
                        emoji: '💩',
                        title: 'Bristol Type 4 - 부드러운 소시지',
                        subtitle: '배변 기록',
                        time: '08:30',
                        backgroundColor: const Color(0xFF90EE90),
                      ),
                      const SizedBox(height: 12),
                      _buildRecordCard(
                        emoji: '👕',
                        title: '식사 3회 기록됨',
                        subtitle: '식단 기록',
                        time: '오늘',
                        backgroundColor: const Color(0xFFD8BFD8),
                      ),
                      const SizedBox(height: 12),
                      _buildRecordCard(
                        emoji: '💧',
                        title: '수분 6회 (1500ml)',
                        subtitle: '수분 섭취 기록',
                        time: '오늘',
                        backgroundColor: const Color(0xFF87CEEB),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: const [
                            Text('💡', style: TextStyle(fontSize: 24)),
                            SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '축가 팁',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Color(0xFF27AE60),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '규칙적인 배변 패턴을 보이고 있습니다',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFF1976D2),
                                        ),
                                      ),
                                    ],
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

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
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

  Widget _buildRecordCard({
    required String emoji,
    required String title,
    required String subtitle,
    required String time,
    required Color backgroundColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
          ),
        ],
      ),
    );
  }

  String _getDateText(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);

    if (selected == today) {
      return DateFormat('M월 d일 (E)', 'ko_KR').format(date);
    } else {
      return DateFormat('M월 d일 (E)', 'ko_KR').format(date);
    }
  }
}
