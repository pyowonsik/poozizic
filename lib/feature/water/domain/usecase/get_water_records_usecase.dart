import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/water_record_entity.dart';
import '../failure/water_failure.dart';
import '../repository/water_repository.dart';

/// 수분 기록 조회 UseCase
class GetWaterRecordsUseCase
    implements UseCase<List<WaterRecordEntity>, NoParams, WaterRepository> {
  const GetWaterRecordsUseCase(this.repository);

  final WaterRepository repository;

  @override
  WaterRepository get repo => repository;

  @override
  Future<Either<Failure, List<WaterRecordEntity>>> call(NoParams params) async {
    try {
      final records = await repository.getAllRecords();
      return Right(records);
    } on Exception catch (e) {
      return Left(
        GetWaterRecordsFailure('수분 기록을 조회할 수 없습니다.', exception: e),
      );
    }
  }
}
