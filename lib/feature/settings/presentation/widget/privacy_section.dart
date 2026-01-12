import 'package:flutter/material.dart';
import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';

/// 프라이버시 섹션 위젯
class PrivacySection extends StatelessWidget {
  /// 프라이버시 섹션 위젯 생성자
  /// [settings] 설정 엔티티
  /// [onAppLockChanged] 앱 잠금 변경 콜백
  /// [onHideNotificationContentChanged] 알림에서 내용 숨김 변경 콜백
  /// [onCloudBackupChanged] 클라우드 백업 변경 콜백
  const PrivacySection({
    required this.settings,
    required this.onAppLockChanged,
    required this.onHideNotificationContentChanged,
    required this.onCloudBackupChanged,
    super.key,
  });

  /// 설정 엔티티
  final SettingsEntity settings;

  /// 앱 잠금 변경 콜백
  final ValueChanged<bool> onAppLockChanged;

  /// 알림에서 내용 숨김 변경 콜백
  final ValueChanged<bool> onHideNotificationContentChanged;

  /// 클라우드 백업 변경 콜백
  final ValueChanged<bool> onCloudBackupChanged;

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
                Icon(Icons.lock_outline, color: Color(0xFFFF6B35), size: 20),
                SizedBox(width: 8),
                Text(
                  '프라이버시',
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
            title: '앱 잠금',
            value: settings.appLock,
            onChanged: onAppLockChanged,
          ),
          _buildSwitchTile(
            title: '알림에서 내용 숨김',
            value: settings.hideNotificationContent,
            onChanged: onHideNotificationContentChanged,
          ),
          _buildSwitchTile(
            title: '클라우드 백업',
            value: settings.cloudBackup,
            onChanged: onCloudBackupChanged,
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
