import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/weekly_frequency_entity.dart';
import '../failure/analytics_failure.dart';
import '../repository/analytics_repository.dart';

/// 주간 빈도 조회 UseCase
class GetWeeklyFrequencyUseCase
    extends UseCase<WeeklyFrequencyEntity, NoParams, AnalyticsRepository> {
  final AnalyticsRepository _repository;

  GetWeeklyFrequencyUseCase(this._repository);

  @override
  AnalyticsRepository get repo => _repository;

  @override
  Future<Either<Failure, WeeklyFrequencyEntity>> call(NoParams params) async {
    try {
      final frequency = await _repository.getWeeklyFrequency();
      return Right(frequency);
    } catch (e) {
      return Left(GetWeeklyFrequencyFailure(
        '주간 빈도를 불러오는데 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
