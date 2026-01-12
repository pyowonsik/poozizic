import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/settings/data/datasource/settings_local_datasource.dart';
import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';
import 'package:poozizic/feature/settings/domain/failure/settings_failure.dart';
import 'package:poozizic/feature/settings/domain/repository/settings_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';

/// Settings Repository 구현체
class SettingsRepositoryImpl implements SettingsRepository {
  /// Settings Repository 구현체 생성자
  SettingsRepositoryImpl(this._dataSource);

  final SettingsLocalDataSource _dataSource;

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final settings = await _dataSource.getSettings();
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
      final updatedSettings = await _dataSource.saveSettings(settings);
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
      final defaultSettings = await _dataSource.resetSettings();
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
