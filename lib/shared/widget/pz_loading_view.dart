import 'package:flutter/material.dart';

/// Poozizic 공통 로딩 뷰
class PzLoadingView extends StatelessWidget {
  final String? message;

  const PzLoadingView({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
            ),
          ],
        ],
      ),
    );
  }
}
