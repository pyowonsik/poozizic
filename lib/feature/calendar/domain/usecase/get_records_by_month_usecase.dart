import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../../../record/domain/entity/record_entity.dart';
import '../repository/calendar_repository.dart';

class GetRecordsByMonthParams {
  final DateTime month;

  const GetRecordsByMonthParams({required this.month});
}

class GetRecordsByMonthUseCase
    implements UseCase<List<RecordEntity>, GetRecordsByMonthParams, CalendarRepository> {
  GetRecordsByMonthUseCase(this._repository);

  final CalendarRepository _repository;

  @override
  CalendarRepository get repo => _repository;

  @override
  Future<Either<Failure, List<RecordEntity>>> call(GetRecordsByMonthParams params) {
    return _repository.getRecordsByMonth(params.month);
  }
}
