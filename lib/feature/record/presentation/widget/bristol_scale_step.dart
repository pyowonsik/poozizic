import 'package:flutter/material.dart';

class BristolScaleStep extends StatelessWidget {
  const BristolScaleStep({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
    required this.onNext,
  });

  final int? selectedType;
  final ValueChanged<int> onTypeSelected;
  final VoidCallback onNext;

  static const List<Map<String, String>> bristolTypes = [
    {'type': 'Type 1', 'desc': '딱딱한 덩어리'},
    {'type': 'Type 2', 'desc': '울퉁불퉁한 소시지'},
    {'type': 'Type 3', 'desc': '금 간 소시지'},
    {'type': 'Type 4', 'desc': '부드러운 소시지', 'badge': '이상적'},
    {'type': 'Type 5', 'desc': '부드러운 조각'},
    {'type': 'Type 6', 'desc': '흐트러진 조각'},
    {'type': 'Type 7', 'desc': '액체 상태'},
  ];

  Color _getBristolColor(int index) {
    const colors = [
      Color(0xFF3E2723),
      Color(0xFF5D4037),
      Color(0xFF795548),
      Color(0xFFD32F2F),
      Color(0xFFFFA726),
      Color(0xFFFF7043),
      Color(0xFFEF5350),
    ];
    return colors[index];
  }

  @override
  Widget build(BuildContext context) {
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
          ...List.generate(bristolTypes.length, (index) {
            final type = bristolTypes[index];
            final isSelected = selectedType == index;
            final hasBadge = type.containsKey('badge');

            return GestureDetector(
              onTap: () => onTypeSelected(index),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF5E35B1).withValues(alpha: 0.1)
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
              onPressed: selectedType != null ? onNext : null,
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
}
