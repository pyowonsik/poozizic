import 'package:flutter/material.dart';

// RecordScreen은 더 이상 사용되지 않습니다.
// 빠른 기록은 FloatingActionButton(+)을 통해 바로 열립니다.

// 더미 위젯 (사용되지 않음)
class RecordScreen extends StatelessWidget {
  const RecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('기록 화면'),
      ),
    );
  }
}

class BowelRecordFlow extends StatefulWidget {
  const BowelRecordFlow({super.key});

  @override
  State<BowelRecordFlow> createState() => _BowelRecordFlowState();
}

class _BowelRecordFlowState extends State<BowelRecordFlow> {
  int _currentStep = 0;
  int? _selectedBristolType = 3; // Type 4 (index 3)
  int? _selectedFeeling;
  double _selectedTime = 10;

  final List<Map<String, String>> _bristolTypes = [
    {'type': 'Type 1', 'desc': '딱딱한 덩어리'},
    {'type': 'Type 2', 'desc': '울퉁불퉁한 소시지'},
    {'type': 'Type 3', 'desc': '금 간 소시지'},
    {'type': 'Type 4', 'desc': '부드러운 소시지', 'badge': '이상적'},
    {'type': 'Type 5', 'desc': '부드러운 조각'},
    {'type': 'Type 6', 'desc': '흐트러진 조각'},
    {'type': 'Type 7', 'desc': '액체 상태'},
  ];

  final List<Map<String, String>> _feelings = [
    {'emoji': '😊', 'label': '시원함'},
    {'emoji': '😐', 'label': '보통'},
    {'emoji': '😣', 'label': '불편함'},
    {'emoji': '😰', 'label': '잔변감'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: Column(
        children: [
          // 진행 상황 바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(
                            right: index < 2 ? 8 : 0,
                          ),
                          decoration: BoxDecoration(
                            color: index <= _currentStep
                                ? const Color(0xFF5E35B1)
                                : const Color(0xFFE0E0E0),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${_currentStep + 1}/3',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // 헤더
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9C27B0).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bathroom,
                    color: Color(0xFF9C27B0),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '배변 기록',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: _buildStepContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildBristolTypeStep();
      case 1:
        return _buildFeelingStep();
      case 2:
        return _buildTimeStep();
      default:
        return Container();
    }
  }

  Widget _buildBristolTypeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '배변 상태를 선택하세요',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Bristol Scale 기준',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(_bristolTypes.length, (index) {
            final type = _bristolTypes[index];
            final isSelected = _selectedBristolType == index;
            final hasBadge = type.containsKey('badge');

            return GestureDetector(
              onTap: () => setState(() => _selectedBristolType = index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF5E35B1).withOpacity(0.1)
                      : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF5E35B1)
                        : const Color(0xFFE0E0E0),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getBristolColor(index),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                type['type']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              if (hasBadge) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4CAF50),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    type['badge']!,
                                    style: const TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            type['desc']!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      const Icon(
                        Icons.check_circle,
                        color: Color(0xFF5E35B1),
                        size: 24,
                      ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _currentStep = 1),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E35B1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '다음',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildFeelingStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '배변 후 느낌은요?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '솔직하게 선택해주세요',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 32),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: List.generate(_feelings.length, (index) {
              final feeling = _feelings[index];
              final isSelected = _selectedFeeling == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedFeeling = index),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF5E35B1).withOpacity(0.1)
                        : Colors.white,
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF5E35B1)
                          : const Color(0xFFE0E0E0),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        feeling['emoji']!,
                        style: const TextStyle(fontSize: 48),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        feeling['label']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedFeeling != null
                  ? () => setState(() => _currentStep = 2)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E35B1),
                disabledBackgroundColor: const Color(0xFFE0E0E0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                '다음',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTimeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '소요 시간은?',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '대략적인 시간을 선택하세요',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Text(
                  '${_selectedTime.toInt()}',
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5E35B1),
                  ),
                ),
                const Text(
                  '분',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 32),
                SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: const Color(0xFF5E35B1),
                    inactiveTrackColor: const Color(0xFFE0E0E0),
                    thumbColor: const Color(0xFF5E35B1),
                    overlayColor: const Color(0xFF5E35B1).withOpacity(0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                    ),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: _selectedTime,
                    min: 1,
                    max: 30,
                    divisions: 29,
                    onChanged: (value) {
                      setState(() => _selectedTime = value);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '1분',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                    Text(
                      '30분',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _selectedTime = 5);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '5분',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E35B1),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '10분',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _selectedTime = 15);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFE0E0E0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    '15분',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // 기록 완료
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('배변 기록이 완료되었습니다'),
                    backgroundColor: Color(0xFF4CAF50),
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E35B1),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.check, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    '기록 완료',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Color _getBristolColor(int index) {
    final colors = [
      const Color(0xFF3E2723), // Type 1: 진한 갈색
      const Color(0xFF5D4037), // Type 2: 갈색
      const Color(0xFF795548), // Type 3: 밝은 갈색
      const Color(0xFFD32F2F), // Type 4: 붉은색 (이상적)
      const Color(0xFFFFA726), // Type 5: 주황색
      const Color(0xFFFF7043), // Type 6: 연한 주황색
      const Color(0xFFEF5350), // Type 7: 빨간색
    ];
    return colors[index];
  }
}
