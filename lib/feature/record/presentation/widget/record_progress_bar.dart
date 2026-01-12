import 'package:flutter/material.dart';
import '../provider/record_form_state.dart';

/// 배변 기록 진행 상황 바 위젯
///
/// 현재 단계를 시각적으로 표시합니다.
class RecordProgressBar extends StatelessWidget {
  const RecordProgressBar({super.key, required this.state});

  final RecordFormState state;

  @override
  Widget build(BuildContext context) {
    final currentStep = state is RecordFormInProgress
        ? (state as RecordFormInProgress).currentStep
        : 0;

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
}
