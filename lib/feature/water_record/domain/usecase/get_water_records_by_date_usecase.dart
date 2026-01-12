import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/water_record/domain/entity/water_record_entity.dart';
import 'package:poozizic/feature/water_record/domain/failure/water_record_failure.dart';
import 'package:poozizic/feature/water_record/domain/repository/water_record_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 특정 날짜 수분 기록 조회 UseCase
class GetWaterRecordsByDateUseCase
    extends UseCase<List<WaterRecordEntity>, DateTime, WaterRecordRepository> {
  /// 특정 날짜 수분 기록 조회 UseCase 생성자
  GetWaterRecordsByDateUseCase(this._repository);
  final WaterRecordRepository _repository;

  @override
  WaterRecordRepository get repo => _repository;

  @override
  Future<Either<Failure, List<WaterRecordEntity>>> call(DateTime date) async {
    try {
      final records = await _repository.getRecordsByDate(date);
      return Right(records);
    } catch (e) {
      return Left(
        GetWaterRecordsFailure(
          '수분 기록 조회에 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
