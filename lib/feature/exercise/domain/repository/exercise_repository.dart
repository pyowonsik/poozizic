import '../entity/exercise_record_entity.dart';

/// Exercise Repository 인터페이스
abstract class ExerciseRepository {
  /// 새 운동 기록 생성
  Future<ExerciseRecordEntity> createRecord(ExerciseRecordEntity record);

  /// 모든 운동 기록 조회
  Future<List<ExerciseRecordEntity>> getAllRecords();

  /// 특정 날짜의 운동 기록 조회
  Future<List<ExerciseRecordEntity>> getRecordsByDate(DateTime date);
}
