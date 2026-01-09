import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/calendar_statistics.dart';
import '../repository/calendar_repository.dart';

class GetStatisticsParams {
  final DateTime month;

  const GetStatisticsParams({required this.month});
}

class GetStatisticsUseCase
    implements UseCase<CalendarStatistics, GetStatisticsParams, CalendarRepository> {
  GetStatisticsUseCase(this._repository);

  final CalendarRepository _repository;

  @override
  CalendarRepository get repo => _repository;

  @override
  Future<Either<Failure, CalendarStatistics>> call(GetStatisticsParams params) {
    return _repository.getStatisticsByMonth(params.month);
  }
}
