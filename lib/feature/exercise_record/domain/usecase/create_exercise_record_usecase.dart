import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/exercise_record_entity.dart';
import '../failure/exercise_record_failure.dart';
import '../repository/exercise_record_repository.dart';

/// 운동 기록 생성 파라미터
class CreateExerciseRecordParams {
  final int exerciseType;
  final int durationMinutes;
  final int intensity;
  final DateTime? dateTime;

  const CreateExerciseRecordParams({
    required this.exerciseType,
    required this.durationMinutes,
    required this.intensity,
    this.dateTime,
  });
}

/// 운동 기록 생성 UseCase
class CreateExerciseRecordUseCase extends UseCase<ExerciseRecordEntity,
    CreateExerciseRecordParams, ExerciseRecordRepository> {
  final ExerciseRecordRepository _repository;

  CreateExerciseRecordUseCase(this._repository);

  @override
  ExerciseRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, ExerciseRecordEntity>> call(
      CreateExerciseRecordParams params) async {
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
      return Left(CreateExerciseRecordFailure(
        '운동 기록 생성에 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
