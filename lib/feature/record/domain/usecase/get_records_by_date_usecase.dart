import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/record_entity.dart';
import '../failure/record_failure.dart';
import '../repository/record_repository.dart';

/// 날짜별 기록 조회 UseCase
class GetRecordsByDateUseCase
    implements
        UseCase<List<RecordEntity>, GetRecordsByDateParams, RecordRepository> {
  const GetRecordsByDateUseCase(this.repository);

  final RecordRepository repository;

  @override
  RecordRepository get repo => repository;

  @override
  Future<Either<Failure, List<RecordEntity>>> call(
    GetRecordsByDateParams params,
  ) async {
    try {
      final result = await repository.getRecordsByDate(params.date);
      return Right(result);
    } on Exception catch (e) {
      return Left(
        GetRecordsFailure('해당 날짜의 기록을 불러올 수 없습니다.', exception: e),
      );
    }
  }
}

/// 날짜별 기록 조회 파라미터
class GetRecordsByDateParams {
  const GetRecordsByDateParams({required this.date});

  final DateTime date;
}
