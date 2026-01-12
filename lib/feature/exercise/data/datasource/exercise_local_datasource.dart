import '../../domain/entity/exercise_record_entity.dart';

/// 운동 기록 로컬 데이터소스
class ExerciseLocalDataSource {
  final List<ExerciseRecordEntity> _records = [];
  int _nextId = 1;

  /// 새 운동 기록 생성
  Future<ExerciseRecordEntity> createRecord(ExerciseRecordEntity record) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newRecord = ExerciseRecordEntity(
      id: _nextId++,
      exerciseType: record.exerciseType,
      duration: record.duration,
      intensity: record.intensity,
      recordedAt: record.recordedAt,
    );
    _records.add(newRecord);
    return newRecord;
  }

  /// 모든 운동 기록 조회
  Future<List<ExerciseRecordEntity>> getAllRecords() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_records)
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  /// 특정 날짜의 운동 기록 조회
  Future<List<ExerciseRecordEntity>> getRecordsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _records
        .where(
          (r) =>
              r.recordedAt.year == date.year &&
              r.recordedAt.month == date.month &&
              r.recordedAt.day == date.day,
        )
        .toList()
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }
}
