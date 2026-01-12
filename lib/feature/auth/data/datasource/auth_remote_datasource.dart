import 'package:poozizic/core/error/supabase_exception.dart';
import 'package:poozizic/feature/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// 인증 원격 데이터 소스
class AuthRemoteDataSource {
  /// 인증 원격 데이터 소스 생성자
  AuthRemoteDataSource(this._client);

  final SupabaseClient _client;

  /// 로그인
  Future<UserModel> signIn(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AppAuthException('로그인에 실패했습니다.');
      }

      return UserModel(
        id: user.id,
        email: user.email ?? '',
        createdAt: DateTime.parse(user.createdAt),
      );
    } on AuthException catch (e) {
      throw AppAuthException(e.message, code: e.code);
    }
  }

  /// 회원가입
  Future<UserModel> signUp(String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AppAuthException('회원가입에 실패했습니다.');
      }

      return UserModel(
        id: user.id,
        email: user.email ?? '',
        createdAt: DateTime.parse(user.createdAt),
      );
    } on AuthException catch (e) {
      throw AppAuthException(e.message, code: e.code);
    }
  }

  /// 로그아웃
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (e) {
      throw AppAuthException(e.message, code: e.code);
    }
  }

  /// 현재 사용자 조회
  UserModel? getCurrentUser() {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    return UserModel(
      id: user.id,
      email: user.email ?? '',
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  /// 인증 상태 변경 스트림
  Stream<UserModel?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((state) {
      final user = state.session?.user;
      if (user == null) return null;

      return UserModel(
        id: user.id,
        email: user.email ?? '',
        createdAt: DateTime.parse(user.createdAt),
      );
    });
  }
}
