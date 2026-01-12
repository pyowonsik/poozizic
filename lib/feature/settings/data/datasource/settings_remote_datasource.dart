import 'package:poozizic/feature/settings/data/model/settings_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 설정 원격 데이터 소스
class SettingsRemoteDataSource {
  /// 설정 원격 데이터 소스 생성자
  SettingsRemoteDataSource(this._client);

  final SupabaseClient _client;

  /// 현재 사용자 ID 조회
  String? get _currentUserId => _client.auth.currentUser?.id;

  /// 설정 조회
  Future<SettingsModel?> getSettings() async {
    final userId = _currentUserId;
    if (userId == null) return null;

    final response = await _client
        .from('user_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) return null;
    return SettingsModel.fromJson(response);
  }

  /// 설정 저장 또는 업데이트
  Future<SettingsModel> saveSettings(SettingsModel settings) async {
    final userId = _currentUserId;
    if (userId == null) {
      throw Exception('로그인이 필요합니다.');
    }

    final data = settings.copyWith(userId: userId).toJson();

    final response = await _client
        .from('user_settings')
        .upsert(data)
        .select()
        .single();

    return SettingsModel.fromJson(response);
  }

  /// 설정 삭제 (로그아웃 시)
  Future<void> deleteSettings() async {
    final userId = _currentUserId;
    if (userId == null) return;

    await _client.from('user_settings').delete().eq('user_id', userId);
  }
}
