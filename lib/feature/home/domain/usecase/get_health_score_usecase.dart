import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/health_score_entity.dart';
import '../failure/home_failure.dart';
import '../repository/home_repository.dart';

/// 건강 점수 조회 UseCase
class GetHealthScoreUseCase
    extends UseCase<HealthScoreEntity, DateTime, HomeRepository> {
  final HomeRepository _repository;

  GetHealthScoreUseCase(this._repository);

  @override
  HomeRepository get repo => _repository;

  @override
  Future<Either<Failure, HealthScoreEntity>> call(DateTime date) async {
    try {
      final score = await _repository.getHealthScore(date);
      return Right(score);
    } catch (e) {
      return Left(GetHealthScoreFailure(
        '건강 점수를 불러오는데 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
