import 'package:flutter/material.dart';

/// 인사이트 타입
enum InsightType {
  /// 긍정적인 인사이트
  positive,

  /// 수분 인사이트
  water,

  /// 시간 인사이트
  time,

  /// 경고 인사이트
  warning,
}

/// 인사이트 엔티티
class InsightEntity {
  /// 인사이트 엔티티 생성자
  const InsightEntity({
    required this.type,
    required this.title,
    required this.description,
  });

  /// 인사이트 타입
  final InsightType type;

  /// 인사이트 제목
  final String title;

  /// 인사이트 설명
  final String description;

  /// 타입에 따른 아이콘
  IconData get icon {
    switch (type) {
      case InsightType.positive:
        return Icons.check_circle;
      case InsightType.water:
        return Icons.water_drop;
      case InsightType.time:
        return Icons.access_time;
      case InsightType.warning:
        return Icons.warning_amber_rounded;
    }
  }

  /// 타입에 따른 아이콘 색상
  Color get iconColor {
    switch (type) {
      case InsightType.positive:
        return const Color(0xFF4CAF50);
      case InsightType.water:
        return const Color(0xFF2196F3);
      case InsightType.time:
        return const Color(0xFFFF9800);
      case InsightType.warning:
        return const Color(0xFFF44336);
    }
  }

  /// 타입에 따른 배경 색상
  Color get backgroundColor {
    switch (type) {
      case InsightType.positive:
        return const Color(0xFFE8F5E9);
      case InsightType.water:
        return const Color(0xFFE3F2FD);
      case InsightType.time:
        return const Color(0xFFFFF3E0);
      case InsightType.warning:
        return const Color(0xFFFFEBEE);
    }
  }
}
