import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/meal_record_entity.dart';
import '../failure/meal_record_failure.dart';
import '../repository/meal_record_repository.dart';

/// 특정 날짜 식사 기록 조회 UseCase
class GetMealRecordsByDateUseCase
    extends UseCase<List<MealRecordEntity>, DateTime, MealRecordRepository> {
  final MealRecordRepository _repository;

  GetMealRecordsByDateUseCase(this._repository);

  @override
  MealRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, List<MealRecordEntity>>> call(DateTime date) async {
    try {
      final records = await _repository.getRecordsByDate(date);
      return Right(records);
    } catch (e) {
      return Left(GetMealRecordsFailure(
        '식사 기록 조회에 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
