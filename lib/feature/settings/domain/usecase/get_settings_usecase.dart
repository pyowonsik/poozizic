import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/settings/domain/entity/settings_entity.dart';
import 'package:poozizic/feature/settings/domain/repository/settings_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 설정 조회 UseCase
class GetSettingsUseCase
    implements UseCase<SettingsEntity, NoParams, SettingsRepository> {
  /// 설정 조회 UseCase 생성자
  GetSettingsUseCase(this._repository);

  /// 설정 리포지토리

  final SettingsRepository _repository;

  @override
  SettingsRepository get repo => _repository;

  @override
  Future<Either<Failure, SettingsEntity>> call(NoParams params) {
    return _repository.getSettings();
  }
}
