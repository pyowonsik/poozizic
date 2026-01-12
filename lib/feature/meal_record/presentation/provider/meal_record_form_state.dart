import 'package:poozizic/feature/meal_record/domain/entity/meal_record_entity.dart';

/// MealRecord 폼 상태 (Sealed Class)
sealed class MealRecordFormState {
  const MealRecordFormState();
}

/// 입력 진행 중 상태
class MealRecordFormInProgress extends MealRecordFormState {
  /// 입력 진행 중 상태 생성자
  /// [selectedMealType] 선택된 식사 타입
  /// [foods] 선택된 음식 목록
  /// [selectedFiber] 선택된 식이섬유 레벨
  const MealRecordFormInProgress({
    this.selectedMealType = 0,
    this.foods = const [],
    this.selectedFiber,
  });

  /// 선택된 식사 타입
  final int selectedMealType;

  /// 선택된 음식 목록
  final List<String> foods;

  /// 선택된 식이섬유 레벨
  final int? selectedFiber;

  /// 제출 가능 여부
  bool get canSubmit => foods.isNotEmpty && selectedFiber != null;

  /// 입력 진행 중 상태 복사
  /// [selectedMealType] 선택된 식사 타입
  /// [foods] 선택된 음식 목록
  /// [selectedFiber] 선택된 식이섬유 레벨
  /// [clearFiber] 식이섬유 레벨 초기화 여부
  MealRecordFormInProgress copyWith({
    int? selectedMealType,
    List<String>? foods,
    int? selectedFiber,
    bool clearFiber = false,
  }) {
    return MealRecordFormInProgress(
      selectedMealType: selectedMealType ?? this.selectedMealType,
      foods: foods ?? this.foods,
      selectedFiber: clearFiber ? null : (selectedFiber ?? this.selectedFiber),
    );
  }
}

/// 제출 중 상태
class MealRecordFormSubmitting extends MealRecordFormState {
  /// 제출 중 상태 생성자
  /// [selectedMealType] 선택된 식사 타입
  /// [foods] 선택된 음식 목록
  /// [selectedFiber] 선택된 식이섬유 레벨
  const MealRecordFormSubmitting({
    required this.selectedMealType,
    required this.foods,
    required this.selectedFiber,
  });

  /// 선택된 식사 타입
  final int selectedMealType;

  /// 선택된 음식 목록
  final List<String> foods;

  /// 선택된 식이섬유 레벨
  final int selectedFiber;
}

/// 성공 상태
class MealRecordFormSuccess extends MealRecordFormState {
  /// 성공 상태 생성자
  /// [record] 식사 기록 엔티티
  const MealRecordFormSuccess({required this.record});

  /// 식사 기록 엔티티
  final MealRecordEntity record;
}

/// 에러 상태
class MealRecordFormError extends MealRecordFormState {
  /// 에러 상태 생성자
  /// [message] 에러 메시지
  /// [selectedMealType] 선택된 식사 타입
  /// [foods] 선택된 음식 목록
  /// [selectedFiber] 선택된 식이섬유 레벨
  const MealRecordFormError({
    required this.message,
    required this.selectedMealType,
    required this.foods,
    this.selectedFiber,
  });

  /// 에러 메시지
  final String message;

  /// 선택된 식사 타입
  final int selectedMealType;

  /// 선택된 음식 목록
  final List<String> foods;

  /// 선택된 식이섬유 레벨
  final int? selectedFiber;
}
