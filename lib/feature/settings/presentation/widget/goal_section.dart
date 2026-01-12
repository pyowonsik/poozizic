import 'package:flutter/material.dart';
import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';

/// 목표 섹션 위젯
class GoalSection extends StatelessWidget {
  /// 목표 섹션 위젯 생성자
  /// [settings] 설정 엔티티
  /// [onWaterGoalTap] 수분 목표 탭 콜백
  /// [onBowelGoalTap] 배변 목표 탭 콜백
  const GoalSection({
    required this.settings,
    required this.onWaterGoalTap,
    required this.onBowelGoalTap,
    super.key,
  });

  /// 설정 엔티티
  final SettingsEntity settings;

  /// 수분 목표 탭 콜백
  final VoidCallback onWaterGoalTap;

  /// 배변 목표 탭 콜백
  final VoidCallback onBowelGoalTap;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Icon(Icons.flag_outlined, color: Color(0xFFFF6B35), size: 20),
                SizedBox(width: 8),
                Text(
                  '목표',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          _buildListTile(
            title: '일일 수분 목표',
            trailing: Text(
              '${settings.waterGoal}ml',
              style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
            ),
            onTap: onWaterGoalTap,
          ),
          _buildListTile(
            title: '이상적인 배변 횟수',
            trailing: Text(
              '${settings.bowelGoal}회/일',
              style: const TextStyle(fontSize: 14, color: Color(0xFF999999)),
            ),
            onTap: onBowelGoalTap,
          ),
        ],
      ),
    );
  }

  /// 리스트 타일 위젯 생성
  Widget _buildListTile({
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
            ),
            if (trailing != null)
              trailing
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
