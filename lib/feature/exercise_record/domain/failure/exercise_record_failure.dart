import 'package:poozizic/shared/domain/failure/failure.dart';

/// ExerciseRecord 관련 실패
class ExerciseRecordFailure extends Failure {
  /// ExerciseRecord 관련 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const ExerciseRecordFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 운동 기록 생성 실패
class CreateExerciseRecordFailure extends ExerciseRecordFailure {
  /// 운동 기록 생성 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const CreateExerciseRecordFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}

/// 운동 기록 조회 실패
class GetExerciseRecordsFailure extends ExerciseRecordFailure {
  /// 운동 기록 조회 실패 생성자
  /// [message] 실패 메시지
  /// [exception] 실패 예외
  /// [stackTrace] 실패 스택 트레이스
  const GetExerciseRecordsFailure(
    super.message, {
    super.exception,
    super.stackTrace,
  });
}
