import 'package:poozizic/feature/water_record/data/datasource/water_record_local_datasource.dart';
import 'package:poozizic/feature/water_record/domain/entity/water_record_entity.dart';
import 'package:poozizic/feature/water_record/domain/repository/water_record_repository.dart';

/// WaterRecord Repository 구현체
class WaterRecordRepositoryImpl implements WaterRecordRepository {
  /// WaterRecord Repository 구현체 생성자
  WaterRecordRepositoryImpl(this._dataSource);

  final WaterRecordLocalDataSource _dataSource;

  @override
  Future<WaterRecordEntity> createRecord(WaterRecordEntity record) {
    return _dataSource.createRecord(record);
  }

  @override
  Future<List<WaterRecordEntity>> getRecordsByDate(DateTime date) {
    return _dataSource.getRecordsByDate(date);
  }

  @override
  Future<int> getDailyTotal(DateTime date) {
    return _dataSource.getDailyTotal(date);
  }

  @override
  Future<List<WaterRecordEntity>> getAllRecords() {
    return _dataSource.getAllRecords();
  }
}
