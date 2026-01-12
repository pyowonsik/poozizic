import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/insight_entity.dart';
import '../failure/analytics_failure.dart';
import '../repository/analytics_repository.dart';

/// 인사이트 조회 UseCase
class GetInsightsUseCase
    extends UseCase<List<InsightEntity>, NoParams, AnalyticsRepository> {
  final AnalyticsRepository _repository;

  GetInsightsUseCase(this._repository);

  @override
  AnalyticsRepository get repo => _repository;

  @override
  Future<Either<Failure, List<InsightEntity>>> call(NoParams params) async {
    try {
      final insights = await _repository.getInsights();
      return Right(insights);
    } catch (e) {
      return Left(GetInsightsFailure(
        '인사이트를 불러오는데 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
