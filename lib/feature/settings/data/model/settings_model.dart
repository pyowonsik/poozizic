import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';

/// 설정 모델
class SettingsModel extends SettingsEntity {
  /// 설정 모델 생성자
  const SettingsModel({
    super.waterGoal,
    super.bowelGoal,
    super.bowelReminder,
    super.waterReminder,
    super.weeklyReport,
    super.appLock,
    super.hideNotificationContent,
    super.cloudBackup,
    this.userId,
  });

  /// JSON에서 모델 생성
  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      userId: json['user_id'] as String?,
      waterGoal: json['water_goal'] as int? ?? 2000,
      bowelGoal: json['bowel_goal'] as int? ?? 1,
      bowelReminder: json['bowel_reminder'] as bool? ?? true,
      waterReminder: json['water_reminder'] as bool? ?? true,
      weeklyReport: json['weekly_report'] as bool? ?? true,
      appLock: json['app_lock'] as bool? ?? false,
      hideNotificationContent:
          json['hide_notification_content'] as bool? ?? false,
      cloudBackup: json['cloud_backup'] as bool? ?? false,
    );
  }

  /// Entity에서 모델 생성
  factory SettingsModel.fromEntity(SettingsEntity entity, {String? userId}) {
    return SettingsModel(
      waterGoal: entity.waterGoal,
      bowelGoal: entity.bowelGoal,
      bowelReminder: entity.bowelReminder,
      waterReminder: entity.waterReminder,
      weeklyReport: entity.weeklyReport,
      appLock: entity.appLock,
      hideNotificationContent: entity.hideNotificationContent,
      cloudBackup: entity.cloudBackup,
      userId: userId,
    );
  }

  /// 사용자 ID
  final String? userId;

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'user_id': userId,
      'water_goal': waterGoal,
      'bowel_goal': bowelGoal,
      'bowel_reminder': bowelReminder,
      'water_reminder': waterReminder,
      'weekly_report': weeklyReport,
      'app_lock': appLock,
      'hide_notification_content': hideNotificationContent,
      'cloud_backup': cloudBackup,
    };
  }

  @override
  SettingsModel copyWith({
    int? waterGoal,
    int? bowelGoal,
    bool? bowelReminder,
    bool? waterReminder,
    bool? weeklyReport,
    bool? appLock,
    bool? hideNotificationContent,
    bool? cloudBackup,
    String? userId,
  }) {
    return SettingsModel(
      waterGoal: waterGoal ?? this.waterGoal,
      bowelGoal: bowelGoal ?? this.bowelGoal,
      bowelReminder: bowelReminder ?? this.bowelReminder,
      waterReminder: waterReminder ?? this.waterReminder,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      appLock: appLock ?? this.appLock,
      hideNotificationContent:
          hideNotificationContent ?? this.hideNotificationContent,
      cloudBackup: cloudBackup ?? this.cloudBackup,
      userId: userId ?? this.userId,
    );
  }
}
