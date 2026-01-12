import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/exercise_record/domain/entity/exercise_record_entity.dart';
import 'package:poozizic/feature/exercise_record/domain/failure/exercise_record_failure.dart';
import 'package:poozizic/feature/exercise_record/domain/repository/exercise_record_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 특정 날짜 운동 기록 조회 UseCase
class GetExerciseRecordsByDateUseCase
    extends
        UseCase<
          List<ExerciseRecordEntity>,
          DateTime,
          ExerciseRecordRepository
        > {
  /// 특정 날짜 운동 기록 조회 UseCase 생성자
  GetExerciseRecordsByDateUseCase(this._repository);
  final ExerciseRecordRepository _repository;

  @override
  ExerciseRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, List<ExerciseRecordEntity>>> call(
    DateTime date,
  ) async {
    try {
      final records = await _repository.getRecordsByDate(date);
      return Right(records);
    } catch (e) {
      return Left(
        GetExerciseRecordsFailure(
          '운동 기록 조회에 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
