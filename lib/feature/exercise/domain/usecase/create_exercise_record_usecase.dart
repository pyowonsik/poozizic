import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/exercise_record_entity.dart';
import '../failure/exercise_failure.dart';
import '../repository/exercise_repository.dart';

/// 운동 기록 생성 UseCase
class CreateExerciseRecordUseCase
    implements UseCase<ExerciseRecordEntity, CreateExerciseRecordParams, ExerciseRepository> {
  const CreateExerciseRecordUseCase(this.repository);

  final ExerciseRepository repository;

  @override
  ExerciseRepository get repo => repository;

  @override
  Future<Either<Failure, ExerciseRecordEntity>> call(CreateExerciseRecordParams params) async {
    try {
      final record = ExerciseRecordEntity(
        exerciseType: params.exerciseType,
        duration: params.duration,
        intensity: params.intensity,
        recordedAt: DateTime.now(),
      );
      final result = await repository.createRecord(record);
      return Right(result);
    } on Exception catch (e) {
      return Left(
        CreateExerciseRecordFailure('운동 기록을 저장할 수 없습니다.', exception: e),
      );
    }
  }
}

/// 운동 기록 생성 파라미터
class CreateExerciseRecordParams {
  const CreateExerciseRecordParams({
    required this.exerciseType,
    required this.duration,
    required this.intensity,
  });

  final int exerciseType;
  final int duration;
  final int intensity;
}
