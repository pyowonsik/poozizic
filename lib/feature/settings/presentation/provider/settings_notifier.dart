import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entity/settings_entity.dart';
import '../../domain/repository/settings_repository.dart';
import 'settings_state.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._repository) : super(const SettingsInitial()) {
    loadSettings();
  }

  final SettingsRepository _repository;

  Future<void> loadSettings() async {
    state = const SettingsLoading();

    final result = await _repository.getSettings();
    result.fold(
      (failure) => state = SettingsError(failure.message),
      (settings) => state = SettingsLoaded(settings),
    );
  }

  Future<void> updateWaterGoal(int waterGoal) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(waterGoal: waterGoal);
    await _updateSettings(newSettings);
  }

  Future<void> updateBowelGoal(int bowelGoal) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(bowelGoal: bowelGoal);
    await _updateSettings(newSettings);
  }

  Future<void> updateBowelReminder(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(bowelReminder: value);
    await _updateSettings(newSettings);
  }

  Future<void> updateWaterReminder(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(waterReminder: value);
    await _updateSettings(newSettings);
  }

  Future<void> updateWeeklyReport(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(weeklyReport: value);
    await _updateSettings(newSettings);
  }

  Future<void> updateAppLock(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(appLock: value);
    await _updateSettings(newSettings);
  }

  Future<void> updateHideNotificationContent(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(hideNotificationContent: value);
    await _updateSettings(newSettings);
  }

  Future<void> updateCloudBackup(bool value) async {
    final current = state;
    if (current is! SettingsLoaded) return;

    final newSettings = current.settings.copyWith(cloudBackup: value);
    await _updateSettings(newSettings);
  }

  Future<void> _updateSettings(SettingsEntity newSettings) async {
    final result = await _repository.updateSettings(newSettings);
    result.fold(
      (failure) => state = SettingsError(failure.message),
      (settings) => state = SettingsLoaded(settings),
    );
  }

  Future<void> resetSettings() async {
    state = const SettingsLoading();

    final result = await _repository.resetSettings();
    result.fold(
      (failure) => state = SettingsError(failure.message),
      (settings) => state = SettingsLoaded(settings),
    );
  }
}
