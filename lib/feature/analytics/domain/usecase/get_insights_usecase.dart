import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/analytics/domain/entity/insight_entity.dart';
import 'package:poozizic/feature/analytics/domain/failure/analytics_failure.dart';
import 'package:poozizic/feature/analytics/domain/repository/analytics_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 인사이트 조회 UseCase
class GetInsightsUseCase
    extends UseCase<List<InsightEntity>, NoParams, AnalyticsRepository> {
  /// 인사이트 조회 UseCase
  GetInsightsUseCase(this._repository);

  final AnalyticsRepository _repository;

  @override
  AnalyticsRepository get repo => _repository;

  @override
  Future<Either<Failure, List<InsightEntity>>> call(NoParams params) async {
    try {
      final insights = await _repository.getInsights();
      return Right(insights);
    } catch (e) {
      return Left(
        GetInsightsFailure(
          '인사이트를 불러오는데 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
