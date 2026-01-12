import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/analytics_summary_entity.dart';
import '../failure/analytics_failure.dart';
import '../repository/analytics_repository.dart';

/// 분석 요약 조회 UseCase
class GetAnalyticsSummaryUseCase
    extends UseCase<AnalyticsSummaryEntity, int, AnalyticsRepository> {
  final AnalyticsRepository _repository;

  GetAnalyticsSummaryUseCase(this._repository);

  @override
  AnalyticsRepository get repo => _repository;

  @override
  Future<Either<Failure, AnalyticsSummaryEntity>> call(int days) async {
    try {
      final summary = await _repository.getAnalyticsSummary(days);
      return Right(summary);
    } catch (e) {
      return Left(GetAnalyticsSummaryFailure(
        '분석 요약을 불러오는데 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
