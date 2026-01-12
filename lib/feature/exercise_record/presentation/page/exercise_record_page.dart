import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/exercise_record_providers.dart';
import '../provider/exercise_record_form_state.dart';
import '../widget/exercise_type_grid.dart';
import '../widget/duration_slider.dart';
import '../widget/intensity_selector.dart';
import '../../../home/di/home_providers.dart';
import '../../../analytics/di/analytics_providers.dart';

/// 운동 기록 페이지
class ExerciseRecordPage extends ConsumerStatefulWidget {
  const ExerciseRecordPage({super.key});

  @override
  ConsumerState<ExerciseRecordPage> createState() => _ExerciseRecordPageState();
}

class _ExerciseRecordPageState extends ConsumerState<ExerciseRecordPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exerciseRecordFormNotifierProvider);
    final notifier = ref.read(exerciseRecordFormNotifierProvider.notifier);

    // 성공 시 화면 닫기
    ref.listen<ExerciseRecordFormState>(exerciseRecordFormNotifierProvider,
        (previous, next) {
      if (next is ExerciseRecordFormSuccess) {
        // Home, Analytics 화면 갱신
        refreshHome(ref);
        refreshAnalytics(ref);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${next.record.exerciseTypeName} ${next.record.durationMinutes}분이 기록되었습니다',
            ),
            backgroundColor: const Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
          ),
        );
      } else if (next is ExerciseRecordFormError) {
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
    int? selectedExercise;
    double duration = 30;
    int? selectedIntensity;
    bool canSubmit = false;
    bool isSubmitting = false;

    if (state is ExerciseRecordFormInProgress) {
      selectedExercise = state.selectedExercise;
      duration = state.duration;
      selectedIntensity = state.selectedIntensity;
      canSubmit = state.canSubmit;
    } else if (state is ExerciseRecordFormSubmitting) {
      selectedExercise = state.selectedExercise;
      duration = state.duration;
      selectedIntensity = state.selectedIntensity;
      isSubmitting = true;
    } else if (state is ExerciseRecordFormError) {
      selectedExercise = state.selectedExercise;
      duration = state.duration;
      selectedIntensity = state.selectedIntensity;
      canSubmit = selectedExercise != null && selectedIntensity != null;
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
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('🏃', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '운동 기록',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 운동 종류
              const Text(
                '운동 종류',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 12),
              ExerciseTypeGrid(
                selectedExercise: selectedExercise,
                onExerciseSelected: notifier.selectExercise,
              ),

              const SizedBox(height: 24),

              // 운동 시간
              const Text(
                '운동 시간',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 12),
              DurationSlider(
                duration: duration,
                onDurationChanged: notifier.setDuration,
                onQuickDurationSelected: notifier.selectQuickDuration,
              ),

              const SizedBox(height: 24),

              // 운동 강도
              const Text(
                '운동 강도',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 12),
              IntensitySelector(
                selectedIntensity: selectedIntensity,
                onIntensitySelected: notifier.selectIntensity,
              ),

              const SizedBox(height: 24),

              // 기록 완료 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : (canSubmit ? notifier.submit : null),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4CAF50),
                    disabledBackgroundColor: const Color(0xFFE0E0E0),
                    padding: const EdgeInsets.symmetric(vertical: 14),
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
                            Icon(Icons.check, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              '기록 완료',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
