import '../../../../shared/domain/failure/failure.dart';

/// 운동 기록 생성 실패
class CreateExerciseRecordFailure extends Failure {
  const CreateExerciseRecordFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 운동 기록 조회 실패
class GetExerciseRecordsFailure extends Failure {
  const GetExerciseRecordsFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}
