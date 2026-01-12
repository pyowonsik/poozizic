import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/analytics/domain/entity/bowel_distribution_entity.dart';
import 'package:poozizic/feature/analytics/domain/failure/analytics_failure.dart';
import 'package:poozizic/feature/analytics/domain/repository/analytics_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 배변 분포 조회 UseCase
class GetBowelDistributionUseCase
    extends UseCase<BowelDistributionEntity, int, AnalyticsRepository> {
  /// 배변 분포 조회 UseCase
  GetBowelDistributionUseCase(this._repository);

  final AnalyticsRepository _repository;

  @override
  AnalyticsRepository get repo => _repository;

  @override
  Future<Either<Failure, BowelDistributionEntity>> call(int days) async {
    try {
      final distribution = await _repository.getBowelDistribution(days);
      return Right(distribution);
    } catch (e) {
      return Left(
        GetBowelDistributionFailure(
          '배변 분포를 불러오는데 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
