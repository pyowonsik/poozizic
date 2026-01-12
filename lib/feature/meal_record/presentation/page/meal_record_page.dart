import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/meal_record_providers.dart';
import '../provider/meal_record_form_state.dart';
import '../widget/meal_type_selector.dart';
import '../widget/food_input_section.dart';
import '../widget/fiber_level_selector.dart';
import '../../../home/di/home_providers.dart';
import '../../../analytics/di/analytics_providers.dart';

/// 식사 기록 페이지
class MealRecordPage extends ConsumerStatefulWidget {
  const MealRecordPage({super.key});

  @override
  ConsumerState<MealRecordPage> createState() => _MealRecordPageState();
}

class _MealRecordPageState extends ConsumerState<MealRecordPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mealRecordFormNotifierProvider);
    final notifier = ref.read(mealRecordFormNotifierProvider.notifier);

    // 성공 시 화면 닫기
    ref.listen<MealRecordFormState>(mealRecordFormNotifierProvider,
        (previous, next) {
      if (next is MealRecordFormSuccess) {
        // Home, Analytics 화면 갱신
        refreshHome(ref);
        refreshAnalytics(ref);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('식사 기록이 완료되었습니다'),
            backgroundColor: Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
          ),
        );
      } else if (next is MealRecordFormError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        notifier.clearError();
      }
    });

    // 현재 상태값 추출
    int selectedMealType = 0;
    List<String> foods = [];
    int? selectedFiber;
    bool canSubmit = false;
    bool isSubmitting = false;

    if (state is MealRecordFormInProgress) {
      selectedMealType = state.selectedMealType;
      foods = state.foods;
      selectedFiber = state.selectedFiber;
      canSubmit = state.canSubmit;
    } else if (state is MealRecordFormSubmitting) {
      selectedMealType = state.selectedMealType;
      foods = state.foods;
      selectedFiber = state.selectedFiber;
      isSubmitting = true;
    } else if (state is MealRecordFormError) {
      selectedMealType = state.selectedMealType;
      foods = state.foods;
      selectedFiber = state.selectedFiber;
      canSubmit = foods.isNotEmpty && selectedFiber != null;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('🍽️', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '식사 기록',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 식사 구분
              const Text(
                '식사 구분',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 16),
              MealTypeSelector(
                selectedMealType: selectedMealType,
                onMealTypeSelected: notifier.selectMealType,
              ),

              const SizedBox(height: 32),

              // 먹은 음식
              const Text(
                '먹은 음식',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 16),
              FoodInputSection(
                foods: foods,
                onFoodAdded: notifier.addFood,
                onFoodRemoved: notifier.removeFood,
              ),

              const SizedBox(height: 32),

              // 식이섬유 함량
              const Text(
                '식이섬유 함량',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 16),
              FiberLevelSelector(
                selectedFiber: selectedFiber,
                onFiberSelected: notifier.selectFiber,
              ),

              const SizedBox(height: 40),

              // 기록 완료 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : (canSubmit ? notifier.submit : null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E35B1),
                    disabledBackgroundColor: const Color(0xFFE0E0E0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              '기록 완료',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
