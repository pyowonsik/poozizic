import '../../domain/entity/water_record_entity.dart';

/// 수분 기록 로컬 데이터소스
class WaterLocalDataSource {
  final List<WaterRecordEntity> _records = [];
  int _nextId = 1;

  /// 새 수분 기록 생성
  Future<WaterRecordEntity> createRecord(WaterRecordEntity record) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newRecord = WaterRecordEntity(
      id: _nextId++,
      amount: record.amount,
      recordedAt: record.recordedAt,
    );
    _records.add(newRecord);
    return newRecord;
  }

  /// 모든 수분 기록 조회
  Future<List<WaterRecordEntity>> getAllRecords() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_records)
      ..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
  }

  /// 특정 날짜의 수분 기록 조회
  Future<List<WaterRecordEntity>> getRecordsByDate(DateTime date) async {
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
