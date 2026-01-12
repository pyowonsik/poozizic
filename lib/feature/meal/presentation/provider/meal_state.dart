/// 식사 기록 상태
sealed class MealState {
  const MealState();
}

/// 초기 상태
class MealInitial extends MealState {
  const MealInitial({
    this.selectedMealType = 0,
    this.foods = const [],
    this.selectedFiber,
  });

  final int selectedMealType;
  final List<String> foods;
  final int? selectedFiber;
}

/// 진행 중 상태
class MealInProgress extends MealState {
  const MealInProgress({
    required this.selectedMealType,
    required this.foods,
    required this.selectedFiber,
  });

  final int selectedMealType;
  final List<String> foods;
  final int? selectedFiber;
}

/// 제출 중 상태
class MealSubmitting extends MealState {
  const MealSubmitting();
}

/// 성공 상태
class MealSuccess extends MealState {
  const MealSuccess();
}

/// 에러 상태
class MealError extends MealState {
  const MealError({
    required this.message,
  });

  final String message;
}
