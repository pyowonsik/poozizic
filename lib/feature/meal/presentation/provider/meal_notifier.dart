import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/create_meal_record_usecase.dart';
import 'meal_state.dart';

/// 식사 기록 Notifier
class MealNotifier extends StateNotifier<MealState> {
  MealNotifier(this._createMealRecordUseCase)
      : super(const MealInitial());

  final CreateMealRecordUseCase _createMealRecordUseCase;

  /// 식사 구분 선택
  void selectMealType(int mealType) {
    final currentState = state;
    if (currentState is MealInitial) {
      state = MealInProgress(
        selectedMealType: mealType,
        foods: currentState.foods,
        selectedFiber: currentState.selectedFiber,
      );
    } else if (currentState is MealInProgress) {
      state = MealInProgress(
        selectedMealType: mealType,
        foods: currentState.foods,
        selectedFiber: currentState.selectedFiber,
      );
    }
  }

  /// 음식 추가
  void addFood(String food) {
    final currentState = state;
    List<String> currentFoods;
    int currentMealType;
    int? currentFiber;

    if (currentState is MealInitial) {
      currentFoods = currentState.foods;
      currentMealType = currentState.selectedMealType;
      currentFiber = currentState.selectedFiber;
    } else if (currentState is MealInProgress) {
      currentFoods = currentState.foods;
      currentMealType = currentState.selectedMealType;
      currentFiber = currentState.selectedFiber;
    } else {
      return;
    }

    state = MealInProgress(
      selectedMealType: currentMealType,
      foods: [...currentFoods, food],
      selectedFiber: currentFiber,
    );
  }

  /// 음식 제거
  void removeFood(String food) {
    final currentState = state;
    List<String> currentFoods;
    int currentMealType;
    int? currentFiber;

    if (currentState is MealInitial) {
      currentFoods = currentState.foods;
      currentMealType = currentState.selectedMealType;
      currentFiber = currentState.selectedFiber;
    } else if (currentState is MealInProgress) {
      currentFoods = currentState.foods;
      currentMealType = currentState.selectedMealType;
      currentFiber = currentState.selectedFiber;
    } else {
      return;
    }

    state = MealInProgress(
      selectedMealType: currentMealType,
      foods: currentFoods.where((f) => f != food).toList(),
      selectedFiber: currentFiber,
    );
  }

  /// 식이섬유 함량 선택
  void selectFiber(int fiber) {
    final currentState = state;
    List<String> currentFoods;
    int currentMealType;

    if (currentState is MealInitial) {
      currentFoods = currentState.foods;
      currentMealType = currentState.selectedMealType;
    } else if (currentState is MealInProgress) {
      currentFoods = currentState.foods;
      currentMealType = currentState.selectedMealType;
    } else {
      return;
    }

    state = MealInProgress(
      selectedMealType: currentMealType,
      foods: currentFoods,
      selectedFiber: fiber,
    );
  }

  /// 기록 제출
  Future<void> submitRecord() async {
    final currentState = state;
    int mealType;
    List<String> foods;
    int? fiberLevel;

    if (currentState is MealInProgress) {
      mealType = currentState.selectedMealType;
      foods = currentState.foods;
      fiberLevel = currentState.selectedFiber;
    } else if (currentState is MealInitial) {
      mealType = currentState.selectedMealType;
      foods = currentState.foods;
      fiberLevel = currentState.selectedFiber;
    } else {
      return;
    }

    // 검증
    if (foods.isEmpty || fiberLevel == null) {
      state = const MealError(message: '모든 항목을 입력해주세요.');
      return;
    }

    state = const MealSubmitting();

    final result = await _createMealRecordUseCase(
      CreateMealRecordParams(
        mealType: mealType,
        foods: foods,
        fiberLevel: fiberLevel,
      ),
    );

    result.fold(
      (failure) => state = MealError(message: failure.message),
      (_) => state = const MealSuccess(),
    );
  }
}
