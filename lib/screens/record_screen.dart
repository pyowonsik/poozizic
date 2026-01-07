import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  DateTime _selectedDateTime = DateTime.now();
  int? _selectedBristolType = 4;
  int? _selectedFeeling = 2;
  
  // 물마심 기록
  final TextEditingController _waterAmountController = TextEditingController();
  
  // 생활 습관 체크
  bool? _hasFiber = null; // null: 미선택, true: 예, false: 아니오
  bool? _hasExercise = null;
  int? _exerciseTime; // 분 단위 (운동을 했을 때만)
  
  final TextEditingController _memoController = TextEditingController();

  final List<Map<String, dynamic>> _bristolTypes = [
    {'type': 1, 'icon': '🟤', 'label': '딱딱한 덩어리'},
    {'type': 2, 'icon': '🟫', 'label': '울퉁불퉁'},
    {'type': 3, 'icon': '🌰', 'label': '금이 간 소시지'},
    {'type': 4, 'icon': '🌭', 'label': '부드럽고 매끈'},
    {'type': 5, 'icon': '🍫', 'label': '부드러운 조각'},
    {'type': 6, 'icon': '💧', 'label': '흐트러진 조각'},
  ];

  final List<String> _feelings = ['😣', '😐', '😊', '😄'];

  @override
  void dispose() {
    _memoController.dispose();
    _waterAmountController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8B4513),
            ),
          ),
          child: child!,
        );
      },
    );

    if (date != null && mounted) {
      setState(() {
        _selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  void _saveRecord() {
    // TODO: 실제 데이터 저장 로직
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('기록이 저장되었습니다'),
        backgroundColor: Color(0xFF228B22),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '기록하기',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF654321),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 일시 선택
            InkWell(
              onTap: _selectDateTime,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF8B4513).withOpacity(0.1),
                      const Color(0xFF8B4513).withOpacity(0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF8B4513).withOpacity(0.2),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B4513).withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.calendar_today,
                        size: 24,
                        color: Color(0xFF8B4513),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '날짜',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF999999),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            DateFormat('yyyy년 M월 d일 (E)', 'ko_KR').format(_selectedDateTime),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF333333),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Bristol Scale
            const Text(
              '배변 상태 (Bristol Scale)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.85,
              ),
              itemCount: _bristolTypes.length,
              itemBuilder: (context, index) {
                final item = _bristolTypes[index];
                final isSelected = _selectedBristolType == item['type'];
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedBristolType = item['type'];
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFF5E6D3)
                            : Colors.white,
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFF8B4513)
                              : Colors.grey[300]!,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            item['icon'],
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Type ${item['type']}',
                            style: TextStyle(
                              fontSize: 9,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['label'],
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333),
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                );
              },
            ),

            const SizedBox(height: 24),

            // 배변감
            const Text(
              '배변감',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(_feelings.length, (index) {
                final isSelected = _selectedFeeling == index;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index < _feelings.length - 1 ? 8 : 0,
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedFeeling = index;
                        });
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF5E6D3)
                              : Colors.white,
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF8B4513)
                                : Colors.grey[300]!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            _feelings[index],
                            style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 32),

            // 물마심 섭취
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF87CEEB).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '💧',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        '물마심',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _waterAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'ml 단위로 입력해주세요',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      suffixText: 'ml',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: Color(0xFF8B4513), width: 2),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 생활 습관 체크
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[300]!, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '오늘의 생활 습관',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF666666),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // 식이섬유 체크
                  _buildHabitCheck(
                    icon: '🥗',
                    label: '식이섬유 함유 음식\n(채소, 과일, 현미 등)을 먹었나요?',
                    value: _hasFiber,
                    onChanged: (value) {
                      setState(() {
                        _hasFiber = value;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // 운동 체크
                  _buildExerciseCheck(),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 메모
            const Text(
              '메모 (선택)',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _memoController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: '특이사항을 기록해보세요',
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color(0xFF8B4513), width: 2),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),

            const SizedBox(height: 32),

            // 저장 버튼
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveRecord,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B4513),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  '저장하기',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitCheck({
    required String icon,
    required String label,
    required bool? value,
    required Function(bool?) onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          icon,
          style: const TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      label: '예',
                      isSelected: value == true,
                      onTap: () => onChanged(value == true ? null : true),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildToggleButton(
                      label: '아니오',
                      isSelected: value == false,
                      onTap: () => onChanged(value == false ? null : false),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF8B4513)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? const Color(0xFF8B4513)
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : const Color(0xFF666666),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseCheck() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🏃',
          style: TextStyle(fontSize: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '오늘 장 운동\n(걷기, 스트레칭 등)을 했나요?',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF333333),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildToggleButton(
                      label: '예',
                      isSelected: _hasExercise == true,
                      onTap: () {
                        setState(() {
                          _hasExercise = _hasExercise == true ? null : true;
                          if (_hasExercise != true) {
                            _exerciseTime = null;
                          }
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildToggleButton(
                      label: '아니오',
                      isSelected: _hasExercise == false,
                      onTap: () {
                        setState(() {
                          _hasExercise = _hasExercise == false ? null : false;
                          _exerciseTime = null;
                        });
                      },
                    ),
                  ),
                ],
              ),
              if (_hasExercise == true) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      '운동 시간: ',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey[300]!, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            value: _exerciseTime,
                            hint: const Text(
                              '시간 선택',
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF999999),
                              ),
                            ),
                            isExpanded: true,
                            items: List.generate(12, (index) {
                              final minutes = (index + 1) * 10;
                              return DropdownMenuItem(
                                value: minutes,
                                child: Text('$minutes분'),
                              );
                            }),
                            onChanged: (value) {
                              setState(() {
                                _exerciseTime = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}


