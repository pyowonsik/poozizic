import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/meal_record/domain/entity/meal_record_entity.dart';
import 'package:poozizic/feature/meal_record/domain/failure/meal_record_failure.dart';
import 'package:poozizic/feature/meal_record/domain/repository/meal_record_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 특정 날짜 식사 기록 조회 UseCase
class GetMealRecordsByDateUseCase
    extends UseCase<List<MealRecordEntity>, DateTime, MealRecordRepository> {
  /// 특정 날짜 식사 기록 조회 UseCase 생성자
  GetMealRecordsByDateUseCase(this._repository);

  /// 특정 날짜 식사 기록 조회 UseCase 레포지토리
  final MealRecordRepository _repository;

  @override
  MealRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, List<MealRecordEntity>>> call(DateTime date) async {
    try {
      final records = await _repository.getRecordsByDate(date);
      return Right(records);
    } catch (e) {
      return Left(
        GetMealRecordsFailure(
          '식사 기록 조회에 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
