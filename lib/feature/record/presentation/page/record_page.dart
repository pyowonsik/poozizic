import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/record_providers.dart';
import '../provider/record_form_notifier.dart';
import '../provider/record_form_state.dart';
import '../widget/widget.dart';
import '../../../../shared/widget/pz_loading_view.dart';
import '../../../../shared/widget/pz_snackbar.dart';

/// 배변 기록 페이지 (Clean Architecture)
class RecordPage extends ConsumerStatefulWidget {
  const RecordPage({super.key});

  @override
  ConsumerState<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends ConsumerState<RecordPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(recordFormNotifierProvider);
    final notifier = ref.read(recordFormNotifierProvider.notifier);

    // 성공 시 처리
    ref.listen<RecordFormState>(recordFormNotifierProvider, (previous, next) {
      if (next is RecordFormSuccess) {
        Navigator.pop(context);
        PzSnackBar.showSuccess(context, '배변 기록이 완료되었습니다');
        // 기록 목록 갱신
        refreshRecords(ref);
      } else if (next is RecordFormError) {
        PzSnackBar.showError(context, next.message);
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black),
          onPressed: () => _handleBack(state, notifier),
        ),
      ),
      body: Column(
        children: [
          RecordProgressBar(state: state),
          const SizedBox(height: 24),
          const RecordHeader(),
          const SizedBox(height: 32),
          Expanded(
            child: state is RecordFormSubmitting
                ? const PzLoadingView()
                : state is! RecordFormInProgress
                    ? const SizedBox.shrink()
                    : switch (state.currentStep) {
                        0 => BristolScaleStep(
                            selectedType: state.selectedBristolType,
                            onTypeSelected: notifier.selectBristolType,
                            onNext: notifier.nextStep,
                          ),
                        1 => FeelingStep(
                            selectedFeeling: state.selectedFeeling,
                            onFeelingSelected: notifier.selectFeeling,
                            onNext: notifier.nextStep,
                          ),
                        2 => TimeStep(
                            selectedDuration: state.selectedDuration,
                            onDurationChanged: notifier.setDuration,
                            onSubmit: notifier.submitRecord,
                            isSubmitting: false,
                          ),
                        _ => const SizedBox.shrink(),
                      },
          ),
        ],
      ),
    );
  }

  void _handleBack(RecordFormState state, RecordFormNotifier notifier) {
    if (state is RecordFormInProgress && state.currentStep > 0) {
      notifier.previousStep();
    } else {
      Navigator.pop(context);
    }
  }
}
