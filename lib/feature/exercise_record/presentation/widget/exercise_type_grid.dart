import 'package:flutter/material.dart';
import 'package:poozizic/feature/exercise_record/presentation/provider/exercise_record_form_notifier.dart';

/// 운동 종류 그리드 위젯
class ExerciseTypeGrid extends StatelessWidget {
  /// 운동 종류 그리드 위젯 생성자
  /// [selectedExercise] 선택된 운동 타입
  /// [onExerciseSelected] 운동 타입 선택 콜백
  const ExerciseTypeGrid({
    required this.selectedExercise,
    required this.onExerciseSelected,
    super.key,
  });

  /// 선택된 운동 타입
  final int? selectedExercise;

  /// 운동 타입 선택 콜백
  final void Function(int index) onExerciseSelected;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.1,
      children: List.generate(ExerciseRecordFormNotifier.exerciseTypes.length, (
        index,
      ) {
        final exercise = ExerciseRecordFormNotifier.exerciseTypes[index];
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
                Text(exercise.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(height: 6),
                Text(
                  exercise.label,
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
