import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/calendar/domain/entity/calendar_statistics.dart';
import 'package:poozizic/feature/record/domain/entity/record_entity.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';

/// Calendar Repository Interface
abstract class CalendarRepository {
  /// 특정 월의 모든 기록 조회
  Future<Either<Failure, List<RecordEntity>>> getRecordsByMonth(DateTime month);

  /// 특정 날짜의 기록 조회
  Future<Either<Failure, List<RecordEntity>>> getRecordsByDate(DateTime date);

  /// 특정 월의 통계 조회
  Future<Either<Failure, CalendarStatistics>> getStatisticsByMonth(
    DateTime month,
  );

  /// 기록이 있는 날짜 목록 조회 (캘린더 마커용)
  Future<Either<Failure, Map<DateTime, List<RecordEntity>>>>
  getRecordDaysInMonth(DateTime month);
}
