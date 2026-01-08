import 'package:flutter/material.dart';

class MealRecordScreen extends StatefulWidget {
  const MealRecordScreen({super.key});

  @override
  State<MealRecordScreen> createState() => _MealRecordScreenState();
}

class _MealRecordScreenState extends State<MealRecordScreen> {
  int _selectedMealType = 0; // 0: 아침, 1: 점심, 2: 저녁, 3: 간식
  final TextEditingController _foodController = TextEditingController();
  final List<String> _foods = [];
  int? _selectedFiber; // 0: 많음, 1: 보통, 2: 적음

  final List<Map<String, String>> _mealTypes = [
    {'emoji': '🌅', 'label': '아침'},
    {'emoji': '☀️', 'label': '점심'},
    {'emoji': '🍌', 'label': '저녁'},
    {'emoji': '🍪', 'label': '간식'},
  ];

  final List<Map<String, String>> _fiberLevels = [
    {'emoji': '🥬', 'label': '많음'},
    {'emoji': '🍽️', 'label': '보통'},
    {'emoji': '🥩', 'label': '적음'},
  ];

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE91E63).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      '👕',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    '식사 기록',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF000000),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // 식사 구분
              const Text(
                '식사 구분',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: List.generate(_mealTypes.length, (index) {
                  final meal = _mealTypes[index];
                  final isSelected = _selectedMealType == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedMealType = index),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index < _mealTypes.length - 1 ? 12 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF5E35B1).withOpacity(0.1)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF5E35B1)
                                : const Color(0xFFE0E0E0),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              meal['emoji']!,
                              style: const TextStyle(fontSize: 24),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              meal['label']!,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight:
                                    isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? const Color(0xFF5E35B1)
                                    : const Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 32),

              // 먹은 음식
              const Text(
                '먹은 음식',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _foodController,
                      decoration: InputDecoration(
                        hintText: '음식 이름 입력',
                        hintStyle: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 15,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF5F5F5),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      onSubmitted: (value) => _addFood(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E35B1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: _addFood,
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // 추가된 음식 태그들
              if (_foods.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _foods.map((food) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E35B1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            food,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5E35B1),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _foods.remove(food);
                              });
                            },
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Color(0xFF5E35B1),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

              const SizedBox(height: 32),

              // 식이섬유 함량
              const Text(
                '식이섬유 함량',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: List.generate(_fiberLevels.length, (index) {
                  final fiber = _fiberLevels[index];
                  final isSelected = _selectedFiber == index;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedFiber = index),
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index < _fiberLevels.length - 1 ? 12 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF5E35B1).withOpacity(0.1)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF5E35B1)
                                : const Color(0xFFE0E0E0),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              fiber['emoji']!,
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              fiber['label']!,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight:
                                    isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? const Color(0xFF5E35B1)
                                    : const Color(0xFF666666),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 40),

              // 기록 완료 버튼
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _foods.isNotEmpty && _selectedFiber != null
                      ? () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('식사 기록이 완료되었습니다'),
                              backgroundColor: Color(0xFF4CAF50),
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.only(bottom: 30, left: 20, right: 20),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E35B1),
                    disabledBackgroundColor: const Color(0xFFE0E0E0),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.check, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        '기록 완료',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addFood() {
    final food = _foodController.text.trim();
    if (food.isNotEmpty) {
      setState(() {
        _foods.add(food);
        _foodController.clear();
      });
    }
  }
}

