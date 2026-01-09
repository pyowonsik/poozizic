import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../record/domain/entity/record_entity.dart';
import '../../domain/entity/calendar_statistics.dart';
import '../../domain/repository/calendar_repository.dart';
import 'calendar_state.dart';

class CalendarNotifier extends StateNotifier<CalendarState> {
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
    selectDay(now);
  }

  Future<void> loadMonth(DateTime month) async {
    state = const CalendarLoading();

    final recordDaysResult = await _repository.getRecordDaysInMonth(month);
    final statisticsResult = await _repository.getStatisticsByMonth(month);

    Map<DateTime, List<RecordEntity>> recordDays = {};
    CalendarStatistics statistics = CalendarStatistics.empty();

    recordDaysResult.fold(
      (failure) => null,
      (data) => recordDays = data,
    );

    statisticsResult.fold(
      (failure) => null,
      (data) => statistics = data,
    );

    state = CalendarLoaded(
      focusedMonth: month,
      selectedDay: null,
      recordDays: recordDays,
      selectedDayRecords: [],
      statistics: statistics,
    );
  }

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

  Future<void> changeMonth(DateTime newMonth) async {
    await loadMonth(newMonth);
  }

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
