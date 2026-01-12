import 'package:dartz/dartz.dart';
import 'package:poozizic/core/network/network_info.dart';
import 'package:poozizic/feature/settings/data/datasource/settings_local_datasource.dart';
import 'package:poozizic/feature/settings/data/datasource/settings_remote_datasource.dart';
import 'package:poozizic/feature/settings/data/model/settings_model.dart';
import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';
import 'package:poozizic/feature/settings/domain/failure/settings_failure.dart';
import 'package:poozizic/feature/settings/domain/repository/settings_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';

/// Settings Repository 구현체
class SettingsRepositoryImpl implements SettingsRepository {
  /// Settings Repository 구현체 생성자
  SettingsRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._networkInfo,
  );

  final SettingsLocalDataSource _localDataSource;
  final SettingsRemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      // 네트워크 연결 시 원격에서 가져오기 시도
      if (await _networkInfo.isConnected) {
        try {
          final remoteSettings = await _remoteDataSource.getSettings();
          if (remoteSettings != null) {
            // 원격 설정을 로컬에 동기화
            await _localDataSource.saveSettings(remoteSettings);
            return Right(remoteSettings);
          }
        } catch (e) {
          // 원격 실패 시 로컬에서 가져오기
        }
      }

      // 로컬에서 가져오기
      final settings = await _localDataSource.getSettings();
      return Right(settings);
    } catch (e, st) {
      return Left(
        GetSettingsFailure(
          '설정을 불러오는데 실패했습니다',
          exception: e is Exception ? e : Exception(e.toString()),
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> updateSettings(
    SettingsEntity settings,
  ) async {
    try {
      // 로컬에 먼저 저장
      final updatedSettings = await _localDataSource.saveSettings(settings);

      // 네트워크 연결 시 원격에도 저장
      if (await _networkInfo.isConnected) {
        try {
          final model = SettingsModel.fromEntity(settings);
          await _remoteDataSource.saveSettings(model);
        } catch (e) {
          // 원격 저장 실패 시 무시 (로컬은 이미 저장됨)
        }
      }

      return Right(updatedSettings);
    } catch (e, st) {
      return Left(
        UpdateSettingsFailure(
          '설정을 저장하는데 실패했습니다',
          exception: e is Exception ? e : Exception(e.toString()),
          stackTrace: st,
        ),
      );
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> resetSettings() async {
    try {
      final defaultSettings = await _localDataSource.resetSettings();

      // 네트워크 연결 시 원격에도 초기화
      if (await _networkInfo.isConnected) {
        try {
          final model = SettingsModel.fromEntity(defaultSettings);
          await _remoteDataSource.saveSettings(model);
        } catch (e) {
          // 원격 초기화 실패 시 무시
        }
      }

      return Right(defaultSettings);
    } catch (e, st) {
      return Left(
        UpdateSettingsFailure(
          '설정을 초기화하는데 실패했습니다',
          exception: e is Exception ? e : Exception(e.toString()),
          stackTrace: st,
        ),
      );
    }
  }
}
