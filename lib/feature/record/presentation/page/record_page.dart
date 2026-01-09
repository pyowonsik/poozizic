import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/record_providers.dart';
import '../provider/record_form_notifier.dart';
import '../provider/record_form_state.dart';
import '../widget/bristol_scale_step.dart';
import '../widget/feeling_step.dart';
import '../widget/time_step.dart';

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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('배변 기록이 완료되었습니다'),
            backgroundColor: Color(0xFF4CAF50),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
          ),
        );
        // 기록 목록 갱신
        refreshRecords(ref);
      } else if (next is RecordFormError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.only(bottom: 30, left: 20, right: 20),
          ),
        );
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
          // 진행 상황 바
          _buildProgressBar(state),
          const SizedBox(height: 24),
          // 헤더
          _buildHeader(),
          const SizedBox(height: 32),
          // 스텝 콘텐츠
          Expanded(child: _buildStepContent(state, notifier)),
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

  Widget _buildProgressBar(RecordFormState state) {
    final currentStep =
        state is RecordFormInProgress ? state.currentStep : 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: List.generate(3, (index) {
                return Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                    decoration: BoxDecoration(
                      color: index <= currentStep
                          ? const Color(0xFF5E35B1)
                          : const Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${currentStep + 1}/3',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF9C27B0).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.bathroom,
              color: Color(0xFF9C27B0),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            '배변 기록',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent(RecordFormState state, RecordFormNotifier notifier) {
    if (state is RecordFormSubmitting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is! RecordFormInProgress) {
      return const SizedBox.shrink();
    }

    switch (state.currentStep) {
      case 0:
        return BristolScaleStep(
          selectedType: state.selectedBristolType,
          onTypeSelected: notifier.selectBristolType,
          onNext: notifier.nextStep,
        );
      case 1:
        return FeelingStep(
          selectedFeeling: state.selectedFeeling,
          onFeelingSelected: notifier.selectFeeling,
          onNext: notifier.nextStep,
        );
      case 2:
        return TimeStep(
          selectedDuration: state.selectedDuration,
          onDurationChanged: notifier.setDuration,
          onSubmit: notifier.submitRecord,
          isSubmitting: false,
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
