import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 목표 설정
  int _waterGoal = 2000;
  int _bowelGoal = 1;

  // 알림 설정
  bool _bowelReminder = true;
  bool _waterReminder = true;
  bool _weeklyReport = true;

  // 프라이버시 설정
  bool _appLock = false;
  bool _hideNotificationContent = false;
  bool _cloudBackup = false;

  void _showWaterGoalBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '일일 수분 목표',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [1000, 1500, 2000, 2500, 3000, 3500].map((amount) {
                  final isSelected = _waterGoal == amount;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _waterGoal = amount;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 84) / 3,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF42A5F5)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF42A5F5)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.water_drop,
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF42A5F5),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${amount}ml',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF1A1A1A),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showBowelGoalBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '이상적인 배변 횟수',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                '하루 목표 배변 횟수를 선택하세요',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
              ),
              const SizedBox(height: 24),
              ...List.generate(5, (index) {
                final count = index + 1;
                final isSelected = _bowelGoal == count;
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _bowelGoal = count;
                      });
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF5E35B1)
                            : const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF5E35B1)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white.withOpacity(0.2)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                '$count',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF5E35B1),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '하루 $count회',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF1A1A1A),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _getBowelDescription(count),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: isSelected
                                        ? Colors.white70
                                        : const Color(0xFF999999),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 24,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _getBowelDescription(int count) {
    switch (count) {
      case 1:
        return '가장 이상적인 배변 횟수';
      case 2:
        return '정상적인 범위';
      case 3:
        return '약간 잦은 편';
      case 4:
        return '잦은 편, 식습관 확인 필요';
      case 5:
        return '매우 잦음, 전문의 상담 권장';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 사용자 프로필
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF6B35),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '사',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '사용자',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF000000),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'user@example.com',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF999999),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // 프로필 섹션
            _buildSection(
              icon: Icons.person_outline,
              iconColor: const Color(0xFFFF6B35),
              title: '프로필',
              children: [
                _buildListTile(
                  title: '프로필 편집',
                  onTap: () {},
                ),
                _buildListTile(
                  title: '건강 정보',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 목표 섹션
            _buildSection(
              icon: Icons.flag_outlined,
              iconColor: const Color(0xFFFF6B35),
              title: '목표',
              children: [
                _buildListTile(
                  title: '일일 수분 목표',
                  trailing: Text(
                    '${_waterGoal}ml',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                  onTap: _showWaterGoalBottomSheet,
                ),
                _buildListTile(
                  title: '이상적인 배변 횟수',
                  trailing: Text(
                    '${_bowelGoal}회/일',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                  onTap: _showBowelGoalBottomSheet,
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 알림 섹션
            _buildSection(
              icon: Icons.notifications_outlined,
              iconColor: const Color(0xFFFF6B35),
              title: '알림',
              children: [
                _buildSwitchTile(
                  title: '배변 기록 리마인더',
                  value: _bowelReminder,
                  onChanged: (value) {
                    setState(() => _bowelReminder = value);
                  },
                ),
                _buildSwitchTile(
                  title: '수분 섭취 알림',
                  value: _waterReminder,
                  onChanged: (value) {
                    setState(() => _waterReminder = value);
                  },
                ),
                _buildSwitchTile(
                  title: '주간 리포트',
                  value: _weeklyReport,
                  onChanged: (value) {
                    setState(() => _weeklyReport = value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 프라이버시 섹션
            _buildSection(
              icon: Icons.lock_outline,
              iconColor: const Color(0xFFFF6B35),
              title: '프라이버시',
              children: [
                _buildSwitchTile(
                  title: '앱 잠금',
                  value: _appLock,
                  onChanged: (value) {
                    setState(() => _appLock = value);
                  },
                ),
                _buildSwitchTile(
                  title: '알림에서 내용 숨김',
                  value: _hideNotificationContent,
                  onChanged: (value) {
                    setState(() => _hideNotificationContent = value);
                  },
                ),
                _buildSwitchTile(
                  title: '클라우드 백업',
                  value: _cloudBackup,
                  onChanged: (value) {
                    setState(() => _cloudBackup = value);
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 데이터 섹션
            _buildSection(
              icon: Icons.download_outlined,
              iconColor: const Color(0xFFFF6B35),
              title: '데이터',
              children: [
                _buildListTile(
                  title: '데이터 내보내기',
                  onTap: () {
                    _showConfirmDialog(
                      context,
                      '데이터 내보내기',
                      '모든 기록을 CSV 파일로 내보내시겠습니까?',
                    );
                  },
                ),
                _buildListTile(
                  title: '데이터 가져오기',
                  onTap: () {
                    _showConfirmDialog(
                      context,
                      '데이터 가져오기',
                      'CSV 파일에서 데이터를 가져오시겠습니까?',
                    );
                  },
                ),
                _buildListTile(
                  title: '모든 데이터 삭제',
                  titleColor: const Color(0xFFE53935),
                  onTap: () {
                    _showConfirmDialog(
                      context,
                      '모든 데이터 삭제',
                      '모든 기록이 영구적으로 삭제됩니다. 계속하시겠습니까?',
                      isDestructive: true,
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),

            // 정보 섹션
            _buildSection(
              icon: Icons.info_outline,
              iconColor: const Color(0xFFFF6B35),
              title: '정보',
              children: [
                _buildListTile(
                  title: '앱 버전',
                  trailing: const Text(
                    '1.0.0',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF999999),
                    ),
                  ),
                  onTap: null,
                ),
                _buildListTile(
                  title: '이용 약관',
                  onTap: () {},
                ),
                _buildListTile(
                  title: '개인정보 처리방침',
                  onTap: () {},
                ),
                _buildListTile(
                  title: '오픈소스 라이선스',
                  onTap: () {},
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
                  onPressed: () {
                    _showConfirmDialog(
                      context,
                      '로그아웃',
                      '로그아웃 하시겠습니까?',
                    );
                  },
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
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    Widget? trailing,
    Color? titleColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: titleColor ?? const Color(0xFF000000),
              ),
            ),
            if (trailing != null)
              trailing
            else if (onTap != null)
              const Icon(
                Icons.chevron_right,
                color: Color(0xFFCCCCCC),
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF000000),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFFF6B35),
            activeTrackColor: const Color(0xFFFF6B35).withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  void _showConfirmDialog(
    BuildContext context,
    String title,
    String message, {
    bool isDestructive = false,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              '취소',
              style: TextStyle(
                color: Color(0xFF999999),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title 완료'),
                  backgroundColor: isDestructive
                      ? const Color(0xFFE53935)
                      : const Color(0xFF4CAF50),
                ),
              );
            },
            child: Text(
              '확인',
              style: TextStyle(
                color: isDestructive
                    ? const Color(0xFFE53935)
                    : const Color(0xFFFF6B35),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

