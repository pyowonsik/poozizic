import 'package:flutter/material.dart';
import '../widget/widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
      body: Container(
        color: const Color(0xFFF8F9FA),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const TodayStatusSection(),
                const SizedBox(height: 24),
                const WaterIntakeSection(),
                const SizedBox(height: 20),
                const IdealBowelCard(),
                const SizedBox(height: 20),
                const HealthScoreCard(),
                const SizedBox(height: 30),
                const RecentRecordsHeader(),
                const SizedBox(height: 12),
                DateNavigationBar(
                  selectedDate: _selectedDate,
                  onDateChanged: (date) {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      RecordCard(
                        emoji: '💩',
                        title: 'Bristol Type 4 - 부드러운 소시지',
                        subtitle: '배변 기록',
                        time: '08:30',
                        backgroundColor: Color(0xFF90EE90),
                      ),
                      SizedBox(height: 12),
                      RecordCard(
                        emoji: '👕',
                        title: '식사 3회 기록됨',
                        subtitle: '식단 기록',
                        time: '오늘',
                        backgroundColor: Color(0xFFD8BFD8),
                      ),
                      SizedBox(height: 12),
                      RecordCard(
                        emoji: '💧',
                        title: '수분 6회 (1500ml)',
                        subtitle: '수분 섭취 기록',
                        time: '오늘',
                        backgroundColor: Color(0xFF87CEEB),
                      ),
                      SizedBox(height: 12),
                      HealthTipCard(),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
