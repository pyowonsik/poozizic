import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/meal_record_entity.dart';
import '../failure/meal_record_failure.dart';
import '../repository/meal_record_repository.dart';

/// 식사 기록 생성 파라미터
class CreateMealRecordParams {
  final int mealType;
  final List<String> foods;
  final int fiberLevel;
  final DateTime? dateTime;

  const CreateMealRecordParams({
    required this.mealType,
    required this.foods,
    required this.fiberLevel,
    this.dateTime,
  });
}

/// 식사 기록 생성 UseCase
class CreateMealRecordUseCase
    extends UseCase<MealRecordEntity, CreateMealRecordParams, MealRecordRepository> {
  final MealRecordRepository _repository;

  CreateMealRecordUseCase(this._repository);

  @override
  MealRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, MealRecordEntity>> call(
      CreateMealRecordParams params) async {
    try {
      final now = DateTime.now();
      final record = MealRecordEntity(
        dateTime: params.dateTime ?? now,
        mealType: params.mealType,
        foods: params.foods,
        fiberLevel: params.fiberLevel,
        createdAt: now,
      );
      final created = await _repository.createRecord(record);
      return Right(created);
    } catch (e) {
      return Left(CreateMealRecordFailure(
        '식사 기록 생성에 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
