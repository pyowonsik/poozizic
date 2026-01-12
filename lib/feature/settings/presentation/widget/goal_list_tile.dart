import 'package:flutter/material.dart';

/// 목표 리스트 타일 위젯
///
/// 목표 섹션의 리스트 타일을 표시합니다.
class GoalListTile extends StatelessWidget {
  const GoalListTile({
    super.key,
    required this.title,
    this.trailing,
    this.onTap,
  });

  final String title;
  final Widget? trailing;
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
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF000000),
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
