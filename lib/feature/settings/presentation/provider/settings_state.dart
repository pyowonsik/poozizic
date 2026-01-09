import '../../domain/entity/settings_entity.dart';

/// Settings 화면 상태 (Sealed Class)
sealed class SettingsState {
  const SettingsState();
}

/// 초기 상태
class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

/// 로딩 상태
class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

/// 로드 완료 상태
class SettingsLoaded extends SettingsState {
  final SettingsEntity settings;

  const SettingsLoaded(this.settings);

  SettingsLoaded copyWith({SettingsEntity? settings}) {
    return SettingsLoaded(settings ?? this.settings);
  }
}

/// 에러 상태
class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);
}
