import 'package:poozizic/feature/water_record/domain/entity/water_record_entity.dart';

/// WaterRecord Repository 인터페이스
abstract class WaterRecordRepository {
  /// 수분 기록 생성
  Future<WaterRecordEntity> createRecord(WaterRecordEntity record);

  /// 특정 날짜의 수분 기록 조회
  Future<List<WaterRecordEntity>> getRecordsByDate(DateTime date);

  /// 특정 날짜의 총 수분 섭취량 조회
  Future<int> getDailyTotal(DateTime date);

  /// 전체 수분 기록 조회
  Future<List<WaterRecordEntity>> getAllRecords();
}
