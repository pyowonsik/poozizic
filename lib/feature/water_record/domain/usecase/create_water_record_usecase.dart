import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/water_record_entity.dart';
import '../failure/water_record_failure.dart';
import '../repository/water_record_repository.dart';

/// 수분 기록 생성 파라미터
class CreateWaterRecordParams {
  final int amountMl;
  final String? presetType;
  final DateTime? dateTime;

  const CreateWaterRecordParams({
    required this.amountMl,
    this.presetType,
    this.dateTime,
  });
}

/// 수분 기록 생성 UseCase
class CreateWaterRecordUseCase
    extends UseCase<WaterRecordEntity, CreateWaterRecordParams, WaterRecordRepository> {
  final WaterRecordRepository _repository;

  CreateWaterRecordUseCase(this._repository);

  @override
  WaterRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, WaterRecordEntity>> call(
      CreateWaterRecordParams params) async {
    try {
      final now = DateTime.now();
      final record = WaterRecordEntity(
        dateTime: params.dateTime ?? now,
        amountMl: params.amountMl,
        presetType: params.presetType,
        createdAt: now,
      );
      final created = await _repository.createRecord(record);
      return Right(created);
    } catch (e) {
      return Left(CreateWaterRecordFailure(
        '수분 기록 생성에 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
