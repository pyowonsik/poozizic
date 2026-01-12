import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/meal_record/domain/usecase/create_meal_record_usecase.dart';
import 'package:poozizic/feature/meal_record/presentation/provider/meal_record_form_state.dart';

/// 식사 타입 정보
class MealType {
  /// 식사 타입 정보 생성자
  /// [emoji] 식사 타입 이모지
  /// [label] 식사 타입 라벨
  const MealType({required this.emoji, required this.label});

  /// 식사 타재 이모지
  final String emoji;

  /// 식사 타입 라벨
  final String label;
}

/// 식이섬유 레벨 정보
class FiberLevel {
  /// 식이섬유 레벨 정보 생성자
  /// [emoji] 식이섬유 레벨 이모지
  /// [label] 식이섬유 레벨 라벨
  const FiberLevel({required this.emoji, required this.label});

  /// 식이섬유 레벨 이모지
  final String emoji;

  /// 식이섬유 레벨 라벨
  final String label;
}

/// MealRecord 폼 Notifier
class MealRecordFormNotifier extends StateNotifier<MealRecordFormState> {
  /// MealRecord 폼 Notifier 생성자
  MealRecordFormNotifier(this._createMealRecordUseCase)
    : super(const MealRecordFormInProgress());

  /// 식사 기록 생성 UseCase
  final CreateMealRecordUseCase _createMealRecordUseCase;

  /// 식사 타입 목록
  static const List<MealType> mealTypes = [
    MealType(emoji: '🌅', label: '아침'),
    MealType(emoji: '☀️', label: '점심'),
    MealType(emoji: '🍌', label: '저녁'),
    MealType(emoji: '🍪', label: '간식'),
  ];

  /// 식이섬유 레벨 목록
  static const List<FiberLevel> fiberLevels = [
    FiberLevel(emoji: '🥬', label: '많음'),
    FiberLevel(emoji: '🍽️', label: '보통'),
    FiberLevel(emoji: '🥩', label: '적음'),
  ];

  /// 식사 타입 선택
  void selectMealType(int type) {
    final currentState = state;
    if (currentState is MealRecordFormInProgress) {
      state = currentState.copyWith(selectedMealType: type);
    }
  }

  /// 음식 추가
  void addFood(String food) {
    final currentState = state;
    if (currentState is MealRecordFormInProgress) {
      final trimmedFood = food.trim();
      if (trimmedFood.isNotEmpty && !currentState.foods.contains(trimmedFood)) {
        state = currentState.copyWith(
          foods: [...currentState.foods, trimmedFood],
        );
      }
    }
  }

  /// 음식 제거
  void removeFood(String food) {
    final currentState = state;
    if (currentState is MealRecordFormInProgress) {
      state = currentState.copyWith(
        foods: currentState.foods.where((f) => f != food).toList(),
      );
    }
  }

  /// 식이섬유 레벨 선택
  void selectFiber(int level) {
    final currentState = state;
    if (currentState is MealRecordFormInProgress) {
      state = currentState.copyWith(selectedFiber: level);
    }
  }

  /// 제출
  Future<void> submit() async {
    final currentState = state;
    if (currentState is! MealRecordFormInProgress) return;
    if (!currentState.canSubmit) return;

    state = MealRecordFormSubmitting(
      selectedMealType: currentState.selectedMealType,
      foods: currentState.foods,
      selectedFiber: currentState.selectedFiber!,
    );

    final result = await _createMealRecordUseCase(
      CreateMealRecordParams(
        mealType: currentState.selectedMealType,
        foods: currentState.foods,
        fiberLevel: currentState.selectedFiber!,
      ),
    );

    result.fold(
      (failure) {
        state = MealRecordFormError(
          message: failure.message,
          selectedMealType: currentState.selectedMealType,
          foods: currentState.foods,
          selectedFiber: currentState.selectedFiber,
        );
      },
      (record) {
        state = MealRecordFormSuccess(record: record);
      },
    );
  }

  /// 에러에서 복구
  void clearError() {
    final currentState = state;
    if (currentState is MealRecordFormError) {
      state = MealRecordFormInProgress(
        selectedMealType: currentState.selectedMealType,
        foods: currentState.foods,
        selectedFiber: currentState.selectedFiber,
      );
    }
  }
}
