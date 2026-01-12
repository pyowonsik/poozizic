import 'package:poozizic/feature/meal_record/data/datasource/meal_record_local_datasource.dart';
import 'package:poozizic/feature/meal_record/domain/entity/meal_record_entity.dart';
import 'package:poozizic/feature/meal_record/domain/repository/meal_record_repository.dart';

/// MealRecord Repository 구현체
class MealRecordRepositoryImpl implements MealRecordRepository {
  /// MealRecord Repository 구현체 생성자
  MealRecordRepositoryImpl(this._dataSource);

  /// MealRecord Local Data Source
  final MealRecordLocalDataSource _dataSource;

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
