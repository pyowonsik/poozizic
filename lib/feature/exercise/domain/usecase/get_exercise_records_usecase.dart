import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/exercise_record_entity.dart';
import '../failure/exercise_failure.dart';
import '../repository/exercise_repository.dart';

/// 운동 기록 조회 UseCase
class GetExerciseRecordsUseCase
    implements UseCase<List<ExerciseRecordEntity>, NoParams, ExerciseRepository> {
  const GetExerciseRecordsUseCase(this.repository);

  final ExerciseRepository repository;

  @override
  ExerciseRepository get repo => repository;

  @override
  Future<Either<Failure, List<ExerciseRecordEntity>>> call(NoParams params) async {
    try {
      final records = await repository.getAllRecords();
      return Right(records);
    } on Exception catch (e) {
      return Left(
        GetExerciseRecordsFailure('운동 기록을 조회할 수 없습니다.', exception: e),
      );
    }
  }
}
