import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/home/domain/entity/daily_summary_entity.dart';
import 'package:poozizic/feature/home/domain/failure/home_failure.dart';
import 'package:poozizic/feature/home/domain/repository/home_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 일일 요약 조회 UseCase
class GetDailySummaryUseCase
    extends UseCase<DailySummaryEntity, DateTime, HomeRepository> {
  /// 일일 요약 조회 UseCase 생성자
  GetDailySummaryUseCase(this._repository);

  /// 일일 요약 리포지토리
  final HomeRepository _repository;

  @override
  HomeRepository get repo => _repository;

  @override
  Future<Either<Failure, DailySummaryEntity>> call(DateTime date) async {
    try {
      final summary = await _repository.getDailySummary(date);
      return Right(summary);
    } catch (e) {
      return Left(
        GetDailySummaryFailure(
          '일일 요약을 불러오는데 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
