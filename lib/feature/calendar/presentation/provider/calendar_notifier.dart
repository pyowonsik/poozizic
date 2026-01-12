import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/calendar/domain/entity/calendar_statistics.dart';
import 'package:poozizic/feature/calendar/domain/repository/calendar_repository.dart';
import 'package:poozizic/feature/calendar/presentation/provider/calendar_state.dart';
import 'package:poozizic/feature/record/domain/entity/record_entity.dart';

/// Calendar Notifier
class CalendarNotifier extends StateNotifier<CalendarState> {
  /// Calendar Notifier 생성자
  CalendarNotifier(this._repository) : super(const CalendarInitial()) {
    _init();
  }

  final CalendarRepository _repository;

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  Future<void> _init() async {
    final now = DateTime.now();
    await loadMonth(now);
    await selectDay(now);
  }

  /// 월 로드
  Future<void> loadMonth(DateTime month) async {
    state = const CalendarLoading();

    final recordDaysResult = await _repository.getRecordDaysInMonth(month);
    final statisticsResult = await _repository.getStatisticsByMonth(month);

    var recordDays = <DateTime, List<RecordEntity>>{};
    var statistics = CalendarStatistics.empty();

    recordDaysResult.fold((failure) => null, (data) => recordDays = data);

    statisticsResult.fold((failure) => null, (data) => statistics = data);

    state = CalendarLoaded(
      focusedMonth: month,
      recordDays: recordDays,
      selectedDayRecords: [],
      statistics: statistics,
    );
  }

  /// 날짜 선택
  Future<void> selectDay(DateTime day) async {
    final current = state;
    if (current is! CalendarLoaded) return;

    final normalizedDay = _normalizeDate(day);
    final result = await _repository.getRecordsByDate(normalizedDay);

    result.fold(
      (failure) {
        state = current.copyWith(
          selectedDay: normalizedDay,
          selectedDayRecords: [],
        );
      },
      (records) {
        state = current.copyWith(
          selectedDay: normalizedDay,
          selectedDayRecords: records,
        );
      },
    );
  }

  /// 월 변경
  Future<void> changeMonth(DateTime newMonth) async {
    await loadMonth(newMonth);
  }

  /// 새로고침
  Future<void> refresh() async {
    final current = state;
    if (current is CalendarLoaded) {
      await loadMonth(current.focusedMonth);
      if (current.selectedDay != null) {
        await selectDay(current.selectedDay!);
      }
    }
  }
}
