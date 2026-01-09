import 'package:flutter/material.dart';

class WaterRecordScreen extends StatefulWidget {
  const WaterRecordScreen({super.key});

  @override
  State<WaterRecordScreen> createState() => _WaterRecordScreenState();
}

class _WaterRecordScreenState extends State<WaterRecordScreen> {
  double _waterAmount = 250;
  int? _selectedPreset = 1; // 머그컵이 기본 선택

  final List<Map<String, dynamic>> _presets = [
    {'emoji': '☕', 'label': '컵 1잔', 'amount': 200},
    {'emoji': '🥤', 'label': '머그컵', 'amount': 250},
    {'emoji': '🥫', 'label': '캔', 'amount': 355},
    {'emoji': '🧃', 'label': '물병', 'amount': 500},
  ];

  final List<int> _quickAmounts = [100, 150, 300, 750];

  @override
  Widget build(BuildContext context) {
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
      body: SingleChildScrollView(
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
                      color: const Color(0xFF2196F3).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text('💧', style: TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '수분 기록',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 물방울 카드
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2196F3), Color(0xFF00BCD4)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.white, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      '${_waterAmount.toInt()}',
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'ml',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 슬라이더
              SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: const Color(0xFF2196F3),
                  inactiveTrackColor: const Color(0xFFB3E5FC),
                  thumbColor: const Color(0xFF2196F3),
                  overlayColor: const Color(0xFF2196F3).withValues(alpha: 0.2),
                  thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 12,
                  ),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: _waterAmount,
                  min: 50,
                  max: 1000,
                  divisions: 95,
                  onChanged: (value) {
                    setState(() {
                      _waterAmount = value;
                      _selectedPreset = null; // 슬라이더 조작 시 프리셋 선택 해제
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      '50ml',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                    Text(
                      '1000ml',
                      style: TextStyle(fontSize: 12, color: Color(0xFF999999)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 빠른 선택
              const Text(
                '빠른 선택',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.4,
                children: List.generate(_presets.length, (index) {
                  final preset = _presets[index];
                  final isSelected = _selectedPreset == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedPreset = index;
                        _waterAmount = preset['amount'].toDouble();
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2196F3).withValues(alpha: 0.1)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF2196F3)
                              : const Color(0xFFE0E0E0),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            preset['emoji'],
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            preset['label'],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected
                                  ? const Color(0xFF2196F3)
                                  : const Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${preset['amount']}ml',
                            style: TextStyle(
                              fontSize: 11,
                              color: isSelected
                                  ? const Color(0xFF2196F3)
                                  : const Color(0xFF666666),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 20),

              // 빠른 양 선택 버튼
              Row(
                children: List.generate(_quickAmounts.length, (index) {
                  final amount = _quickAmounts[index];
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        right: index < _quickAmounts.length - 1 ? 8 : 0,
                      ),
                      child: OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _waterAmount = amount.toDouble();
                            _selectedPreset = null;
                          });
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          side: const BorderSide(
                            color: Color(0xFFE0E0E0),
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          '${amount}ml',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 24),

              // 기록 완료 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${_waterAmount.toInt()}ml가 기록되었습니다'),
                        backgroundColor: const Color(0xFF4CAF50),
                        behavior: SnackBarBehavior.floating,
                        margin: const EdgeInsets.only(
                          bottom: 30,
                          left: 20,
                          right: 20,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
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
