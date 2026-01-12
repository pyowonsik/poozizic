import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';

/// Settings 화면 상태 (Sealed Class)
sealed class SettingsState {
  const SettingsState();
}

/// 초기 상태
class SettingsInitial extends SettingsState {
  /// 초기 상태 생성자
  const SettingsInitial();
}

/// 로딩 상태
class SettingsLoading extends SettingsState {
  /// 로딩 상태 생성자
  const SettingsLoading();
}

/// 로드 완료 상태
class SettingsLoaded extends SettingsState {
  /// 로드 완료 상태 생성자
  const SettingsLoaded(this.settings);

  /// 설정 엔티티
  final SettingsEntity settings;

  /// 설정 업데이트
  SettingsLoaded copyWith({SettingsEntity? settings}) {
    return SettingsLoaded(settings ?? this.settings);
  }
}

/// 에러 상태
class SettingsError extends SettingsState {
  /// 에러 상태 생성자
  /// [message] 에러 메시지
  const SettingsError(this.message);

  /// 에러 메시지
  final String message;
}
