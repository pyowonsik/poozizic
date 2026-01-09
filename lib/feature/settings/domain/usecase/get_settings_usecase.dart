import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/settings_entity.dart';
import '../repository/settings_repository.dart';

class GetSettingsUseCase
    implements UseCase<SettingsEntity, NoParams, SettingsRepository> {
  GetSettingsUseCase(this._repository);

  final SettingsRepository _repository;

  @override
  SettingsRepository get repo => _repository;

  @override
  Future<Either<Failure, SettingsEntity>> call(NoParams params) {
    return _repository.getSettings();
  }
}
