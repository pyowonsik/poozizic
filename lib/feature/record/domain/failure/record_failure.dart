import 'package:poozizic/shared/domain/failure/failure.dart';

/// 기록 생성 실패
class CreateRecordFailure extends Failure {
  /// 기록 생성 실패 생성자
  const CreateRecordFailure(super.message, {super.exception, super.stackTrace});
}

/// 기록 조회 실패
class GetRecordsFailure extends Failure {
  /// 기록 조회 실패 생성자
  const GetRecordsFailure(super.message, {super.exception, super.stackTrace});
}

/// 기록 삭제 실패
class DeleteRecordFailure extends Failure {
  /// 기록 삭제 실패 생성자
  const DeleteRecordFailure(super.message, {super.exception, super.stackTrace});
}
