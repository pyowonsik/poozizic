import '../entity/water_record_entity.dart';

/// Water Repository 인터페이스
abstract class WaterRepository {
  /// 새 수분 기록 생성
  Future<WaterRecordEntity> createRecord(WaterRecordEntity record);

  /// 모든 수분 기록 조회
  Future<List<WaterRecordEntity>> getAllRecords();

  /// 특정 날짜의 수분 기록 조회
  Future<List<WaterRecordEntity>> getRecordsByDate(DateTime date);
}
