import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Supabase 설정 클래스
class SupabaseConfig {
  SupabaseConfig._();

  /// Supabase URL
  static String get url => dotenv.env['SUPABASE_URL'] ?? '';

  /// Supabase Anon Key
  static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  /// Supabase 초기화
  static Future<void> initialize() async {
    await dotenv.load();
    await Supabase.initialize(url: url, anonKey: anonKey);
  }

  /// Supabase 클라이언트
  static SupabaseClient get client => Supabase.instance.client;
}
