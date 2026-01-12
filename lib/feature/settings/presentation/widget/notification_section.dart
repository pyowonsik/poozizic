import 'package:flutter/material.dart';
import '../../domain/entity/settings_entity.dart';
import 'settings_switch_tile.dart';

class NotificationSection extends StatelessWidget {
  const NotificationSection({
    super.key,
    required this.settings,
    required this.onBowelReminderChanged,
    required this.onWaterReminderChanged,
    required this.onWeeklyReportChanged,
  });

  final SettingsEntity settings;
  final ValueChanged<bool> onBowelReminderChanged;
  final ValueChanged<bool> onWaterReminderChanged;
  final ValueChanged<bool> onWeeklyReportChanged;

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
                Icon(Icons.notifications_outlined, color: Color(0xFFFF6B35), size: 20),
                SizedBox(width: 8),
                Text(
                  '알림',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          SettingsSwitchTile(
            title: '배변 기록 리마인더',
            value: settings.bowelReminder,
            onChanged: onBowelReminderChanged,
          ),
          SettingsSwitchTile(
            title: '수분 섭취 알림',
            value: settings.waterReminder,
            onChanged: onWaterReminderChanged,
          ),
          SettingsSwitchTile(
            title: '주간 리포트',
            value: settings.weeklyReport,
            onChanged: onWeeklyReportChanged,
          ),
        ],
      ),
    );
  }
}
