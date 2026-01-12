import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/meal_record_entity.dart';
import '../failure/meal_failure.dart';
import '../repository/meal_repository.dart';

/// 식사 기록 생성 UseCase
class CreateMealRecordUseCase
    implements UseCase<MealRecordEntity, CreateMealRecordParams, MealRepository> {
  const CreateMealRecordUseCase(this.repository);

  final MealRepository repository;

  @override
  MealRepository get repo => repository;

  @override
  Future<Either<Failure, MealRecordEntity>> call(CreateMealRecordParams params) async {
    try {
      final record = MealRecordEntity(
        mealType: params.mealType,
        foods: params.foods,
        fiberLevel: params.fiberLevel,
        recordedAt: DateTime.now(),
      );
      final result = await repository.createRecord(record);
      return Right(result);
    } on Exception catch (e) {
      return Left(
        CreateMealRecordFailure('식사 기록을 저장할 수 없습니다.', exception: e),
      );
    }
  }
}

/// 식사 기록 생성 파라미터
class CreateMealRecordParams {
  const CreateMealRecordParams({
    required this.mealType,
    required this.foods,
    required this.fiberLevel,
  });

  final int mealType;
  final List<String> foods;
  final int fiberLevel;
}
