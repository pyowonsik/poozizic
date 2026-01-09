import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/record_entity.dart';
import '../failure/record_failure.dart';
import '../repository/record_repository.dart';

/// 전체 기록 조회 UseCase
class GetRecordsUseCase
    implements UseCase<List<RecordEntity>, NoParams, RecordRepository> {
  const GetRecordsUseCase(this.repository);

  final RecordRepository repository;

  @override
  RecordRepository get repo => repository;

  @override
  Future<Either<Failure, List<RecordEntity>>> call(NoParams params) async {
    try {
      final result = await repository.getAllRecords();
      return Right(result);
    } on Exception catch (e) {
      return Left(
        GetRecordsFailure('기록을 불러올 수 없습니다.', exception: e),
      );
    }
  }
}
