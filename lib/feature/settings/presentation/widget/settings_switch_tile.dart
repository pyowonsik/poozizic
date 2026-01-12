import 'package:flutter/material.dart';

/// 설정 스위치 타일 위젯
///
/// 설정 페이지의 스위치 형태 옵션을 표시합니다.
class SettingsSwitchTile extends StatelessWidget {
  const SettingsSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF000000),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFFFF6B35),
            activeTrackColor: const Color(0xFFFF6B35).withValues(alpha: 0.5),
          ),
        ],
      ),
    );
  }
}
