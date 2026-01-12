import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/settings_providers.dart';
import '../provider/settings_state.dart';
import '../widget/widget.dart';
import '../../../../shared/widget/pz_loading_view.dart';
import '../../../../shared/widget/pz_error_view.dart';
import '../../../../shared/widget/pz_dialog.dart';
import '../../../../shared/widget/pz_snackbar.dart';

/// 설정 페이지 (Clean Architecture)
class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(settingsNotifierProvider);
    final notifier = ref.read(settingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          '설정',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
      ),
      body: switch (state) {
        SettingsInitial() => const PzLoadingView(),
        SettingsLoading() => const PzLoadingView(),
        SettingsError(:final message) => PzErrorView(
            message: message,
            onRetry: () => notifier.loadSettings(),
          ),
        SettingsLoaded(:final settings) => SingleChildScrollView(
            child: Column(
              children: [
                // 사용자 프로필
                const ProfileSection(),

                const SizedBox(height: 12),

                // 프로필 메뉴 섹션
                const SettingsSection(
                  icon: Icons.person_outline,
                  iconColor: Color(0xFFFF6B35),
                  title: '프로필',
                  children: [
                    SettingsListTile(
                      title: '프로필 편집',
                      onTap: null,
                    ),
                    SettingsListTile(
                      title: '건강 정보',
                      onTap: null,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 목표 섹션
                GoalSection(
                  settings: settings,
                  onWaterGoalTap: () => WaterGoalBottomSheet.show(context),
                  onBowelGoalTap: () => BowelGoalBottomSheet.show(context),
                ),

                const SizedBox(height: 12),

                // 알림 섹션
                NotificationSection(
                  settings: settings,
                  onBowelReminderChanged: notifier.updateBowelReminder,
                  onWaterReminderChanged: notifier.updateWaterReminder,
                  onWeeklyReportChanged: notifier.updateWeeklyReport,
                ),

                const SizedBox(height: 12),

                // 프라이버시 섹션
                PrivacySection(
                  settings: settings,
                  onAppLockChanged: notifier.updateAppLock,
                  onHideNotificationContentChanged: notifier.updateHideNotificationContent,
                  onCloudBackupChanged: notifier.updateCloudBackup,
                ),

                const SizedBox(height: 12),

                // 데이터 섹션
                SettingsSection(
                  icon: Icons.download_outlined,
                  iconColor: const Color(0xFFFF6B35),
                  title: '데이터',
                  children: [
                    SettingsListTile(
                      title: '데이터 내보내기',
                      onTap: () => _showConfirmDialog(
                        '데이터 내보내기',
                        '모든 기록을 CSV 파일로 내보내시겠습니까?',
                      ),
                    ),
                    SettingsListTile(
                      title: '데이터 가져오기',
                      onTap: () => _showConfirmDialog(
                        '데이터 가져오기',
                        'CSV 파일에서 데이터를 가져오시겠습니까?',
                      ),
                    ),
                    SettingsListTile(
                      title: '모든 데이터 삭제',
                      titleColor: const Color(0xFFE53935),
                      onTap: () => _showConfirmDialog(
                        '모든 데이터 삭제',
                        '모든 기록이 영구적으로 삭제됩니다. 계속하시겠습니까?',
                        isDestructive: true,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // 정보 섹션
                const SettingsSection(
                  icon: Icons.info_outline,
                  iconColor: Color(0xFFFF6B35),
                  title: '정보',
                  children: [
                    SettingsListTile(
                      title: '앱 버전',
                      trailing: Text(
                        '1.0.0',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF999999),
                        ),
                      ),
                      onTap: null,
                    ),
                    SettingsListTile(
                      title: '이용 약관',
                      onTap: null,
                    ),
                    SettingsListTile(
                      title: '개인정보 처리방침',
                      onTap: null,
                    ),
                    SettingsListTile(
                      title: '오픈소스 라이선스',
                      onTap: null,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // 로그아웃 버튼
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _showConfirmDialog(
                        '로그아웃',
                        '로그아웃 하시겠습니까?',
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(
                          color: Color(0xFFE0E0E0),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
      },
    );
  }

  Future<void> _showConfirmDialog(
    String title,
    String message, {
    bool isDestructive = false,
  }) async {
    if (!mounted) return;

    final result = await PzDialog.show(
      context: context,
      title: title,
      content: message,
      confirmText: '확인',
      cancelText: '취소',
      confirmColor: isDestructive
          ? const Color(0xFFE53935)
          : const Color(0xFFFF6B35),
    );

    if (mounted && result == true) {
      PzSnackBar.showSuccess(context, '$title 완료');
    }
  }
}
