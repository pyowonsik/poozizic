import 'package:flutter/material.dart';
import '../provider/exercise_record_form_notifier.dart';

/// 운동 시간 슬라이더 위젯
class DurationSlider extends StatelessWidget {
  final double duration;
  final void Function(double duration) onDurationChanged;
  final void Function(int minutes) onQuickDurationSelected;

  const DurationSlider({
    super.key,
    required this.duration,
    required this.onDurationChanged,
    required this.onQuickDurationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Text(
                '${duration.toInt()}',
                style: const TextStyle(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4CAF50),
                ),
              ),
              const Text(
                '분',
                style: TextStyle(fontSize: 18, color: Color(0xFF666666)),
              ),
              const SizedBox(height: 20),
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFF4CAF50),
                  inactiveTrackColor: const Color(0xFFE0E0E0),
                  thumbColor: const Color(0xFF4CAF50),
                  overlayColor: const Color(0xFF4CAF50).withValues(alpha: 0.2),
                  thumbShape:
                      const RoundSliderThumbShape(enabledThumbRadius: 10),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: duration,
                  min: 5,
                  max: 120,
                  divisions: 23,
                  onChanged: onDurationChanged,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '5분',
                      style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
                    ),
                    Text(
                      '120분',
                      style: TextStyle(fontSize: 11, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // 빠른 시간 선택
        Row(
          children: List.generate(
              ExerciseRecordFormNotifier.quickDurations.length, (index) {
            final quickDuration =
                ExerciseRecordFormNotifier.quickDurations[index];
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: index <
                          ExerciseRecordFormNotifier.quickDurations.length - 1
                      ? 8
                      : 0,
                ),
                child: OutlinedButton(
                  onPressed: () => onQuickDurationSelected(quickDuration),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    side: const BorderSide(
                      color: Color(0xFFE0E0E0),
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '$quickDuration분',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
