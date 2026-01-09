import 'package:flutter/material.dart';
import '../../domain/entity/settings_entity.dart';

class GoalSection extends StatelessWidget {
  const GoalSection({
    super.key,
    required this.settings,
    required this.onWaterGoalTap,
    required this.onBowelGoalTap,
  });

  final SettingsEntity settings;
  final VoidCallback onWaterGoalTap;
  final VoidCallback onBowelGoalTap;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
            onTap: onWaterGoalTap,
          ),
          _buildListTile(
            title: '이상적인 배변 횟수',
            trailing: Text(
              '${settings.bowelGoal}회/일',
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF999999),
              ),
            ),
            onTap: onBowelGoalTap,
          ),
        ],
      ),
    );
  }

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
              style: const TextStyle(
                fontSize: 15,
                color: Color(0xFF000000),
              ),
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
