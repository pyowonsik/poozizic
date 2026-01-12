import 'package:flutter/material.dart';

/// Poozizic 공통 에러 뷰
class PzErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String? title;
  final bool showBackButton;
  final VoidCallback? onBack;
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  const PzErrorView({
    required this.message,
    required this.onRetry,
    this.title,
    this.showBackButton = false,
    this.onBack,
    this.icon = Icons.error_outline,
    this.iconSize = 64,
    this.iconColor = Colors.red,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: iconSize, color: iconColor),
            const SizedBox(height: 16),
            if (title != null) ...[
              Text(
                title!,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('다시 시도'),
            ),
            if (showBackButton && onBack != null) ...[
              const SizedBox(height: 12),
              TextButton(
                onPressed: onBack,
                child: const Text('뒤로 가기'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
