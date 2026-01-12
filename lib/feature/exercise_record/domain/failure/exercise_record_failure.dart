import '../../../../shared/domain/failure/failure.dart';

/// ExerciseRecord 관련 실패
class ExerciseRecordFailure extends Failure {
  const ExerciseRecordFailure(super.message,
      {super.exception, super.stackTrace});
}

/// 운동 기록 생성 실패
class CreateExerciseRecordFailure extends ExerciseRecordFailure {
  const CreateExerciseRecordFailure(super.message,
      {super.exception, super.stackTrace});
}

/// 운동 기록 조회 실패
class GetExerciseRecordsFailure extends ExerciseRecordFailure {
  const GetExerciseRecordsFailure(super.message,
      {super.exception, super.stackTrace});
}
