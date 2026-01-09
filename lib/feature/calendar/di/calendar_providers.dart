import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../record/di/record_providers.dart';
import '../data/repository/calendar_repository_impl.dart';
import '../domain/repository/calendar_repository.dart';
import '../domain/usecase/get_records_by_month_usecase.dart';
import '../domain/usecase/get_statistics_usecase.dart';
import '../presentation/provider/calendar_state.dart';
import '../presentation/provider/calendar_notifier.dart';

/// Repository Provider (RecordLocalDataSource 재사용)
final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final recordDataSource = ref.watch(recordLocalDataSourceProvider);
  return CalendarRepositoryImpl(recordDataSource);
});

/// UseCase Providers
final getRecordsByMonthUseCaseProvider = Provider<GetRecordsByMonthUseCase>((ref) {
  final repository = ref.watch(calendarRepositoryProvider);
  return GetRecordsByMonthUseCase(repository);
});

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
