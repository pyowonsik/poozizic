import '../../domain/entity/meal_record_entity.dart';

/// MealRecord 폼 상태 (Sealed Class)
sealed class MealRecordFormState {
  const MealRecordFormState();
}

/// 입력 진행 중 상태
class MealRecordFormInProgress extends MealRecordFormState {
  final int selectedMealType;
  final List<String> foods;
  final int? selectedFiber;

  const MealRecordFormInProgress({
    this.selectedMealType = 0,
    this.foods = const [],
    this.selectedFiber,
  });

  bool get canSubmit => foods.isNotEmpty && selectedFiber != null;

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
  final int selectedMealType;
  final List<String> foods;
  final int selectedFiber;

  const MealRecordFormSubmitting({
    required this.selectedMealType,
    required this.foods,
    required this.selectedFiber,
  });
}

/// 성공 상태
class MealRecordFormSuccess extends MealRecordFormState {
  final MealRecordEntity record;

  const MealRecordFormSuccess({required this.record});
}

/// 에러 상태
class MealRecordFormError extends MealRecordFormState {
  final String message;
  final int selectedMealType;
  final List<String> foods;
  final int? selectedFiber;

  const MealRecordFormError({
    required this.message,
    required this.selectedMealType,
    required this.foods,
    this.selectedFiber,
  });
}
