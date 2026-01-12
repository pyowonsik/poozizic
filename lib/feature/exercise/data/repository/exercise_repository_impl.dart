import '../../domain/entity/exercise_record_entity.dart';
import '../../domain/repository/exercise_repository.dart';
import '../datasource/exercise_local_datasource.dart';

/// Exercise Repository 구현
class ExerciseRepositoryImpl implements ExerciseRepository {
  const ExerciseRepositoryImpl(this._dataSource);

  final ExerciseLocalDataSource _dataSource;

  @override
  Future<ExerciseRecordEntity> createRecord(ExerciseRecordEntity record) {
    return _dataSource.createRecord(record);
  }

  @override
  Future<List<ExerciseRecordEntity>> getAllRecords() {
    return _dataSource.getAllRecords();
  }

  @override
  Future<List<ExerciseRecordEntity>> getRecordsByDate(DateTime date) {
    return _dataSource.getRecordsByDate(date);
  }
}
