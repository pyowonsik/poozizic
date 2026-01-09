import 'package:flutter/material.dart';
import '../../domain/entity/settings_entity.dart';

class PrivacySection extends StatelessWidget {
  const PrivacySection({
    super.key,
    required this.settings,
    required this.onAppLockChanged,
    required this.onHideNotificationContentChanged,
    required this.onCloudBackupChanged,
  });

  final SettingsEntity settings;
  final ValueChanged<bool> onAppLockChanged;
  final ValueChanged<bool> onHideNotificationContentChanged;
  final ValueChanged<bool> onCloudBackupChanged;

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
