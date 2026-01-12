import 'package:flutter/material.dart';

/// 운동 시간 카드 위젯
class ExerciseDurationCard extends StatelessWidget {
  const ExerciseDurationCard({
    super.key,
    required this.duration,
    required this.onDurationChanged,
  });

  final int duration;
  final ValueChanged<int> onDurationChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '$duration',
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
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
              ),
              trackHeight: 4,
            ),
            child: Slider(
              value: duration.toDouble(),
              min: 5,
              max: 120,
              divisions: 23,
              onChanged: (value) => onDurationChanged(value.toInt()),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '5분',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
                  ),
                ),
                Text(
                  '120분',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF999999),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
