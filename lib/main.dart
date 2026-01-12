import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:poozizic/core/supabase/supabase_config.dart';
import 'package:poozizic/feature/analytics/presentation/page/analytics_page.dart';
import 'package:poozizic/feature/auth/presentation/page/splash_page.dart';
import 'package:poozizic/feature/calendar/presentation/page/calendar_page.dart';
import 'package:poozizic/feature/exercise_record/presentation/page/exercise_record_page.dart';
import 'package:poozizic/feature/home/presentation/page/home_page.dart';
import 'package:poozizic/feature/meal_record/presentation/page/meal_record_page.dart';
import 'package:poozizic/feature/record/presentation/page/record_page.dart';
import 'package:poozizic/feature/settings/presentation/page/settings_page.dart';
import 'package:poozizic/feature/water_record/presentation/page/water_record_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR');
  await SupabaseConfig.initialize();
  runApp(const ProviderScope(child: MyApp()));
}

/// 앱 메인 위젯
class MyApp extends StatelessWidget {
  /// 앱 메인 위젯 생성자
  /// [key] 키
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '똥 플랜',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B4513),
          primary: const Color(0xFF8B4513),
          secondary: const Color(0xFF4CAF50),
        ),
        useMaterial3: true,
        fontFamily: '-apple-system',
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
      home: const SplashPage(),
    );
  }
}

/// 메인 화면
class MainScreen extends StatefulWidget {
  /// 메인 화면 생성자
  /// [key] 키
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomePage(),
    const CalendarPage(),
    const Center(child: Text('기록 화면')), // 사용하지 않음
    const AnalyticsPage(),
    const SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showQuickRecordBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '빠른 기록',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
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
              '기록할 항목을 선택하세요',
              style: TextStyle(fontSize: 14, color: Color(0xFF999999)),
            ),
            const SizedBox(height: 24),
            _buildRecordTypeButton(
              context: context,
              icon: Icons.bathroom,
              label: '배변 기록',
              subtitle: '빠르게 기록하기',
              gradient: const LinearGradient(
                colors: [Color(0xFF9C27B0), Color(0xFF5E35B1)],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const RecordPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildRecordTypeButton(
              context: context,
              icon: Icons.restaurant,
              label: '식사 기록',
              subtitle: '빠르게 기록하기',
              gradient: const LinearGradient(
                colors: [Color(0xFFFF5722), Color(0xFFE91E63)],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const MealRecordPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildRecordTypeButton(
              context: context,
              icon: Icons.water_drop,
              label: '수분 기록',
              subtitle: '빠르게 기록하기',
              gradient: const LinearGradient(
                colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const WaterRecordPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _buildRecordTypeButton(
              context: context,
              icon: Icons.directions_run,
              label: '운동 기록',
              subtitle: '빠르게 기록하기',
              gradient: const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (context) => const ExerciseRecordPage(),
                  ),
                );
              },
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordTypeButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String subtitle,
    required Gradient gradient,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white, size: 28),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _screens),
      floatingActionButton: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFF6B35), Color(0xFFFF5722)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF6B35).withValues(alpha: .4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            _showQuickRecordBottomSheet(context);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          elevation: 0,
          notchMargin: 8,
          shape: const CircularNotchedRectangle(),
          child: SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_outlined, Icons.home, '홈', 0),
                _buildNavItem(
                  Icons.calendar_today_outlined,
                  Icons.calendar_today,
                  '캘린더',
                  1,
                ),
                const SizedBox(width: 48), // 중앙 FAB 공간
                _buildNavItem(
                  Icons.bar_chart_outlined,
                  Icons.bar_chart,
                  '분석',
                  3,
                ),
                _buildNavItem(Icons.settings_outlined, Icons.settings, '설정', 4),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    IconData activeIcon,
    String label,
    int index,
  ) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: InkWell(
        onTap: () => _onItemTapped(index),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              size: 24,
              color: isSelected
                  ? const Color(0xFFFF6B35)
                  : const Color(0xFF9E9E9E),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFFFF6B35)
                    : const Color(0xFF9E9E9E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
