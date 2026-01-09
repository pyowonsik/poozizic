import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/record_entity.dart';
import '../failure/record_failure.dart';
import '../repository/record_repository.dart';

/// 기록 생성 UseCase
class CreateRecordUseCase
    implements UseCase<RecordEntity, CreateRecordParams, RecordRepository> {
  const CreateRecordUseCase(this.repository);

  final RecordRepository repository;

  @override
  RecordRepository get repo => repository;

  @override
  Future<Either<Failure, RecordEntity>> call(CreateRecordParams params) async {
    try {
      final record = RecordEntity(
        dateTime: DateTime.now(),
        bristolType: params.bristolType,
        feeling: params.feeling,
        durationMinutes: params.durationMinutes,
        memo: params.memo,
        createdAt: DateTime.now(),
      );
      final result = await repository.createRecord(record);
      return Right(result);
    } on Exception catch (e) {
      return Left(
        CreateRecordFailure('기록을 저장할 수 없습니다.', exception: e),
      );
    }
  }
}

/// 기록 생성 파라미터
class CreateRecordParams {
  const CreateRecordParams({
    required this.bristolType,
    required this.feeling,
    required this.durationMinutes,
    this.memo,
  });

  final int bristolType;
  final int feeling;
  final int durationMinutes;
  final String? memo;
}
