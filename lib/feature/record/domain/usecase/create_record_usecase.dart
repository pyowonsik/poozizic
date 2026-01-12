import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:poozizic/feature/record/domain/entity/record_entity.dart';
import 'package:poozizic/feature/record/domain/failure/record_failure.dart';
import 'package:poozizic/feature/record/domain/repository/record_repository.dart';
import 'package:poozizic/shared/domain/failure/failure.dart';
import 'package:poozizic/shared/domain/usecase/usecase.dart';

/// 기록 생성 UseCase
class CreateRecordUseCase
    implements UseCase<RecordEntity, CreateRecordParams, RecordRepository> {
  /// 기록 생성 UseCase 생성자
  /// [repository] 기록 리포지토리
  const CreateRecordUseCase(this.repository);

  /// 기록 리포지토리
  final RecordRepository repository;

  @override
  RecordRepository get repo => repository;

  @override
  Future<Either<Failure, RecordEntity>> call(CreateRecordParams params) async {
    log('[CreateRecordUseCase] 호출됨');
    log('[CreateRecordUseCase] params: bristolType=${params.bristolType}, '
        'feeling=${params.feeling}, duration=${params.durationMinutes}');

    try {
      final record = RecordEntity(
        dateTime: DateTime.now(),
        bristolType: params.bristolType,
        feeling: params.feeling,
        durationMinutes: params.durationMinutes,
        memo: params.memo,
        createdAt: DateTime.now(),
      );
      log('[CreateRecordUseCase] RecordEntity 생성 완료');

      final result = await repository.createRecord(record);
      log('[CreateRecordUseCase] 저장 성공! id=${result.id}');
      return Right(result);
    } on Exception catch (e, stackTrace) {
      log('[CreateRecordUseCase] ERROR: $e');
      log('[CreateRecordUseCase] StackTrace: $stackTrace');
      return Left(CreateRecordFailure('기록을 저장할 수 없습니다.', exception: e));
    }
  }
}

/// 기록 생성 파라미터
class CreateRecordParams {
  /// 기록 생성 파라미터 생성자
  /// [bristolType] 브리스톨 타입
  /// [feeling] 기분
  /// [durationMinutes] 지속 시간
  /// [memo] 메모
  const CreateRecordParams({
    required this.bristolType,
    required this.feeling,
    required this.durationMinutes,
    this.memo,
  });

  /// 브리스톨 타입
  final int bristolType;

  /// 기분
  final int feeling;

  /// 지속 시간
  final int durationMinutes;

  /// 메모
  final String? memo;
}
