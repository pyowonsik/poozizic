import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/home/domain/entity/recent_record_entity.dart';
import 'package:poozizic/feature/home/domain/failure/home_failure.dart';
import 'package:poozizic/feature/home/domain/repository/home_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 최근 기록 조회 UseCase
class GetRecentRecordsUseCase
    extends UseCase<List<RecentRecordEntity>, DateTime, HomeRepository> {
  /// 최근 기록 조회 UseCase 생성자
  GetRecentRecordsUseCase(this._repository);

  /// 최근 기록 조회 UseCase 레포지토리
  final HomeRepository _repository;

  @override
  HomeRepository get repo => _repository;

  @override
  Future<Either<Failure, List<RecentRecordEntity>>> call(DateTime date) async {
    try {
      final records = await _repository.getRecentRecords(date);
      return Right(records);
    } catch (e) {
      return Left(
        GetRecentRecordsFailure(
          '최근 기록을 불러오는데 실패했습니다',
          exception: e is Exception ? e : null,
        ),
      );
    }
  }
}
