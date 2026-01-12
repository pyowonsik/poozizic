import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/water_record/domain/entity/water_record_entity.dart';
import 'package:poozizic/feature/water_record/domain/failure/water_record_failure.dart';
import 'package:poozizic/feature/water_record/domain/repository/water_record_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 수분 기록 생성 파라미터
class CreateWaterRecordParams {
  /// 수분 기록 생성 파라미터 생성자
  const CreateWaterRecordParams({
    required this.amountMl,
    this.presetType,
    this.dateTime,
  });

  /// 수분 섭취량
  final int amountMl;

  /// 수분 섭취 프리셋 타입
  final String? presetType;

  /// 수분 섭취 날짜
  final DateTime? dateTime;
}

/// 수분 기록 생성 UseCase
class CreateWaterRecordUseCase
    extends
        UseCase<
          WaterRecordEntity,
          CreateWaterRecordParams,
          WaterRecordRepository
        > {
  /// 수분 기록 생성 UseCase 생성자
  CreateWaterRecordUseCase(this._repository);

  /// 수분 기록 생성 UseCase 생성자
  final WaterRecordRepository _repository;

  @override
  WaterRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, WaterRecordEntity>> call(
    CreateWaterRecordParams params,
  ) async {
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
      return Left(
        CreateWaterRecordFailure(
          '수분 기록 생성에 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
