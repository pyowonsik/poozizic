import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';
import 'package:poozizic/feature/settings/domain/repository/settings_repository.dart';
import 'package:poozizic/feature/settings/presentation/provider/settings_state.dart';

/// Settings Notifier
class SettingsNotifier extends StateNotifier<SettingsState> {
  /// Settings Notifier 생성자
  SettingsNotifier(this._repository) : super(const SettingsInitial()) {
    loadSettings();
  }
  final SettingsRepository _repository;

  /// 설정 로드
  Future<void> loadSettings() async {
    state = const SettingsLoading();

    final result = await _repository.getSettings();
    result.fold(
      (failure) => state = SettingsError(failure.message),
      (settings) => state = SettingsLoaded(settings),
    );
  }

  /// 수분 목표 업데이트
  Future<void> updateWaterGoal(int waterGoal) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(waterGoal: waterGoal);
    await _updateSettings(newSettings);
  }

  /// 배변 목표 업데이트
  Future<void> updateBowelGoal(int bowelGoal) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(bowelGoal: bowelGoal);
    await _updateSettings(newSettings);
  }

  /// 배변 알림 업데이트
  Future<void> updateBowelReminder(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(bowelReminder: value);
    await _updateSettings(newSettings);
  }

  /// 수분 알림 업데이트
  Future<void> updateWaterReminder(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(waterReminder: value);
    await _updateSettings(newSettings);
  }

  /// 주간 보고서 업데이트
  Future<void> updateWeeklyReport(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(weeklyReport: value);
    await _updateSettings(newSettings);
  }

  /// 앱 잠금 업데이트
  Future<void> updateAppLock(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(appLock: value);
    await _updateSettings(newSettings);
  }

  /// 알림에서 내용 숨기기 업데이트
  Future<void> updateHideNotificationContent(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(
      hideNotificationContent: value,
    );
    await _updateSettings(newSettings);
  }

  /// 클라우드 백업 업데이트
  Future<void> updateCloudBackup(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(cloudBackup: value);
    await _updateSettings(newSettings);
  }

  /// 설정 업데이트
  Future<void> _updateSettings(SettingsEntity newSettings) async {
    final result = await _repository.updateSettings(newSettings);
    result.fold(
      (failure) => state = SettingsError(failure.message),
      (settings) => state = SettingsLoaded(settings),
    );
  }

  /// 설정 초기화
  Future<void> resetSettings() async {
    state = const SettingsLoading();

    final result = await _repository.resetSettings();
    result.fold(
      (failure) => state = SettingsError(failure.message),
      (settings) => state = SettingsLoaded(settings),
    );
  }
}
