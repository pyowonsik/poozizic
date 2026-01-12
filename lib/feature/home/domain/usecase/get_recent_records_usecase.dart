import 'package:dartz/dartz.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../entity/recent_record_entity.dart';
import '../failure/home_failure.dart';
import '../repository/home_repository.dart';

/// 최근 기록 조회 UseCase
class GetRecentRecordsUseCase
    extends UseCase<List<RecentRecordEntity>, DateTime, HomeRepository> {
  final HomeRepository _repository;

  GetRecentRecordsUseCase(this._repository);

  @override
  HomeRepository get repo => _repository;

  @override
  Future<Either<Failure, List<RecentRecordEntity>>> call(DateTime date) async {
    try {
      final records = await _repository.getRecentRecords(date);
      return Right(records);
    } catch (e) {
      return Left(GetRecentRecordsFailure(
        '최근 기록을 불러오는데 실패했습니다',
        exception: e is Exception ? e : null,
      ));
    }
  }
}
