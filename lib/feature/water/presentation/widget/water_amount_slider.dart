import 'package:flutter/material.dart';

/// 수분 양 슬라이더 위젯
class WaterAmountSlider extends StatelessWidget {
  const WaterAmountSlider({
    super.key,
    required this.amount,
    required this.onChanged,
  });

  final double amount;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            activeTrackColor: const Color(0xFF2196F3),
            inactiveTrackColor: const Color(0xFFB3E5FC),
            thumbColor: const Color(0xFF2196F3),
            overlayColor: const Color(0xFF2196F3).withValues(alpha: 0.2),
            thumbShape: const RoundSliderThumbShape(
              enabledThumbRadius: 12,
            ),
            trackHeight: 6,
          ),
          child: Slider(
            value: amount,
            min: 50,
            max: 1000,
            divisions: 95,
            onChanged: onChanged,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '50ml',
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
              Text(
                '1000ml',
                style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
