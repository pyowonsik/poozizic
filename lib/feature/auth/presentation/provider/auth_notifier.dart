import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/auth/domain/usecase/get_current_user_usecase.dart';
import 'package:poozizic/feature/auth/domain/usecase/sign_in_usecase.dart';
import 'package:poozizic/feature/auth/domain/usecase/sign_out_usecase.dart';
import 'package:poozizic/feature/auth/domain/usecase/sign_up_usecase.dart';
import 'package:poozizic/feature/auth/presentation/provider/auth_state.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 인증 Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  /// 인증 Notifier 생성자
  AuthNotifier(
    this._signInUseCase,
    this._signUpUseCase,
    this._signOutUseCase,
    this._getCurrentUserUseCase,
  ) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  /// 인증 상태 확인
  Future<void> _checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _getCurrentUserUseCase(const NoParams());

    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.unauthenticated),
      (user) {
        if (user != null) {
          state = state.copyWith(status: AuthStatus.authenticated, user: user);
        } else {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        }
      },
    );
  }

  /// 로그인
  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _signInUseCase(
      SignInParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  /// 회원가입
  Future<void> signUp(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _signUpUseCase(
      SignUpParams(email: email, password: password),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  /// 로그아웃
  Future<void> signOut() async {
    await _signOutUseCase(const NoParams());
    state = AuthState.initial().copyWith(status: AuthStatus.unauthenticated);
  }
}
