import 'package:flutter/material.dart';

/// 물방울 카드 위젯
class WaterAmountCard extends StatelessWidget {
  /// 물방울 카드 위젯 생성자
  /// [waterAmount] 수분량
  const WaterAmountCard({required this.waterAmount, super.key});

  /// 수분량
  final double waterAmount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          const Icon(Icons.water_drop, color: Colors.white, size: 40),
          const SizedBox(height: 12),
          Text(
            '${waterAmount.toInt()}',
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text('ml', style: TextStyle(fontSize: 20, color: Colors.white)),
        ],
      ),
    );
  }
}
