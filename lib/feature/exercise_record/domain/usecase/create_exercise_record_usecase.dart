import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/exercise_record/domain/entity/exercise_record_entity.dart';
import 'package:poozizic/feature/exercise_record/domain/failure/exercise_record_failure.dart';
import 'package:poozizic/feature/exercise_record/domain/repository/exercise_record_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 운동 기록 생성 파라미터
class CreateExerciseRecordParams {
  /// 운동 기록 생성 파라미터 생성자
  /// [exerciseType] 운동 타입
  /// [durationMinutes] 운동 시간
  /// [intensity] 운동 강도
  /// [dateTime] 운동 날짜
  const CreateExerciseRecordParams({
    required this.exerciseType,
    required this.durationMinutes,
    required this.intensity,
    this.dateTime,
  });

  /// 운동 타입
  final int exerciseType;

  /// 운동 시간
  final int durationMinutes;

  /// 운동 강도
  final int intensity;

  /// 운동 날짜
  final DateTime? dateTime;
}

/// 운동 기록 생성 UseCase
class CreateExerciseRecordUseCase
    extends
        UseCase<
          ExerciseRecordEntity,
          CreateExerciseRecordParams,
          ExerciseRecordRepository
        > {
  /// 운동 기록 생성 UseCase 생성자
  CreateExerciseRecordUseCase(this._repository);
  final ExerciseRecordRepository _repository;

  @override
  ExerciseRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, ExerciseRecordEntity>> call(
    CreateExerciseRecordParams params,
  ) async {
    try {
      final now = DateTime.now();
      final record = ExerciseRecordEntity(
        dateTime: params.dateTime ?? now,
        exerciseType: params.exerciseType,
        durationMinutes: params.durationMinutes,
        intensity: params.intensity,
        createdAt: now,
      );
      final created = await _repository.createRecord(record);
      return Right(created);
    } catch (e) {
      return Left(
        CreateExerciseRecordFailure(
          '운동 기록 생성에 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
