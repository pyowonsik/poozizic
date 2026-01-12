import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';

/// Settings 로컬 데이터 소스 (메모리 목업)
class SettingsLocalDataSource {
  SettingsEntity _settings = SettingsEntity.defaults();

  /// 설정 조회
  Future<SettingsEntity> getSettings() async {
    // 실제로는 SharedPreferences나 DB에서 로드
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _settings;
  }

  /// 설정 저장
  Future<SettingsEntity> saveSettings(SettingsEntity settings) async {
    // 실제로는 SharedPreferences나 DB에 저장
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _settings = settings;
  }

  /// 설정 초기화
  Future<SettingsEntity> resetSettings() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _settings = SettingsEntity.defaults();
  }
}
