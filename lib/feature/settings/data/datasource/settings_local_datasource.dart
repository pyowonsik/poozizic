import '../../domain/entity/settings_entity.dart';

/// Settings 로컬 데이터 소스 (메모리 목업)
class SettingsLocalDataSource {
  SettingsEntity _settings = SettingsEntity.defaults();

  Future<SettingsEntity> getSettings() async {
    // 실제로는 SharedPreferences나 DB에서 로드
    await Future.delayed(const Duration(milliseconds: 100));
    return _settings;
  }

  Future<SettingsEntity> saveSettings(SettingsEntity settings) async {
    // 실제로는 SharedPreferences나 DB에 저장
    await Future.delayed(const Duration(milliseconds: 100));
    _settings = settings;
    return _settings;
  }

  Future<SettingsEntity> resetSettings() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _settings = SettingsEntity.defaults();
    return _settings;
  }
}
