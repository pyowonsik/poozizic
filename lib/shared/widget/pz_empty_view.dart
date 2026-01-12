import 'package:flutter/material.dart';

/// Poozizic 공통 빈 상태 뷰
class PzEmptyView extends StatelessWidget {
  final String message;
  final IconData? icon;
  final double iconSize;
  final Color iconColor;

  const PzEmptyView({
    required this.message,
    this.icon,
    this.iconSize = 64,
    this.iconColor = const Color(0xFFE0E0E0),
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: iconSize, color: iconColor),
            const SizedBox(height: 16),
          ],
          Text(
            message,
            style: const TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
