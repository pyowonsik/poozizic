import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/settings_entity.dart';
import '../repository/settings_repository.dart';

class UpdateSettingsParams {
  final SettingsEntity settings;

  const UpdateSettingsParams({required this.settings});
}

class UpdateSettingsUseCase
    implements UseCase<SettingsEntity, UpdateSettingsParams, SettingsRepository> {
  UpdateSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  SettingsRepository get repo => _repository;

  @override
  Future<Either<Failure, SettingsEntity>> call(UpdateSettingsParams params) {
    return _repository.updateSettings(params.settings);
  }
}
