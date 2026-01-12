import '../../domain/entity/exercise_record_entity.dart';
import '../../domain/repository/exercise_record_repository.dart';
import '../datasource/exercise_record_local_datasource.dart';

/// ExerciseRecord Repository 구현체
class ExerciseRecordRepositoryImpl implements ExerciseRecordRepository {
  final ExerciseRecordLocalDataSource _dataSource;

  ExerciseRecordRepositoryImpl(this._dataSource);

  @override
  Future<ExerciseRecordEntity> createRecord(ExerciseRecordEntity record) {
    return _dataSource.createRecord(record);
  }

  @override
  Future<List<ExerciseRecordEntity>> getRecordsByDate(DateTime date) {
    return _dataSource.getRecordsByDate(date);
  }

  @override
  Future<int> getDailyTotalMinutes(DateTime date) {
    return _dataSource.getDailyTotalMinutes(date);
  }

  @override
  Future<List<ExerciseRecordEntity>> getAllRecords() {
    return _dataSource.getAllRecords();
  }
}
