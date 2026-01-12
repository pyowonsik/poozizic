import '../../domain/entity/water_record_entity.dart';
import '../../domain/repository/water_record_repository.dart';
import '../datasource/water_record_local_datasource.dart';

/// WaterRecord Repository 구현체
class WaterRecordRepositoryImpl implements WaterRecordRepository {
  final WaterRecordLocalDataSource _dataSource;

  WaterRecordRepositoryImpl(this._dataSource);

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
