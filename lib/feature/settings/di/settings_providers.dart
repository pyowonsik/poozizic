import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/settings_local_datasource.dart';
import '../data/repository/settings_repository_impl.dart';
import '../domain/repository/settings_repository.dart';
import '../domain/usecase/get_settings_usecase.dart';
import '../domain/usecase/update_settings_usecase.dart';
import '../presentation/provider/settings_state.dart';
import '../presentation/provider/settings_notifier.dart';

/// DataSource Provider (Singleton으로 데이터 유지)
final settingsLocalDataSourceProvider = Provider<SettingsLocalDataSource>((ref) {
  return SettingsLocalDataSource();
});

/// Repository Provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final dataSource = ref.watch(settingsLocalDataSourceProvider);
  return SettingsRepositoryImpl(dataSource);
});

/// UseCase Providers
final getSettingsUseCaseProvider = Provider<GetSettingsUseCase>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return GetSettingsUseCase(repository);
});

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
