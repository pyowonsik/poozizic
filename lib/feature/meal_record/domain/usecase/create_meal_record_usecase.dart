import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/meal_record/domain/entity/meal_record_entity.dart';
import 'package:poozizic/feature/meal_record/domain/failure/meal_record_failure.dart';
import 'package:poozizic/feature/meal_record/domain/repository/meal_record_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 식사 기록 생성 파라미터
class CreateMealRecordParams {
  /// 식사 기록 생성 파라미터 생성자
  /// [mealType] 식사 타입
  /// [foods] 음식 목록
  /// [fiberLevel] 식이섬유 레벨
  /// [dateTime] 식사 날짜
  const CreateMealRecordParams({
    required this.mealType,
    required this.foods,
    required this.fiberLevel,
    this.dateTime,
  });

  /// 식사 타입
  final int mealType;

  /// 음식 목록
  final List<String> foods;

  /// 식이섬유 레벨
  final int fiberLevel;

  /// 식사 날짜
  final DateTime? dateTime;
}

/// 식사 기록 생성 UseCase
class CreateMealRecordUseCase
    extends
        UseCase<
          MealRecordEntity,
          CreateMealRecordParams,
          MealRecordRepository
        > {
  /// 식사 기록 생성 UseCase 생성자
  CreateMealRecordUseCase(this._repository);
  final MealRecordRepository _repository;

  @override
  MealRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, MealRecordEntity>> call(
    CreateMealRecordParams params,
  ) async {
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
      return Left(
        CreateMealRecordFailure(
          '식사 기록 생성에 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
