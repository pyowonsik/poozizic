import 'package:flutter/material.dart';

/// 운동 종류 선택 그리드 위젯
class ExerciseTypeGrid extends StatelessWidget {
  const ExerciseTypeGrid({
    super.key,
    required this.selectedExercise,
    required this.onExerciseSelected,
  });

  final int? selectedExercise;
  final ValueChanged<int> onExerciseSelected;

  static final List<Map<String, String>> _exercises = [
    {'emoji': '🏃', 'label': '달리기'},
    {'emoji': '🚶', 'label': '걷기'},
    {'emoji': '🚴', 'label': '자전거'},
    {'emoji': '🏊', 'label': '수영'},
    {'emoji': '🧘', 'label': '요가'},
    {'emoji': '🏋️', 'label': '웨이트'},
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.1,
      children: List.generate(_exercises.length, (index) {
        final exercise = _exercises[index];
        final isSelected = selectedExercise == index;

        return GestureDetector(
          onTap: () => onExerciseSelected(index),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
                  : Colors.white,
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF4CAF50)
                    : const Color(0xFFE0E0E0),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  exercise['emoji']!,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(height: 6),
                Text(
                  exercise['label']!,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? const Color(0xFF4CAF50)
                        : const Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
