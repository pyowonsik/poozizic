import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/home/domain/entity/health_score_entity.dart';
import 'package:poozizic/feature/home/domain/failure/home_failure.dart';
import 'package:poozizic/feature/home/domain/repository/home_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 건강 점수 조회 UseCase
class GetHealthScoreUseCase
    extends UseCase<HealthScoreEntity, DateTime, HomeRepository> {
  /// 건강 점수 조회 UseCase 생성자
  GetHealthScoreUseCase(this._repository);
  final HomeRepository _repository;

  @override
  HomeRepository get repo => _repository;

  @override
  Future<Either<Failure, HealthScoreEntity>> call(DateTime date) async {
    try {
      final score = await _repository.getHealthScore(date);
      return Right(score);
    } catch (e) {
      return Left(
        GetHealthScoreFailure(
          '건강 점수를 불러오는데 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
