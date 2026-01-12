import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/core/supabase/supabase_config.dart';
import 'package:poozizic/feature/auth/data/datasource/auth_remote_datasource.dart';
import 'package:poozizic/feature/auth/data/repository/auth_repository_impl.dart';
import 'package:poozizic/feature/auth/domain/repository/auth_repository.dart';
import 'package:poozizic/feature/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:poozizic/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:poozizic/feature/auth/domain/usecase/sign_out_usecase.dart';
import 'package:poozizic/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:poozizic/feature/auth/presentation/provider/auth_notifier.dart';
import 'package:poozizic/feature/auth/presentation/provider/auth_state.dart';

/// Remote DataSource Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(SupabaseConfig.client);
});

/// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

/// SignInUseCase Provider
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

/// SignUpUseCase Provider
final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

/// SignOutUseCase Provider
final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

/// GetCurrentUserUseCase Provider
final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

/// Auth Notifier Provider
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(signInUseCaseProvider),
    ref.watch(signUpUseCaseProvider),
    ref.watch(signOutUseCaseProvider),
    ref.watch(getCurrentUserUseCaseProvider),
  );
});
