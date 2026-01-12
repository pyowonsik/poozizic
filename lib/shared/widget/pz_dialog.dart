import 'package:flutter/material.dart';

/// Poozizic 공통 다이얼로그
class PzDialog {
  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String content,
    String confirmText = '확인',
    String cancelText = '취소',
    Color? confirmColor,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: confirmColor,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
