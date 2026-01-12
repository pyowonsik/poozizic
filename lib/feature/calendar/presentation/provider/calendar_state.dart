import 'package:poozizic/feature/calendar/domain/entity/calendar_statistics.dart';
import 'package:poozizic/feature/record/domain/entity/record_entity.dart';

/// Calendar 화면 상태 (Sealed Class)
sealed class CalendarState {
  /// Calendar 화면 상태 생성자
  const CalendarState();
}

/// 초기 상태
class CalendarInitial extends CalendarState {
  /// Calendar 초기 상태 생성자
  const CalendarInitial();
}

/// 로딩 상태
class CalendarLoading extends CalendarState {
  /// Calendar 로딩 상태 생성자
  const CalendarLoading();
}

/// 로드 완료 상태
class CalendarLoaded extends CalendarState {
  /// Calendar 로드 완료 상태 생성자
  const CalendarLoaded({
    required this.focusedMonth,
    required this.recordDays,
    required this.selectedDayRecords,
    required this.statistics,
    this.selectedDay,
  });

  /// Calendar 포커스 월
  final DateTime focusedMonth;

  /// Calendar 선택된 날짜
  final DateTime? selectedDay;

  /// Calendar 기록 날짜별 목록
  final Map<DateTime, List<RecordEntity>> recordDays;

  /// Calendar 선택된 날짜 기록
  final List<RecordEntity> selectedDayRecords;

  /// Calendar 통계
  final CalendarStatistics statistics;

  /// Calendar 로드 완료 상태 복사
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
  /// Calendar 에러 상태 생성자
  /// [message] 에러 메시지
  const CalendarError(this.message);

  /// 에러 메시지
  final String message;
}
