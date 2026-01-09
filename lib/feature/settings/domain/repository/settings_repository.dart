import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../entity/settings_entity.dart';

/// Settings Repository Interface
abstract class SettingsRepository {
  /// 현재 설정 조회
  Future<Either<Failure, SettingsEntity>> getSettings();

  /// 설정 업데이트
  Future<Either<Failure, SettingsEntity>> updateSettings(SettingsEntity settings);

  /// 설정 초기화
  Future<Either<Failure, SettingsEntity>> resetSettings();
}
