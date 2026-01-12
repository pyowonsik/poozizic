import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/calendar/data/repository/calendar_repository_impl.dart';
import 'package:poozizic/feature/calendar/domain/repository/calendar_repository.dart';
import 'package:poozizic/feature/calendar/domain/usecase/get_records_by_month_usecase.dart';
import 'package:poozizic/feature/calendar/domain/usecase/get_statistics_usecase.dart';
import 'package:poozizic/feature/calendar/presentation/provider/calendar_notifier.dart';
import 'package:poozizic/feature/calendar/presentation/provider/calendar_state.dart';
import 'package:poozizic/feature/record/di/record_providers.dart';

/// Repository Provider (RecordRepository 재사용)
final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final recordRepository = ref.watch(recordRepositoryProvider);
  return CalendarRepositoryImpl(recordRepository);
});

/// UseCase Providers
final getRecordsByMonthUseCaseProvider = Provider<GetRecordsByMonthUseCase>((
  ref,
) {
  final repository = ref.watch(calendarRepositoryProvider);
  return GetRecordsByMonthUseCase(repository);
});

/// GetStatisticsUseCase Provider
final getStatisticsUseCaseProvider = Provider<GetStatisticsUseCase>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return GetStatisticsUseCase(repository);
});

/// Notifier Provider
final calendarNotifierProvider =
    StateNotifierProvider<CalendarNotifier, CalendarState>((ref) {
      final repository = ref.watch(calendarRepositoryProvider);
      return CalendarNotifier(repository);
    });

/// Calendar 데이터 새로고침 함수
void refreshCalendar(WidgetRef ref) {
  ref.read(calendarNotifierProvider.notifier).refresh();
}
