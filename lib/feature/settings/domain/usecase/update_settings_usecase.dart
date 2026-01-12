import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';
import 'package:poozizic/feature/settings/domain/repository/settings_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 설정 업데이트 파라미터
class UpdateSettingsParams {
  /// 설정 업데이트 파라미터 생성자
  const UpdateSettingsParams({required this.settings});

  /// 설정 엔티티
  final SettingsEntity settings;
}

/// 설정 업데이트 UseCase
class UpdateSettingsUseCase
    implements
        UseCase<SettingsEntity, UpdateSettingsParams, SettingsRepository> {
  /// 설정 업데이트 UseCase 생성자
  const UpdateSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  SettingsRepository get repo => _repository;

  @override
  Future<Either<Failure, SettingsEntity>> call(UpdateSettingsParams params) {
    return _repository.updateSettings(params.settings);
  }
}
