import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/core/supabase/supabase_config.dart';
import 'package:poozizic/feature/record/di/record_providers.dart';
import 'package:poozizic/feature/settings/data/datasource/settings_local_datasource.dart';
import 'package:poozizic/feature/settings/data/datasource/settings_remote_datasource.dart';
import 'package:poozizic/feature/settings/data/repository/settings_repository_impl.dart';
import 'package:poozizic/feature/settings/domain/repository/settings_repository.dart';
import 'package:poozizic/feature/settings/domain/usecase/get_settings_usecase.dart';
import 'package:poozizic/feature/settings/domain/usecase/update_settings_usecase.dart';
import 'package:poozizic/feature/settings/presentation/provider/settings_notifier.dart';
import 'package:poozizic/feature/settings/presentation/provider/settings_state.dart';

/// DataSource Provider (Singleton으로 데이터 유지)
final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((
  ref,
) {
  return SettingsLocalDataSource();
});

/// Remote DataSource Provider
final settingsRemoteDataSourceProvider = Provider<SettingsRemoteDataSource>((
  ref,
) {
  return SettingsRemoteDataSource(SupabaseConfig.client);
});

/// Repository Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final localDataSource = ref.watch(settingsLocalDataSourceProvider);
  final remoteDataSource = ref.watch(settingsRemoteDataSourceProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  return SettingsRepositoryImpl(
    localDataSource,
    remoteDataSource,
    networkInfo,
  );
});

/// UseCase Providers
final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return GetSettingsUseCase(repository);
});

/// UpdateSettingsUseCase Provider
final updateSettingsUseCaseProvider = Provider<UpdateSettingsUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return UpdateSettingsUseCase(repository);
});

/// Notifier Provider
final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
      final repository = ref.watch(settingsRepositoryProvider);
      return SettingsNotifier(repository);
    });
