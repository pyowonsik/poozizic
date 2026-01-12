import '../../domain/entity/meal_record_entity.dart';
import '../../domain/repository/meal_repository.dart';
import '../datasource/meal_local_datasource.dart';

/// Meal Repository 구현
class MealRepositoryImpl implements MealRepository {
  const MealRepositoryImpl(this._dataSource);

  final MealLocalDataSource _dataSource;

  @override
  Future<MealRecordEntity> createRecord(MealRecordEntity record) {
    return _dataSource.createRecord(record);
  }

  @override
  Future<List<MealRecordEntity>> getAllRecords() {
    return _dataSource.getAllRecords();
  }

  @override
  Future<List<MealRecordEntity>> getRecordsByDate(DateTime date) {
    return _dataSource.getRecordsByDate(date);
  }
}
