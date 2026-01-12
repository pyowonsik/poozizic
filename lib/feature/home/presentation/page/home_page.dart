import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/home/di/home_providers.dart';
import 'package:poozizic/feature/home/presentation/provider/home_notifier.dart';
import 'package:poozizic/feature/home/presentation/provider/home_state.dart';
import 'package:poozizic/feature/home/presentation/widget/health_score_card.dart';
import 'package:poozizic/feature/home/presentation/widget/recent_records_section.dart';
import 'package:poozizic/feature/home/presentation/widget/today_status_card.dart';
import 'package:poozizic/feature/home/presentation/widget/water_progress_section.dart';

/// 홈 페이지
class HomePage extends ConsumerWidget {
  /// 홈 페이지 생성자
  /// [key] 키
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeNotifierProvider);
    final notifier = ref.read(homeNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        title: Image.asset(
          'assets/image/뿌지직.png',
          height: 50,
          fit: BoxFit.contain,
        ),
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0,
      ),
      body: ColoredBox(
        color: const Color(0xFFF8F9FA),
        child: SafeArea(child: _buildBody(state, notifier)),
      ),
    );
  }

  Widget _buildBody(HomeState state, HomeNotifier notifier) {
    if (state is HomeLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is HomeError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              state.message,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => notifier.refresh(),
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    if (state is HomeLoaded) {
      return RefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // 오늘의 상태
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '오늘의 상태',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TodayStatusCard(summary: state.summary),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 오늘 수분 섭취
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: WaterProgressSection(summary: state.summary),
              ),

              const SizedBox(height: 20),

              // 건강 점수 카드
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: HealthScoreCard(
                  healthScore: state.healthScore,
                  isExpanded: state.isHealthScoreExpanded,
                  onTap: notifier.toggleHealthScoreExpanded,
                ),
              ),

              const SizedBox(height: 30),

              // 최근 기록
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RecentRecordsSection(
                  selectedDate: state.selectedDate,
                  records: state.recentRecords,
                  onPreviousDay: notifier.goToPreviousDay,
                  onNextDay: notifier.goToNextDay,
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
