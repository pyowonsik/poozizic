import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/daily_summary_entity.dart';
import '../failure/home_failure.dart';
import '../repository/home_repository.dart';

/// 일일 요약 조회 UseCase
class GetDailySummaryUseCase
    extends UseCase<DailySummaryEntity, DateTime, HomeRepository> {
  final HomeRepository _repository;

  GetDailySummaryUseCase(this._repository);

  @override
  HomeRepository get repo => _repository;

  @override
  Future<Either<Failure, DailySummaryEntity>> call(DateTime date) async {
    try {
      final summary = await _repository.getDailySummary(date);
      return Right(summary);
    } catch (e) {
      return Left(GetDailySummaryFailure(
        '일일 요약을 불러오는데 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
