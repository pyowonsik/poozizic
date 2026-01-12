import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/water_record_entity.dart';
import '../failure/water_failure.dart';
import '../repository/water_repository.dart';

/// 수분 기록 생성 UseCase
class CreateWaterRecordUseCase
    implements UseCase<WaterRecordEntity, CreateWaterRecordParams, WaterRepository> {
  const CreateWaterRecordUseCase(this.repository);

  final WaterRepository repository;

  @override
  WaterRepository get repo => repository;

  @override
  Future<Either<Failure, WaterRecordEntity>> call(CreateWaterRecordParams params) async {
    try {
      final record = WaterRecordEntity(
        amount: params.amount,
        recordedAt: DateTime.now(),
      );
      final result = await repository.createRecord(record);
      return Right(result);
    } on Exception catch (e) {
      return Left(
        CreateWaterRecordFailure('수분 기록을 저장할 수 없습니다.', exception: e),
      );
    }
  }
}

/// 수분 기록 생성 파라미터
class CreateWaterRecordParams {
  const CreateWaterRecordParams({
    required this.amount,
  });

  final int amount;
}
