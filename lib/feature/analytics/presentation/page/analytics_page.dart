import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:poozizic/feature/analytics/di/analytics_providers.dart';
import 'package:poozizic/feature/analytics/presentation/provider/analytics_notifier.dart';
import 'package:poozizic/feature/analytics/presentation/provider/analytics_state.dart';
import 'package:poozizic/feature/analytics/presentation/widget/bowel_distribution_chart.dart';
import 'package:poozizic/feature/analytics/presentation/widget/insight_card.dart';
import 'package:poozizic/feature/analytics/presentation/widget/stat_cards_row.dart';
import 'package:poozizic/feature/analytics/presentation/widget/weekly_frequency_chart.dart';

/// 분석 페이지
class AnalyticsPage extends ConsumerWidget {
  /// 분석 페이지

  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(analyticsNotifierProvider);
    final notifier = ref.read(analyticsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '분석',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: _buildBody(state, notifier),
    );
  }

  Widget _buildBody(AnalyticsState state, AnalyticsNotifier notifier) {
    if (state is AnalyticsLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is AnalyticsError) {
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

    if (state is AnalyticsLoaded) {
      return RefreshIndicator(
        onRefresh: () => notifier.refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '최근 ${state.summary.period}일 데이터 기준',
                style: const TextStyle(fontSize: 13, color: Color(0xFF999999)),
              ),
              const SizedBox(height: 16),

              // 상단 통계 카드 3개
              StatCardsRow(summary: state.summary),

              const SizedBox(height: 24),

              // 배변 상태 분포 (도넛 차트)
              BowelDistributionChart(distribution: state.distribution),

              const SizedBox(height: 24),

              // 주간 배변 빈도 (막대 차트)
              WeeklyFrequencyChart(weeklyFrequency: state.weeklyFrequency),

              const SizedBox(height: 24),

              // 인사이트 카드들
              ...state.insights.map(
                (insight) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: InsightCard(insight: insight),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
