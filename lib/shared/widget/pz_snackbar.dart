import 'package:flutter/material.dart';

/// Poozizic 스낵바 타입
enum PzSnackBarType { success, error, warning, info }

/// Poozizic 공통 스낵바
class PzSnackBar {
  static void show(
    BuildContext context,
    String message, {
    PzSnackBarType type = PzSnackBarType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    final colors = _getColors(type);
    final icon = _getIcon(type);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: colors,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) =>
      show(context, message, type: PzSnackBarType.success);

  static void showError(BuildContext context, String message) =>
      show(context, message,
          type: PzSnackBarType.error, duration: const Duration(seconds: 3));

  static void showWarning(BuildContext context, String message) =>
      show(context, message, type: PzSnackBarType.warning);

  static void showInfo(BuildContext context, String message) =>
      show(context, message, type: PzSnackBarType.info);

  static Color _getColors(PzSnackBarType type) {
    switch (type) {
      case PzSnackBarType.success:
        return Colors.green;
      case PzSnackBarType.error:
        return Colors.red;
      case PzSnackBarType.warning:
        return Colors.orange;
      case PzSnackBarType.info:
        return Colors.blue;
    }
  }

  static IconData _getIcon(PzSnackBarType type) {
    switch (type) {
      case PzSnackBarType.success:
        return Icons.check_circle;
      case PzSnackBarType.error:
        return Icons.error;
      case PzSnackBarType.warning:
        return Icons.warning;
      case PzSnackBarType.info:
        return Icons.info;
    }
  }
}
