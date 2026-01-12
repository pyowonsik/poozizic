import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/core/network/network_info.dart';
import 'package:poozizic/core/supabase/supabase_config.dart';
import 'package:poozizic/feature/calendar/di/calendar_providers.dart';
import 'package:poozizic/feature/record/data/datasource/record_local_datasource.dart';
import 'package:poozizic/feature/record/data/datasource/record_remote_datasource.dart';
import 'package:poozizic/feature/record/data/repository/record_repository_impl.dart';
import 'package:poozizic/feature/record/domain/entity/record_entity.dart';
import 'package:poozizic/feature/record/domain/repository/record_repository.dart';
import 'package:poozizic/feature/record/domain/usecase/create_record_usecase.dart';
import 'package:poozizic/feature/record/domain/usecase/get_records_by_date_usecase.dart';
import 'package:poozizic/feature/record/domain/usecase/get_records_usecase.dart';
import 'package:poozizic/feature/record/presentation/provider/record_form_notifier.dart';
import 'package:poozizic/feature/record/presentation/provider/record_form_state.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// NetworkInfo Provider
final networkInfoProvider = Provider<NetworkInfo>((ref) {
  return NetworkInfoImpl(Connectivity());
});

/// DataSource Provider (Singleton으로 데이터 유지)
final recordLocalDataSourceProvider = Provider<RecordLocalDataSource>((ref) {
  return RecordLocalDataSource();
});

/// Remote DataSource Provider
final recordRemoteDataSourceProvider = Provider<RecordRemoteDataSource>((ref) {
  return RecordRemoteDataSource(SupabaseConfig.client);
});

/// Repository Provider
final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  final localDataSource = ref.watch(recordLocalDataSourceProvider);
  final remoteDataSource = ref.watch(recordRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return RecordRepositoryImpl(localDataSource, remoteDataSource, networkInfo);
});

/// CreateRecordUseCase Provider
final createRecordUseCaseProvider = Provider<CreateRecordUseCase>((ref) {
  final repository = ref.watch(recordRepositoryProvider);
  return CreateRecordUseCase(repository);
});

/// GetRecordsUseCase Provider
final getRecordsUseCaseProvider = Provider<GetRecordsUseCase>((ref) {
  final repository = ref.watch(recordRepositoryProvider);
  return GetRecordsUseCase(repository);
});

/// GetRecordsByDateUseCase Provider
final getRecordsByDateUseCaseProvider = Provider<GetRecordsByDateUseCase>((
  ref,
) {
  final repository = ref.watch(recordRepositoryProvider);
  return GetRecordsByDateUseCase(repository);
});

/// RecordFormNotifier Provider
final recordFormNotifierProvider =
    StateNotifierProvider.autoDispose<RecordFormNotifier, RecordFormState>((
      ref,
    ) {
      final createRecordUseCase = ref.watch(createRecordUseCaseProvider);
      return RecordFormNotifier(createRecordUseCase);
    });

/// 전체 Records Provider (Calendar에서 사용)
final recordsProvider = FutureProvider<List<RecordEntity>>((ref) async {
  final useCase = ref.watch(getRecordsUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (records) => records,
  );
});

/// 기록 갱신을 위한 StateProvider
final recordsRefreshProvider = StateProvider<int>((ref) => 0);

/// 기록 갱신 트리거 (Record 추가 후 Calendar 갱신용)
void refreshRecords(WidgetRef ref) {
  ref.read(recordsRefreshProvider.notifier).state++;
  ref.invalidate(recordsProvider);
  // Calendar도 갱신
  refreshCalendar(ref);
}
