import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/analytics/domain/entity/weekly_frequency_entity.dart';
import 'package:poozizic/feature/analytics/domain/failure/analytics_failure.dart';
import 'package:poozizic/feature/analytics/domain/repository/analytics_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 주간 빈도 조회 UseCase
class GetWeeklyFrequencyUseCase
    extends UseCase<WeeklyFrequencyEntity, NoParams, AnalyticsRepository> {
  /// 주간 빈도 조회 UseCase
  GetWeeklyFrequencyUseCase(this._repository);

  final AnalyticsRepository _repository;

  @override
  AnalyticsRepository get repo => _repository;

  @override
  Future<Either<Failure, WeeklyFrequencyEntity>> call(NoParams params) async {
    try {
      final frequency = await _repository.getWeeklyFrequency();
      return Right(frequency);
    } catch (e) {
      return Left(
        GetWeeklyFrequencyFailure(
          '주간 빈도를 불러오는데 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
