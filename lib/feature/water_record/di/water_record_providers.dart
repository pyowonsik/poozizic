import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/water_record_local_datasource.dart';
import '../data/repository/water_record_repository_impl.dart';
import '../domain/entity/water_record_entity.dart';
import '../domain/repository/water_record_repository.dart';
import '../domain/usecase/create_water_record_usecase.dart';
import '../domain/usecase/get_water_records_by_date_usecase.dart';
import '../presentation/provider/water_record_form_notifier.dart';
import '../presentation/provider/water_record_form_state.dart';

/// DataSource Provider (Singleton으로 데이터 유지)
final waterRecordLocalDataSourceProvider =
    Provider<WaterRecordLocalDataSource>((ref) {
  return WaterRecordLocalDataSource();
});

/// Repository Provider
final waterRecordRepositoryProvider = Provider<WaterRecordRepository>((ref) {
  final dataSource = ref.watch(waterRecordLocalDataSourceProvider);
  return WaterRecordRepositoryImpl(dataSource);
});

/// CreateWaterRecordUseCase Provider
final createWaterRecordUseCaseProvider =
    Provider<CreateWaterRecordUseCase>((ref) {
  final repository = ref.watch(waterRecordRepositoryProvider);
  return CreateWaterRecordUseCase(repository);
});

/// GetWaterRecordsByDateUseCase Provider
final getWaterRecordsByDateUseCaseProvider =
    Provider<GetWaterRecordsByDateUseCase>((ref) {
  final repository = ref.watch(waterRecordRepositoryProvider);
  return GetWaterRecordsByDateUseCase(repository);
});

/// WaterRecordFormNotifier Provider (autoDispose for form screens)
final waterRecordFormNotifierProvider = StateNotifierProvider.autoDispose<
    WaterRecordFormNotifier, WaterRecordFormState>((ref) {
  final createWaterRecordUseCase = ref.watch(createWaterRecordUseCaseProvider);
  return WaterRecordFormNotifier(createWaterRecordUseCase);
});

/// 오늘 수분 기록 Provider
final todayWaterRecordsProvider =
    FutureProvider<List<WaterRecordEntity>>((ref) async {
  final useCase = ref.watch(getWaterRecordsByDateUseCaseProvider);
  final result = await useCase(DateTime.now());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (records) => records,
  );
});

/// 오늘 총 수분 섭취량 Provider
final todayWaterTotalProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(waterRecordRepositoryProvider);
  return repository.getDailyTotal(DateTime.now());
});

/// 수분 기록 갱신을 위한 StateProvider
final waterRecordsRefreshProvider = StateProvider<int>((ref) => 0);

/// 수분 기록 갱신 트리거
void refreshWaterRecords(WidgetRef ref) {
  ref.read(waterRecordsRefreshProvider.notifier).state++;
  ref.invalidate(todayWaterRecordsProvider);
  ref.invalidate(todayWaterTotalProvider);
}
