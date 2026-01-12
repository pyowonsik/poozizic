import 'package:flutter/material.dart';
import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';

/// 알림 섹션 위젯
class NotificationSection extends StatelessWidget {
  /// 알림 섹션 위젯 생성자
  /// [settings] 설정 엔티티
  /// [onBowelReminderChanged] 배변 기록 리마인더 변경 콜백
  /// [onWaterReminderChanged] 수분 섭취 알림 변경 콜백
  /// [onWeeklyReportChanged] 주간 리포트 변경 콜백
  const NotificationSection({
    required this.settings,
    required this.onBowelReminderChanged,
    required this.onWaterReminderChanged,
    required this.onWeeklyReportChanged,
    super.key,
  });

  /// 설정 엔티티
  final SettingsEntity settings;

  /// 배변 기록 리마인더 변경 콜백
  final ValueChanged<bool> onBowelReminderChanged;

  /// 수분 섭취 알림 변경 콜백
  final ValueChanged<bool> onWaterReminderChanged;

  /// 주간 리포트 변경 콜백
  final ValueChanged<bool> onWeeklyReportChanged;

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
                Icon(
                  Icons.notifications_outlined,
                  color: Color(0xFFFF6B35),
                  size: 20,
                ),
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
          _buildSwitchTile(
            title: '배변 기록 리마인더',
            value: settings.bowelReminder,
            onChanged: onBowelReminderChanged,
          ),
          _buildSwitchTile(
            title: '수분 섭취 알림',
            value: settings.waterReminder,
            onChanged: onWaterReminderChanged,
          ),
          _buildSwitchTile(
            title: '주간 리포트',
            value: settings.weeklyReport,
            onChanged: onWeeklyReportChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Color(0xFF000000)),
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
