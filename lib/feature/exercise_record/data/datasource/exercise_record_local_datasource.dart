import 'dart:math';
import 'package:poozizic/feature/exercise_record/domain/entity/exercise_record_entity.dart';

/// ExerciseRecord 로컬 데이터소스 (목업)
class ExerciseRecordLocalDataSource {
  /// ExerciseRecord Local Data Source 생성자
  ExerciseRecordLocalDataSource() {
    _generateMockData();
  }
  final List<ExerciseRecordEntity> _records = [];
  int _nextId = 1;

  /// 목업 데이터 생성 (최근 7일)
  void _generateMockData() {
    final random = Random();
    final now = DateTime.now();

    for (var i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      // 하루에 0-2회 운동 (70% 확률로 운동)
      if (random.nextDouble() > 0.3) {
        final exerciseCount = 1 + random.nextInt(2);

        for (var j = 0; j < exerciseCount; j++) {
          final exerciseType = random.nextInt(6);
          final intensity = random.nextInt(3);
          final duration = [15, 30, 45, 60][random.nextInt(4)];
          final hour = 6 + random.nextInt(16); // 06시 ~ 22시

          _records.add(
            ExerciseRecordEntity(
              id: _nextId++,
              dateTime: DateTime(
                date.year,
                date.month,
                date.day,
                hour,
                random.nextInt(60),
              ),
              exerciseType: exerciseType,
              durationMinutes: duration,
              intensity: intensity,
              createdAt: DateTime(
                date.year,
                date.month,
                date.day,
                hour,
                random.nextInt(60),
              ),
            ),
          );
        }
      }
    }

    // 시간순 정렬
    _records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  /// 운동 기록 생성
  Future<ExerciseRecordEntity> createRecord(ExerciseRecordEntity record) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final newRecord = record.copyWith(id: _nextId++);
    _records.insert(0, newRecord);
    return newRecord;
  }

  /// 특정 날짜의 운동 기록 조회
  Future<List<ExerciseRecordEntity>> getRecordsByDate(DateTime date) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return _records.where((record) {
      return record.dateTime.year == date.year &&
          record.dateTime.month == date.month &&
          record.dateTime.day == date.day;
    }).toList();
  }

  /// 특정 날짜의 총 운동 시간(분)
  Future<int> getDailyTotalMinutes(DateTime date) async {
    final records = await getRecordsByDate(date);
    return records.fold<int>(0, (sum, record) => sum + record.durationMinutes);
  }

  /// 전체 기록 조회
  Future<List<ExerciseRecordEntity>> getAllRecords() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return List.from(_records);
  }
}
