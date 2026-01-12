import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/meal_providers.dart';
import '../provider/provider.dart';
import '../widget/widget.dart';
import '../../../../shared/widget/pz_loading_view.dart';
import '../../../../shared/widget/pz_snackbar.dart';

/// 식사 기록 페이지 (Clean Architecture)
class MealRecordPage extends ConsumerStatefulWidget {
  const MealRecordPage({super.key});

  @override
  ConsumerState<MealRecordPage> createState() => _MealRecordPageState();
}

class _MealRecordPageState extends ConsumerState<MealRecordPage> {
  final TextEditingController _foodController = TextEditingController();

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mealNotifierProvider);
    final notifier = ref.read(mealNotifierProvider.notifier);

    // 성공 시 처리
    ref.listen<MealState>(mealNotifierProvider, (previous, next) {
      if (next is MealSuccess) {
        Navigator.pop(context);
        PzSnackBar.showSuccess(context, '식사 기록이 완료되었습니다');
      } else if (next is MealError) {
        PzSnackBar.showError(context, next.message);
      }
    });

    // 현재 상태 가져오기
    int currentMealType;
    List<String> currentFoods;
    int? currentFiber;

    if (state is MealInProgress) {
      currentMealType = state.selectedMealType;
      currentFoods = state.foods;
      currentFiber = state.selectedFiber;
    } else if (state is MealInitial) {
      currentMealType = state.selectedMealType;
      currentFoods = state.foods;
      currentFiber = state.selectedFiber;
    } else {
      currentMealType = 0;
      currentFoods = [];
      currentFiber = null;
    }

    final isSubmitting = state is MealSubmitting;
    final canSubmit = currentFoods.isNotEmpty && currentFiber != null;

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
      body: isSubmitting
          ? const PzLoadingView()
          : SingleChildScrollView(
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
                      selectedMealType: currentMealType,
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
                    FoodInputField(
                      controller: _foodController,
                      onSubmitted: () => _addFood(notifier),
                      onAddPressed: () => _addFood(notifier),
                    ),
                    const SizedBox(height: 16),
                    FoodTagList(
                      foods: currentFoods,
                      onRemove: notifier.removeFood,
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
                      selectedFiber: currentFiber,
                      onFiberSelected: notifier.selectFiber,
                    ),

                    const SizedBox(height: 40),

                    // 기록 완료 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canSubmit ? () => notifier.submitRecord() : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E35B1),
                          disabledBackgroundColor: const Color(0xFFE0E0E0),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
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

  void _addFood(MealNotifier notifier) {
    final food = _foodController.text.trim();
    if (food.isNotEmpty) {
      notifier.addFood(food);
      _foodController.clear();
    }
  }
}
