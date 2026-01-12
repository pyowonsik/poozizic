import 'dart:developer';

import 'package:poozizic/feature/record/data/model/record_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 배변 기록 원격 데이터 소스
class RecordRemoteDataSource {
  /// 배변 기록 원격 데이터 소스 생성자
  RecordRemoteDataSource(this._client);

  final SupabaseClient _client;

  /// 현재 사용자 ID 조회
  String? get _currentUserId => _client.auth.currentUser?.id;

  /// 기록 생성
  Future<RecordModel> createRecord(RecordModel record) async {
    final userId = _currentUserId;
    log('[RecordRemoteDataSource] createRecord 시작');
    log('[RecordRemoteDataSource] userId: $userId');

    if (userId == null) {
      log('[RecordRemoteDataSource] ERROR: 로그인 필요');
      throw Exception('로그인이 필요합니다.');
    }

    final recordWithUser = record.copyWith(userId: userId);
    final jsonData = recordWithUser.toJson();
    log('[RecordRemoteDataSource] 저장할 데이터: $jsonData');

    try {
      final response = await _client
          .from('bowel_records')
          .insert(jsonData)
          .select()
          .single();

      log('[RecordRemoteDataSource] 성공! response: $response');
      return RecordModel.fromJson(response);
    } catch (e, stackTrace) {
      log('[RecordRemoteDataSource] ERROR: $e');
      log('[RecordRemoteDataSource] StackTrace: $stackTrace');
      rethrow;
    }
  }

  /// 특정 날짜의 기록 조회
  Future<List<RecordModel>> getRecordsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await _client
        .from('bowel_records')
        .select()
        .gte('record_datetime', startOfDay.toIso8601String())
        .lt('record_datetime', endOfDay.toIso8601String())
        .order('record_datetime', ascending: false);

    return (response as List)
        .map((json) => RecordModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 특정 월의 기록 조회
  Future<List<RecordModel>> getRecordsByMonth(int year, int month) async {
    final startOfMonth = DateTime(year, month);
    final endOfMonth = DateTime(year, month + 1);

    final response = await _client
        .from('bowel_records')
        .select()
        .gte('record_datetime', startOfMonth.toIso8601String())
        .lt('record_datetime', endOfMonth.toIso8601String())
        .order('record_datetime', ascending: false);

    return (response as List)
        .map((json) => RecordModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 모든 기록 조회
  Future<List<RecordModel>> getAllRecords() async {
    final response = await _client
        .from('bowel_records')
        .select()
        .order('record_datetime', ascending: false);

    return (response as List)
        .map((json) => RecordModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 기록 삭제
  Future<void> deleteRecord(String id) async {
    await _client.from('bowel_records').delete().eq('id', id);
  }
}
