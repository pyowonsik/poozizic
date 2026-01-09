/// 설정 Entity
class SettingsEntity {
  // 목표 설정
  final int waterGoal;
  final int bowelGoal;

  // 알림 설정
  final bool bowelReminder;
  final bool waterReminder;
  final bool weeklyReport;

  // 프라이버시 설정
  final bool appLock;
  final bool hideNotificationContent;
  final bool cloudBackup;

  const SettingsEntity({
    this.waterGoal = 2000,
    this.bowelGoal = 1,
    this.bowelReminder = true,
    this.waterReminder = true,
    this.weeklyReport = true,
    this.appLock = false,
    this.hideNotificationContent = false,
    this.cloudBackup = false,
  });

  factory SettingsEntity.defaults() {
    return const SettingsEntity();
  }

  SettingsEntity copyWith({
    int? waterGoal,
    int? bowelGoal,
    bool? bowelReminder,
    bool? waterReminder,
    bool? weeklyReport,
    bool? appLock,
    bool? hideNotificationContent,
    bool? cloudBackup,
  }) {
    return SettingsEntity(
      waterGoal: waterGoal ?? this.waterGoal,
      bowelGoal: bowelGoal ?? this.bowelGoal,
      bowelReminder: bowelReminder ?? this.bowelReminder,
      waterReminder: waterReminder ?? this.waterReminder,
      weeklyReport: weeklyReport ?? this.weeklyReport,
      appLock: appLock ?? this.appLock,
      hideNotificationContent: hideNotificationContent ?? this.hideNotificationContent,
      cloudBackup: cloudBackup ?? this.cloudBackup,
    );
  }
}
