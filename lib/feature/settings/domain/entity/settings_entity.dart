/// 설정 Entity
class SettingsEntity {
  /// 설정 Entity 생성자
  /// [waterGoal] 수분 목표
  /// [bowelGoal] 대변 목표
  /// [bowelReminder] 대변 알림
  /// [waterReminder] 수분 알림
  /// [weeklyReport] 주간 보고서
  /// [appLock] 앱 잠금
  /// [hideNotificationContent] 알림에서 내용 숨기기
  /// [cloudBackup] 클라우드 백업
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

  /// 기본 설정 생성
  factory SettingsEntity.defaults() {
    return const SettingsEntity();
  }

  /// 수분 목표
  final int waterGoal;

  /// 대변 목표
  final int bowelGoal;

  /// 대변 알림
  final bool bowelReminder;

  /// 수분 알림
  final bool waterReminder;

  /// 주간 보고서
  final bool weeklyReport;

  /// 앱 잠금
  final bool appLock;

  /// 알림에서 내용 숨기기
  final bool hideNotificationContent;

  /// 클라우드 백업
  final bool cloudBackup;

  /// 설정 엔티티 복사
  /// [waterGoal] 수분 목표
  /// [bowelGoal] 대변 목표
  /// [bowelReminder] 대변 알림
  /// [waterReminder] 수분 알림
  /// [weeklyReport] 주간 보고서
  /// [appLock] 앱 잠금
  /// [hideNotificationContent] 알림에서 내용 숨기기
  /// [cloudBackup] 클라우드 백업
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
      hideNotificationContent:
          hideNotificationContent ?? this.hideNotificationContent,
      cloudBackup: cloudBackup ?? this.cloudBackup,
    );
  }
}
