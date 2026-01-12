import '../../domain/entity/water_record_entity.dart';
import '../../domain/repository/water_repository.dart';
import '../datasource/water_local_datasource.dart';

/// Water Repository 구현
class WaterRepositoryImpl implements WaterRepository {
  const WaterRepositoryImpl(this._dataSource);

  final WaterLocalDataSource _dataSource;

  @override
  Future<WaterRecordEntity> createRecord(WaterRecordEntity record) {
    return _dataSource.createRecord(record);
  }

  @override
  Future<List<WaterRecordEntity>> getAllRecords() {
    return _dataSource.getAllRecords();
  }

  @override
  Future<List<WaterRecordEntity>> getRecordsByDate(DateTime date) {
    return _dataSource.getRecordsByDate(date);
  }
}
