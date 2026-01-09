import '../entity/record_entity.dart';

/// Record Repository 인터페이스
abstract class RecordRepository {
  /// 새 기록 생성
  Future<RecordEntity> createRecord(RecordEntity record);

  /// 모든 기록 조회
  Future<List<RecordEntity>> getAllRecords();

  /// 특정 날짜의 기록 조회
  Future<List<RecordEntity>> getRecordsByDate(DateTime date);

  /// 특정 월의 기록 조회
  Future<List<RecordEntity>> getRecordsByMonth(int year, int month);

  /// 기록 삭제
  Future<void> deleteRecord(int id);
}
