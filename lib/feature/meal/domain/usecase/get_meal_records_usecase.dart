import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/meal_record_entity.dart';
import '../failure/meal_failure.dart';
import '../repository/meal_repository.dart';

/// 식사 기록 조회 UseCase
class GetMealRecordsUseCase
    implements UseCase<List<MealRecordEntity>, NoParams, MealRepository> {
  const GetMealRecordsUseCase(this.repository);

  final MealRepository repository;

  @override
  MealRepository get repo => repository;

  @override
  Future<Either<Failure, List<MealRecordEntity>>> call(NoParams params) async {
    try {
      final records = await repository.getAllRecords();
      return Right(records);
    } on Exception catch (e) {
      return Left(
        GetMealRecordsFailure('식사 기록을 조회할 수 없습니다.', exception: e),
      );
    }
  }
}
