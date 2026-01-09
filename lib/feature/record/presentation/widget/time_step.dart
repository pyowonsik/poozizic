import 'package:flutter/material.dart';

class TimeStep extends StatelessWidget {
  const TimeStep({
    super.key,
    required this.selectedDuration,
    required this.onDurationChanged,
    required this.onSubmit,
    required this.isSubmitting,
  });

  final int selectedDuration;
  final ValueChanged<int> onDurationChanged;
  final VoidCallback onSubmit;
  final bool isSubmitting;

  @override
  Widget build(BuildContext context) {
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
                  '$selectedDuration',
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
                    overlayColor: const Color(0xFF5E35B1).withValues(alpha: 0.2),
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 12,
                    ),
                    trackHeight: 4,
                  ),
                  child: Slider(
                    value: selectedDuration.toDouble(),
                    min: 1,
                    max: 30,
                    divisions: 29,
                    onChanged: (value) => onDurationChanged(value.toInt()),
                  ),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                  onPressed: () => onDurationChanged(5),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: selectedDuration == 5
                          ? const Color(0xFF5E35B1)
                          : const Color(0xFFE0E0E0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '5분',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedDuration == 5
                          ? const Color(0xFF5E35B1)
                          : const Color(0xFF666666),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onDurationChanged(10),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: selectedDuration == 10
                          ? const Color(0xFF5E35B1)
                          : const Color(0xFFE0E0E0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '10분',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: selectedDuration == 10
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: selectedDuration == 10
                          ? const Color(0xFF5E35B1)
                          : const Color(0xFF666666),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => onDurationChanged(15),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(
                      color: selectedDuration == 15
                          ? const Color(0xFF5E35B1)
                          : const Color(0xFFE0E0E0),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    '15분',
                    style: TextStyle(
                      fontSize: 14,
                      color: selectedDuration == 15
                          ? const Color(0xFF5E35B1)
                          : const Color(0xFF666666),
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
              onPressed: isSubmitting ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E35B1),
                disabledBackgroundColor: const Color(0xFFE0E0E0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
}
