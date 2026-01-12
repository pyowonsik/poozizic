/// 운동 기록 엔티티
class ExerciseRecordEntity {
  final int? id;
  final DateTime dateTime;
  final int exerciseType; // 0-5 (달리기, 걷기, 자전거, 수영, 요가, 웨이트)
  final int durationMinutes;
  final int intensity; // 0: 가볍게, 1: 보통, 2: 격하게
  final DateTime createdAt;

  const ExerciseRecordEntity({
    this.id,
    required this.dateTime,
    required this.exerciseType,
    required this.durationMinutes,
    required this.intensity,
    required this.createdAt,
  });

  /// 운동 타입 이름
  String get exerciseTypeName {
    switch (exerciseType) {
      case 0:
        return '달리기';
      case 1:
        return '걷기';
      case 2:
        return '자전거';
      case 3:
        return '수영';
      case 4:
        return '요가';
      case 5:
        return '웨이트';
      default:
        return '기타';
    }
  }

  /// 운동 타입 이모지
  String get exerciseTypeEmoji {
    switch (exerciseType) {
      case 0:
        return '🏃';
      case 1:
        return '🚶';
      case 2:
        return '🚴';
      case 3:
        return '🏊';
      case 4:
        return '🧘';
      case 5:
        return '🏋️';
      default:
        return '🏃';
    }
  }

  /// 강도 이름
  String get intensityName {
    switch (intensity) {
      case 0:
        return '가볍게';
      case 1:
        return '보통';
      case 2:
        return '격하게';
      default:
        return '알 수 없음';
    }
  }

  /// 강도 이모지
  String get intensityEmoji {
    switch (intensity) {
      case 0:
        return '😌';
      case 1:
        return '💪';
      case 2:
        return '🔥';
      default:
        return '💪';
    }
  }

  ExerciseRecordEntity copyWith({
    int? id,
    DateTime? dateTime,
    int? exerciseType,
    int? durationMinutes,
    int? intensity,
    DateTime? createdAt,
  }) {
    return ExerciseRecordEntity(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      exerciseType: exerciseType ?? this.exerciseType,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      intensity: intensity ?? this.intensity,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
