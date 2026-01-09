import '../../../record/domain/entity/record_entity.dart';
import '../../domain/entity/calendar_statistics.dart';

/// Calendar 화면 상태 (Sealed Class)
sealed class CalendarState {
  const CalendarState();
}

/// 초기 상태
class CalendarInitial extends CalendarState {
  const CalendarInitial();
}

/// 로딩 상태
class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

/// 로드 완료 상태
class CalendarLoaded extends CalendarState {
  final DateTime focusedMonth;
  final DateTime? selectedDay;
  final Map<DateTime, List<RecordEntity>> recordDays;
  final List<RecordEntity> selectedDayRecords;
  final CalendarStatistics statistics;

  const CalendarLoaded({
    required this.focusedMonth,
    this.selectedDay,
    required this.recordDays,
    required this.selectedDayRecords,
    required this.statistics,
  });

  CalendarLoaded copyWith({
    DateTime? focusedMonth,
    DateTime? selectedDay,
    Map<DateTime, List<RecordEntity>>? recordDays,
    List<RecordEntity>? selectedDayRecords,
    CalendarStatistics? statistics,
  }) {
    return CalendarLoaded(
      focusedMonth: focusedMonth ?? this.focusedMonth,
      selectedDay: selectedDay ?? this.selectedDay,
      recordDays: recordDays ?? this.recordDays,
      selectedDayRecords: selectedDayRecords ?? this.selectedDayRecords,
      statistics: statistics ?? this.statistics,
    );
  }
}

/// 에러 상태
class CalendarError extends CalendarState {
  final String message;

  const CalendarError(this.message);
}
