import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/calendar/domain/repository/calendar_repository.dart';
import 'package:poozizic/feature/record/domain/entity/record_entity.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 월별 기록 조회 파라미터
class GetRecordsByMonthParams {
  /// 월별 기록 조회 파라미터 생성자
  /// [month] 월
  const GetRecordsByMonthParams({required this.month});

  /// 월
  final DateTime month;
}

/// 월별 기록 조회 UseCase
class GetRecordsByMonthUseCase
    implements
        UseCase<
          List<RecordEntity>,
          GetRecordsByMonthParams,
          CalendarRepository
        > {
  /// 월별 기록 조회 UseCase 생성자
  GetRecordsByMonthUseCase(this._repository);

  final CalendarRepository _repository;

  @override
  CalendarRepository get repo => _repository;

  @override
  Future<Either<Failure, List<RecordEntity>>> call(
    GetRecordsByMonthParams params,
  ) {
    return _repository.getRecordsByMonth(params.month);
  }
}
