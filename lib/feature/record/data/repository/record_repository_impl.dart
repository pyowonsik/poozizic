import 'dart:developer';

import 'package:poozizic/core/network/network_info.dart';
import 'package:poozizic/feature/record/data/datasource/record_local_datasource.dart';
import 'package:poozizic/feature/record/data/datasource/record_remote_datasource.dart';
import 'package:poozizic/feature/record/data/model/record_model.dart';
import 'package:poozizic/feature/record/domain/entity/record_entity.dart';
import 'package:poozizic/feature/record/domain/repository/record_repository.dart';

/// Record Repository 구현체
class RecordRepositoryImpl implements RecordRepository {
  /// Record Repository 구현체 생성자
  const RecordRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._networkInfo,
  );

  final RecordLocalDataSource _localDataSource;
  final RecordRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<RecordEntity> createRecord(RecordEntity record) async {
    log('[RecordRepositoryImpl] createRecord 시작');
    final isConnected = await _networkInfo.isConnected;
    log('[RecordRepositoryImpl] 네트워크 연결: $isConnected');

    if (isConnected) {
      try {
        final model = RecordModel.fromEntity(record);
        log('[RecordRepositoryImpl] RecordModel 생성 완료');
        final result = await _remoteDataSource.createRecord(model);
        log('[RecordRepositoryImpl] 원격 저장 성공');
        return result;
      } catch (e, stackTrace) {
        log('[RecordRepositoryImpl] 원격 저장 실패: $e');
        log('[RecordRepositoryImpl] StackTrace: $stackTrace');
        log('[RecordRepositoryImpl] 로컬에 저장 시도...');
        return _localDataSource.createRecord(record);
      }
    }
    log('[RecordRepositoryImpl] 오프라인 - 로컬에 저장');
    return _localDataSource.createRecord(record);
  }

  @override
  Future<List<RecordEntity>> getAllRecords() async {
    if (await _networkInfo.isConnected) {
      try {
        return _remoteDataSource.getAllRecords();
      } catch (e) {
        return _localDataSource.getAllRecords();
      }
    }
    return _localDataSource.getAllRecords();
  }

  @override
  Future<List<RecordEntity>> getRecordsByDate(DateTime date) async {
    if (await _networkInfo.isConnected) {
      try {
        return _remoteDataSource.getRecordsByDate(date);
      } catch (e) {
        return _localDataSource.getRecordsByDate(date);
      }
    }
    return _localDataSource.getRecordsByDate(date);
  }

  @override
  Future<List<RecordEntity>> getRecordsByMonth(int year, int month) async {
    if (await _networkInfo.isConnected) {
      try {
        return _remoteDataSource.getRecordsByMonth(year, month);
      } catch (e) {
        return _localDataSource.getRecordsByMonth(year, month);
      }
    }
    return _localDataSource.getRecordsByMonth(year, month);
  }

  @override
  Future<void> deleteRecord(int id) async {
    // 로컬에서 삭제
    await _localDataSource.deleteRecord(id);
    // 원격 삭제는 supabaseId가 필요하므로 일단 로컬만 삭제
  }

  /// Supabase ID로 기록 삭제
  Future<void> deleteRecordBySupabaseId(String supabaseId) async {
    if (await _networkInfo.isConnected) {
      try {
        await _remoteDataSource.deleteRecord(supabaseId);
      } catch (e) {
        // 원격 삭제 실패 무시
      }
    }
  }
}
