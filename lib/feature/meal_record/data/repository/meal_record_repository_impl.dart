import '../../domain/entity/meal_record_entity.dart';
import '../../domain/repository/meal_record_repository.dart';
import '../datasource/meal_record_local_datasource.dart';

/// MealRecord Repository 구현체
class MealRecordRepositoryImpl implements MealRecordRepository {
  final MealRecordLocalDataSource _dataSource;

  MealRecordRepositoryImpl(this._dataSource);

  @override
  Future<MealRecordEntity> createRecord(MealRecordEntity record) {
    return _dataSource.createRecord(record);
  }

  @override
  Future<List<MealRecordEntity>> getRecordsByDate(DateTime date) {
    return _dataSource.getRecordsByDate(date);
  }

  @override
  Future<int> getDailyMealCount(DateTime date) {
    return _dataSource.getDailyMealCount(date);
  }

  @override
  Future<List<MealRecordEntity>> getAllRecords() {
    return _dataSource.getAllRecords();
  }
}
