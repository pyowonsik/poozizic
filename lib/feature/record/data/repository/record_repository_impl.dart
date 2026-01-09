import '../../domain/entity/record_entity.dart';
import '../../domain/repository/record_repository.dart';
import '../datasource/record_local_datasource.dart';

/// Record Repository 구현체
class RecordRepositoryImpl implements RecordRepository {
  const RecordRepositoryImpl(this._dataSource);

  final RecordLocalDataSource _dataSource;

  @override
  Future<RecordEntity> createRecord(RecordEntity record) {
    return _dataSource.createRecord(record);
  }

  @override
  Future<List<RecordEntity>> getAllRecords() {
    return _dataSource.getAllRecords();
  }

  @override
  Future<List<RecordEntity>> getRecordsByDate(DateTime date) {
    return _dataSource.getRecordsByDate(date);
  }

  @override
  Future<List<RecordEntity>> getRecordsByMonth(int year, int month) {
    return _dataSource.getRecordsByMonth(year, month);
  }

  @override
  Future<void> deleteRecord(int id) {
    return _dataSource.deleteRecord(id);
  }
}
