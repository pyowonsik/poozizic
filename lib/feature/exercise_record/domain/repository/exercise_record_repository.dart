import 'package:poozizic/feature/exercise_record/domain/entity/exercise_record_entity.dart';

/// ExerciseRecord Repository 인터페이스
abstract class ExerciseRecordRepository {
  /// 운동 기록 생성
  Future<ExerciseRecordEntity> createRecord(ExerciseRecordEntity record);

  /// 특정 날짜의 운동 기록 조회
  Future<List<ExerciseRecordEntity>> getRecordsByDate(DateTime date);

  /// 특정 날짜의 총 운동 시간(분) 조회
  Future<int> getDailyTotalMinutes(DateTime date);

  /// 전체 운동 기록 조회
  Future<List<ExerciseRecordEntity>> getAllRecords();
}
