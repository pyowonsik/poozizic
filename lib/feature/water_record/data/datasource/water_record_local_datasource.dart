import 'dart:math';
import 'package:poozizic/feature/water_record/domain/entity/water_record_entity.dart';

/// WaterRecord 로컬 데이터소스 (목업)
class WaterRecordLocalDataSource {
  /// WaterRecord Local Data Source 생성자
  WaterRecordLocalDataSource() {
    _generateMockData();
  }
  final List<WaterRecordEntity> _records = [];
  int _nextId = 1;

  /// 목업 데이터 생성 (최근 7일)
  void _generateMockData() {
    final random = Random();
    final now = DateTime.now();
    final presets = ['cup', 'mug', 'can', 'bottle'];
    final amounts = [200, 250, 355, 500];

    for (var i = 0; i < 7; i++) {
      final date = now.subtract(Duration(days: i));
      // 하루에 3-6회 수분 섭취
      final recordCount = 3 + random.nextInt(4);

      for (var j = 0; j < recordCount; j++) {
        final presetIndex = random.nextInt(4);
        final hour = 7 + random.nextInt(14); // 07시 ~ 21시
        final minute = random.nextInt(60);

        _records.add(
          WaterRecordEntity(
            id: _nextId++,
            dateTime: DateTime(date.year, date.month, date.day, hour, minute),
            amountMl: amounts[presetIndex],
            presetType: presets[presetIndex],
            createdAt: DateTime(date.year, date.month, date.day, hour, minute),
          ),
        );
      }
    }

    // 시간순 정렬
    _records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
  }

  /// 수분 기록 생성
  Future<WaterRecordEntity> createRecord(WaterRecordEntity record) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final newRecord = record.copyWith(id: _nextId++);
    _records.insert(0, newRecord);
    return newRecord;
  }

  /// 특정 날짜의 수분 기록 조회
  Future<List<WaterRecordEntity>> getRecordsByDate(DateTime date) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return _records.where((record) {
      return record.dateTime.year == date.year &&
          record.dateTime.month == date.month &&
          record.dateTime.day == date.day;
    }).toList();
  }

  /// 특정 날짜의 총 수분 섭취량
  Future<int> getDailyTotal(DateTime date) async {
    final records = await getRecordsByDate(date);
    return records.fold<int>(0, (sum, record) => sum + record.amountMl);
  }

  /// 전체 기록 조회
  Future<List<WaterRecordEntity>> getAllRecords() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return List.from(_records);
  }
}
