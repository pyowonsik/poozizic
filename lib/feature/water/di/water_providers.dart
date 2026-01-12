import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/water_local_datasource.dart';
import '../data/repository/water_repository_impl.dart';
import '../domain/entity/water_record_entity.dart';
import '../domain/repository/water_repository.dart';
import '../domain/usecase/create_water_record_usecase.dart';
import '../domain/usecase/get_water_records_usecase.dart';
import '../../../shared/domain/usecase/usecase.dart';
import '../presentation/provider/water_notifier.dart';
import '../presentation/provider/water_state.dart';

/// DataSource Provider (Singleton으로 데이터 유지)
final waterLocalDataSourceProvider = Provider<WaterLocalDataSource>((ref) {
  return WaterLocalDataSource();
});

/// Repository Provider
final waterRepositoryProvider = Provider<WaterRepository>((ref) {
  final dataSource = ref.watch(waterLocalDataSourceProvider);
  return WaterRepositoryImpl(dataSource);
});

/// CreateWaterRecordUseCase Provider
final createWaterRecordUseCaseProvider = Provider<CreateWaterRecordUseCase>((ref) {
  final repository = ref.watch(waterRepositoryProvider);
  return CreateWaterRecordUseCase(repository);
});

/// GetWaterRecordsUseCase Provider
final getWaterRecordsUseCaseProvider = Provider<GetWaterRecordsUseCase>((ref) {
  final repository = ref.watch(waterRepositoryProvider);
  return GetWaterRecordsUseCase(repository);
});

/// WaterNotifier Provider
final waterNotifierProvider =
    StateNotifierProvider.autoDispose<WaterNotifier, WaterState>((ref) {
  final createWaterRecordUseCase = ref.watch(createWaterRecordUseCaseProvider);
  return WaterNotifier(createWaterRecordUseCase);
});

/// 전체 Water Records Provider
final waterRecordsProvider = FutureProvider<List<WaterRecordEntity>>((ref) async {
  final useCase = ref.watch(getWaterRecordsUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (records) => records,
  );
});
