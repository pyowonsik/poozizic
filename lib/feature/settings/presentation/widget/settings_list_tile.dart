import 'package:flutter/material.dart';

/// 설정 리스트 타일 위젯
///
/// 설정 페이지의 각 항목을 표시합니다.
class SettingsListTile extends StatelessWidget {
  const SettingsListTile({
    super.key,
    required this.title,
    this.trailing,
    this.titleColor,
    this.onTap,
  });

  final String title;
  final Widget? trailing;
  final Color? titleColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: titleColor ?? const Color(0xFF000000),
              ),
            ),
            if (trailing != null)
              trailing!
            else if (onTap != null)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFCCCCCC),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}
