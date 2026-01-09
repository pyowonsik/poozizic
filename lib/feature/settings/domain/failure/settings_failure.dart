import '../../../../shared/domain/failure/failure.dart';

/// Settings 조회 실패
class GetSettingsFailure extends Failure {
  const GetSettingsFailure(super.message, {super.exception, super.stackTrace});
}

/// Settings 업데이트 실패
class UpdateSettingsFailure extends Failure {
  const UpdateSettingsFailure(super.message, {super.exception, super.stackTrace});
}
