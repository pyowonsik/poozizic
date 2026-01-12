import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/exercise_record_entity.dart';
import '../failure/exercise_record_failure.dart';
import '../repository/exercise_record_repository.dart';

/// 특정 날짜 운동 기록 조회 UseCase
class GetExerciseRecordsByDateUseCase extends UseCase<
    List<ExerciseRecordEntity>, DateTime, ExerciseRecordRepository> {
  final ExerciseRecordRepository _repository;

  GetExerciseRecordsByDateUseCase(this._repository);

  @override
  ExerciseRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, List<ExerciseRecordEntity>>> call(
      DateTime date) async {
    try {
      final records = await _repository.getRecordsByDate(date);
      return Right(records);
    } catch (e) {
      return Left(GetExerciseRecordsFailure(
        '운동 기록 조회에 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
