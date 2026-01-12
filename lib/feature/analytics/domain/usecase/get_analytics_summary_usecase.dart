import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/analytics/domain/entity/analytics_summary_entity.dart';
import 'package:poozizic/feature/analytics/domain/failure/analytics_failure.dart';
import 'package:poozizic/feature/analytics/domain/repository/analytics_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 분석 요약 조회 UseCase
class GetAnalyticsSummaryUseCase
    extends UseCase<AnalyticsSummaryEntity, int, AnalyticsRepository> {
  /// 분석 요약 조회 UseCase
  GetAnalyticsSummaryUseCase(this._repository);

  /// 분석 요약 조회 리포지토리
  final AnalyticsRepository _repository;

  @override
  AnalyticsRepository get repo => _repository;

  @override
  Future<Either<Failure, AnalyticsSummaryEntity>> call(int days) async {
    try {
      final summary = await _repository.getAnalyticsSummary(days);
      return Right(summary);
    } catch (e) {
      return Left(
        GetAnalyticsSummaryFailure(
          '분석 요약을 불러오는데 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
