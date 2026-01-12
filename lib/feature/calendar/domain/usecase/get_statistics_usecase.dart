import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/calendar/domain/entity/calendar_statistics.dart';
import 'package:poozizic/feature/calendar/domain/repository/calendar_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 월별 통계 조회 파라미터
class GetStatisticsParams {
  /// 월별 통계 조회 파라미터 생성자
  /// [month] 월
  const GetStatisticsParams({required this.month});

  /// 월
  final DateTime month;
}

/// 월별 통계 조회 UseCase
class GetStatisticsUseCase
    implements
        UseCase<CalendarStatistics, GetStatisticsParams, CalendarRepository> {
  /// 월별 통계 조회 UseCase 생성자
  GetStatisticsUseCase(this._repository);

  /// 캘린더 리포지토리

  final CalendarRepository _repository;

  @override
  CalendarRepository get repo => _repository;

  @override
  Future<Either<Failure, CalendarStatistics>> call(GetStatisticsParams params) {
    return _repository.getStatisticsByMonth(params.month);
  }
}
