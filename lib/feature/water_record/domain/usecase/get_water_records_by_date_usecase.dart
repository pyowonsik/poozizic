import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/water_record_entity.dart';
import '../failure/water_record_failure.dart';
import '../repository/water_record_repository.dart';

/// 특정 날짜 수분 기록 조회 UseCase
class GetWaterRecordsByDateUseCase
    extends UseCase<List<WaterRecordEntity>, DateTime, WaterRecordRepository> {
  final WaterRecordRepository _repository;

  GetWaterRecordsByDateUseCase(this._repository);

  @override
  WaterRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, List<WaterRecordEntity>>> call(DateTime date) async {
    try {
      final records = await _repository.getRecordsByDate(date);
      return Right(records);
    } catch (e) {
      return Left(GetWaterRecordsFailure(
        '수분 기록 조회에 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
