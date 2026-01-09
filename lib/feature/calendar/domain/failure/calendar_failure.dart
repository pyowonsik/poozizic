import '../../../../shared/domain/failure/failure.dart';

/// Calendar 기록 조회 실패
class GetCalendarRecordsFailure extends Failure {
  const GetCalendarRecordsFailure(super.message, {super.exception, super.stackTrace});
}

/// Calendar 통계 조회 실패
class GetCalendarStatisticsFailure extends Failure {
  const GetCalendarStatisticsFailure(super.message, {super.exception, super.stackTrace});
}
