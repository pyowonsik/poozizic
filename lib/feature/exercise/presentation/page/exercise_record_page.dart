import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/exercise_providers.dart';
import '../provider/provider.dart';
import '../widget/widget.dart';
import '../../../../shared/widget/pz_loading_view.dart';
import '../../../../shared/widget/pz_snackbar.dart';

/// 운동 기록 페이지 (Clean Architecture)
class ExerciseRecordPage extends ConsumerWidget {
  const ExerciseRecordPage({super.key});

  static final List<Map<String, String>> _exercises = [
    {'emoji': '🏃', 'label': '달리기'},
    {'emoji': '🚶', 'label': '걷기'},
    {'emoji': '🚴', 'label': '자전거'},
    {'emoji': '🏊', 'label': '수영'},
    {'emoji': '🧘', 'label': '요가'},
    {'emoji': '🏋️', 'label': '웨이트'},
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exerciseNotifierProvider);
    final notifier = ref.read(exerciseNotifierProvider.notifier);

    // 성공 시 처리
    ref.listen<ExerciseState>(exerciseNotifierProvider, (previous, next) {
      if (next is ExerciseSuccess) {
        final prevState = previous;
        String exerciseLabel = '운동';
        int duration = 30;

        if (prevState is ExerciseInProgress) {
          if (prevState.selectedExercise != null) {
            exerciseLabel = _exercises[prevState.selectedExercise!]['label']!;
          }
          duration = prevState.duration;
        }

        Navigator.pop(context);
        PzSnackBar.showSuccess(
          context,
          '$exerciseLabel $duration분이 기록되었습니다',
        );
      } else if (next is ExerciseError) {
        PzSnackBar.showError(context, next.message);
      }
    });

    // 현재 상태 가져오기
    int? currentExercise;
    int currentDuration;
    int? currentIntensity;

    if (state is ExerciseInProgress) {
      currentExercise = state.selectedExercise;
      currentDuration = state.duration;
      currentIntensity = state.selectedIntensity;
    } else if (state is ExerciseInitial) {
      currentExercise = state.selectedExercise;
      currentDuration = state.duration;
      currentIntensity = state.selectedIntensity;
    } else {
      currentExercise = null;
      currentDuration = 30;
      currentIntensity = null;
    }

    final isSubmitting = state is ExerciseSubmitting;
    final canSubmit = currentExercise != null && currentIntensity != null;

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
                      selectedExercise: currentExercise,
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
                    ExerciseDurationCard(
                      duration: currentDuration,
                      onDurationChanged: notifier.setDuration,
                    ),

                    const SizedBox(height: 16),

                    // 빠른 시간 선택
                    ExerciseQuickDurationButtons(
                      onDurationSelected: notifier.setDuration,
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
                    ExerciseIntensitySelector(
                      selectedIntensity: currentIntensity,
                      onIntensitySelected: notifier.selectIntensity,
                    ),

                    const SizedBox(height: 24),

                    // 기록 완료 버튼
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: canSubmit ? () => notifier.submitRecord() : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4CAF50),
                          disabledBackgroundColor: const Color(0xFFE0E0E0),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
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
