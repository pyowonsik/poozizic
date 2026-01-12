import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/record/domain/entity/record_entity.dart';
import 'package:poozizic/feature/record/domain/failure/record_failure.dart';
import 'package:poozizic/feature/record/domain/repository/record_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 날짜별 기록 조회 UseCase
class GetRecordsByDateUseCase
    implements
        UseCase<List<RecordEntity>, GetRecordsByDateParams, RecordRepository> {
  /// 날짜별 기록 조회 UseCase 생성자
  /// [repository] 기록 리포지토리
  const GetRecordsByDateUseCase(this.repository);

  /// 기록 리포지토리
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
      return Left(GetRecordsFailure('해당 날짜의 기록을 불러올 수 없습니다.', exception: e));
    }
  }
}

/// 날짜별 기록 조회 파라미터
class GetRecordsByDateParams {
  /// 날짜별 기록 조회 파라미터 생성자
  /// [date] 날짜
  const GetRecordsByDateParams({required this.date});

  /// 날짜
  final DateTime date;
}
