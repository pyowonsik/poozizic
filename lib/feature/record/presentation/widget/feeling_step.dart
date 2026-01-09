import 'package:flutter/material.dart';

class FeelingStep extends StatelessWidget {
  const FeelingStep({
    super.key,
    required this.selectedFeeling,
    required this.onFeelingSelected,
    required this.onNext,
  });

  final int? selectedFeeling;
  final ValueChanged<int> onFeelingSelected;
  final VoidCallback onNext;

  static const List<Map<String, String>> feelings = [
    {'emoji': '😊', 'label': '시원함'},
    {'emoji': '😐', 'label': '보통'},
    {'emoji': '😣', 'label': '불편함'},
    {'emoji': '😰', 'label': '잔변감'},
  ];

  @override
  Widget build(BuildContext context) {
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
            children: List.generate(feelings.length, (index) {
              final feeling = feelings[index];
              final isSelected = selectedFeeling == index;

              return GestureDetector(
                onTap: () => onFeelingSelected(index),
                child: Container(
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
              onPressed: selectedFeeling != null ? onNext : null,
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
