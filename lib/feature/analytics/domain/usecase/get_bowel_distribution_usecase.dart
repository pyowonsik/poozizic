import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/bowel_distribution_entity.dart';
import '../failure/analytics_failure.dart';
import '../repository/analytics_repository.dart';

/// 배변 분포 조회 UseCase
class GetBowelDistributionUseCase
    extends UseCase<BowelDistributionEntity, int, AnalyticsRepository> {
  final AnalyticsRepository _repository;

  GetBowelDistributionUseCase(this._repository);

  @override
  AnalyticsRepository get repo => _repository;

  @override
  Future<Either<Failure, BowelDistributionEntity>> call(int days) async {
    try {
      final distribution = await _repository.getBowelDistribution(days);
      return Right(distribution);
    } catch (e) {
      return Left(GetBowelDistributionFailure(
        '배변 분포를 불러오는데 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
