import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../record/domain/entity/record_entity.dart';
import '../../../record/data/datasource/record_local_datasource.dart';
import '../../domain/entity/calendar_statistics.dart';
import '../../domain/repository/calendar_repository.dart';
import '../../domain/failure/calendar_failure.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  CalendarRepositoryImpl(this._recordDataSource);

  final RecordLocalDataSource _recordDataSource;

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  @override
  Future<Either<Failure, List<RecordEntity>>> getRecordsByMonth(DateTime month) async {
    try {
      final allRecords = await _recordDataSource.getAllRecords();
      final monthRecords = allRecords.where((record) {
        return record.dateTime.year == month.year && record.dateTime.month == month.month;
      }).toList();

      monthRecords.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return Right(monthRecords);
    } catch (e, st) {
      return Left(GetCalendarRecordsFailure(
        '월별 기록을 불러오는데 실패했습니다',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      ));
    }
  }

  @override
  Future<Either<Failure, List<RecordEntity>>> getRecordsByDate(DateTime date) async {
    try {
      final records = await _recordDataSource.getRecordsByDate(date);
      records.sort((a, b) => b.dateTime.compareTo(a.dateTime));
      return Right(records);
    } catch (e, st) {
      return Left(GetCalendarRecordsFailure(
        '해당 날짜의 기록을 불러오는데 실패했습니다',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      ));
    }
  }

  @override
  Future<Either<Failure, CalendarStatistics>> getStatisticsByMonth(DateTime month) async {
    try {
      final allRecords = await _recordDataSource.getAllRecords();
      final monthRecords = allRecords.where((record) {
        return record.dateTime.year == month.year && record.dateTime.month == month.month;
      }).toList();

      if (monthRecords.isEmpty) {
        return Right(CalendarStatistics.empty());
      }

      // 정상 비율 계산 (Bristol Type 3-5가 정상)
      final healthyCount = monthRecords.where((r) => r.isHealthy).length;
      final healthyPercentage = (healthyCount / monthRecords.length) * 100;

      // 평균 간격 계산
      double averageInterval = 0.0;
      if (monthRecords.length > 1) {
        monthRecords.sort((a, b) => a.dateTime.compareTo(b.dateTime));
        int totalDays = 0;
        for (int i = 1; i < monthRecords.length; i++) {
          final diff = monthRecords[i].dateTime.difference(monthRecords[i - 1].dateTime).inDays;
          totalDays += diff;
        }
        averageInterval = totalDays / (monthRecords.length - 1);
      }

      return Right(CalendarStatistics(
        totalRecordsThisMonth: monthRecords.length,
        healthyPercentage: healthyPercentage,
        averageIntervalDays: averageInterval,
      ));
    } catch (e, st) {
      return Left(GetCalendarStatisticsFailure(
        '통계를 불러오는데 실패했습니다',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      ));
    }
  }

  @override
  Future<Either<Failure, Map<DateTime, List<RecordEntity>>>> getRecordDaysInMonth(DateTime month) async {
    try {
      final allRecords = await _recordDataSource.getAllRecords();
      final monthRecords = allRecords.where((record) {
        return record.dateTime.year == month.year && record.dateTime.month == month.month;
      }).toList();

      final Map<DateTime, List<RecordEntity>> recordDays = {};
      for (final record in monthRecords) {
        final dateKey = _normalizeDate(record.dateTime);
        if (recordDays.containsKey(dateKey)) {
          recordDays[dateKey]!.add(record);
        } else {
          recordDays[dateKey] = [record];
        }
      }

      return Right(recordDays);
    } catch (e, st) {
      return Left(GetCalendarRecordsFailure(
        '기록 날짜를 불러오는데 실패했습니다',
        exception: e is Exception ? e : Exception(e.toString()),
        stackTrace: st,
      ));
    }
  }
}
