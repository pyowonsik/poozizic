import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/record/domain/entity/record_entity.dart';
import 'package:poozizic/feature/record/domain/failure/record_failure.dart';
import 'package:poozizic/feature/record/domain/repository/record_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 전체 기록 조회 UseCase
class GetRecordsUseCase
    implements UseCase<List<RecordEntity>, NoParams, RecordRepository> {
  /// 전체 기록 조회 UseCase 생성자
  /// [repository] 기록 리포지토리
  const GetRecordsUseCase(this.repository);

  /// 기록 리포지토리
  final RecordRepository repository;

  @override
  RecordRepository get repo => repository;

  @override
  Future<Either<Failure, List<RecordEntity>>> call(NoParams params) async {
    try {
      final result = await repository.getAllRecords();
      return Right(result);
    } on Exception catch (e) {
      return Left(GetRecordsFailure('기록을 불러올 수 없습니다.', exception: e));
    }
  }
}
