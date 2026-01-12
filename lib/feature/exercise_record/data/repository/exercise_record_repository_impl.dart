import 'package:poozizic/feature/exercise_record/data/datasource/exercise_record_local_datasource.dart';
import 'package:poozizic/feature/exercise_record/domain/entity/exercise_record_entity.dart';
import 'package:poozizic/feature/exercise_record/domain/repository/exercise_record_repository.dart';

/// ExerciseRecord Repository 구현체
class ExerciseRecordRepositoryImpl implements ExerciseRecordRepository {
  /// ExerciseRecord Repository 구현체 생성자
  ExerciseRecordRepositoryImpl(this._dataSource);

  final ExerciseRecordLocalDataSource _dataSource;

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
