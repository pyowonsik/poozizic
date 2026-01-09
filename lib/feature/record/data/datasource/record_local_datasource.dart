import '../../domain/entity/record_entity.dart';

/// 로컬 목업 데이터소스
class RecordLocalDataSource {
  late final List<RecordEntity> _mockRecords;
  int _nextId = 100;

  RecordLocalDataSource() {
    _mockRecords = _generateMockData();
  }

  /// Mock 데이터 생성
  List<RecordEntity> _generateMockData() {
    final now = DateTime.now();
    final records = <RecordEntity>[];
    int id = 1;

    // 오늘 기록 (2개)
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(now.year, now.month, now.day, 7, 30),
      bristolType: 4, // 건강한 변
      feeling: 0, // 시원함
      durationMinutes: 5,
      memo: '아침 기상 후 쾌변!',
      createdAt: DateTime(now.year, now.month, now.day, 7, 35),
    ));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(now.year, now.month, now.day, 13, 15),
      bristolType: 4,
      feeling: 1, // 보통
      durationMinutes: 8,
      createdAt: DateTime(now.year, now.month, now.day, 13, 25),
    ));

    // 어제 기록 (1개)
    final yesterday = now.subtract(const Duration(days: 1));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(yesterday.year, yesterday.month, yesterday.day, 8, 0),
      bristolType: 3,
      feeling: 0,
      durationMinutes: 7,
      memo: '컨디션 좋음',
      createdAt: DateTime(yesterday.year, yesterday.month, yesterday.day, 8, 10),
    ));

    // 2일 전 기록 (2개)
    final twoDaysAgo = now.subtract(const Duration(days: 2));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(twoDaysAgo.year, twoDaysAgo.month, twoDaysAgo.day, 7, 45),
      bristolType: 5,
      feeling: 1,
      durationMinutes: 10,
      createdAt: DateTime(twoDaysAgo.year, twoDaysAgo.month, twoDaysAgo.day, 7, 55),
    ));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(twoDaysAgo.year, twoDaysAgo.month, twoDaysAgo.day, 19, 30),
      bristolType: 4,
      feeling: 0,
      durationMinutes: 5,
      memo: '저녁 식사 후',
      createdAt: DateTime(twoDaysAgo.year, twoDaysAgo.month, twoDaysAgo.day, 19, 35),
    ));

    // 3일 전 (기록 없음 - 변비)

    // 4일 전 기록 (1개)
    final fourDaysAgo = now.subtract(const Duration(days: 4));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(fourDaysAgo.year, fourDaysAgo.month, fourDaysAgo.day, 9, 0),
      bristolType: 2, // 딱딱한 변
      feeling: 2, // 불편함
      durationMinutes: 15,
      memo: '변비 증상',
      createdAt: DateTime(fourDaysAgo.year, fourDaysAgo.month, fourDaysAgo.day, 9, 15),
    ));

    // 5일 전 기록 (1개)
    final fiveDaysAgo = now.subtract(const Duration(days: 5));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(fiveDaysAgo.year, fiveDaysAgo.month, fiveDaysAgo.day, 8, 30),
      bristolType: 4,
      feeling: 0,
      durationMinutes: 6,
      createdAt: DateTime(fiveDaysAgo.year, fiveDaysAgo.month, fiveDaysAgo.day, 8, 36),
    ));

    // 6일 전 기록 (2개)
    final sixDaysAgo = now.subtract(const Duration(days: 6));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(sixDaysAgo.year, sixDaysAgo.month, sixDaysAgo.day, 7, 15),
      bristolType: 4,
      feeling: 0,
      durationMinutes: 5,
      createdAt: DateTime(sixDaysAgo.year, sixDaysAgo.month, sixDaysAgo.day, 7, 20),
    ));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(sixDaysAgo.year, sixDaysAgo.month, sixDaysAgo.day, 18, 45),
      bristolType: 5,
      feeling: 1,
      durationMinutes: 8,
      createdAt: DateTime(sixDaysAgo.year, sixDaysAgo.month, sixDaysAgo.day, 18, 53),
    ));

    // 1주일 전 기록 (1개)
    final oneWeekAgo = now.subtract(const Duration(days: 7));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(oneWeekAgo.year, oneWeekAgo.month, oneWeekAgo.day, 8, 0),
      bristolType: 6, // 묽은 변
      feeling: 2, // 불편함
      durationMinutes: 12,
      memo: '배탈 증상',
      createdAt: DateTime(oneWeekAgo.year, oneWeekAgo.month, oneWeekAgo.day, 8, 12),
    ));

    // 10일 전 기록 (1개)
    final tenDaysAgo = now.subtract(const Duration(days: 10));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(tenDaysAgo.year, tenDaysAgo.month, tenDaysAgo.day, 7, 30),
      bristolType: 4,
      feeling: 0,
      durationMinutes: 5,
      createdAt: DateTime(tenDaysAgo.year, tenDaysAgo.month, tenDaysAgo.day, 7, 35),
    ));

    // 2주 전 기록 (2개)
    final twoWeeksAgo = now.subtract(const Duration(days: 14));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day, 7, 45),
      bristolType: 3,
      feeling: 3, // 잔변감
      durationMinutes: 10,
      memo: '잔변감 있음',
      createdAt: DateTime(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day, 7, 55),
    ));
    records.add(RecordEntity(
      id: id++,
      dateTime: DateTime(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day, 20, 0),
      bristolType: 4,
      feeling: 0,
      durationMinutes: 6,
      createdAt: DateTime(twoWeeksAgo.year, twoWeeksAgo.month, twoWeeksAgo.day, 20, 6),
    ));

    return records;
  }

  /// 새 기록 생성
  Future<RecordEntity> createRecord(RecordEntity record) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newRecord = RecordEntity(
      id: _nextId++,
      dateTime: record.dateTime,
      bristolType: record.bristolType,
      feeling: record.feeling,
      durationMinutes: record.durationMinutes,
      memo: record.memo,
      createdAt: DateTime.now(),
    );
    _mockRecords.add(newRecord);
    return newRecord;
  }

  /// 모든 기록 조회
  Future<List<RecordEntity>> getAllRecords() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_mockRecords)
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  /// 특정 날짜의 기록 조회
  Future<List<RecordEntity>> getRecordsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockRecords
        .where(
          (r) =>
              r.dateTime.year == date.year &&
              r.dateTime.month == date.month &&
              r.dateTime.day == date.day,
        )
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  /// 특정 월의 기록 조회
  Future<List<RecordEntity>> getRecordsByMonth(int year, int month) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockRecords
        .where(
          (r) => r.dateTime.year == year && r.dateTime.month == month,
        )
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  /// 기록 삭제
  Future<void> deleteRecord(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _mockRecords.removeWhere((r) => r.id == id);
  }
}
