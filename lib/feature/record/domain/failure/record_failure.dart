import '../../../../shared/domain/failure/failure.dart';

/// 기록 생성 실패
class CreateRecordFailure extends Failure {
  const CreateRecordFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 기록 조회 실패
class GetRecordsFailure extends Failure {
  const GetRecordsFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 기록 삭제 실패
class DeleteRecordFailure extends Failure {
  const DeleteRecordFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}
