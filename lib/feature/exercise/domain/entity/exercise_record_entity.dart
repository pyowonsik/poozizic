/// 운동 기록 엔티티
class ExerciseRecordEntity {
  final int? id;
  final int exerciseType; // 0: 달리기, 1: 걷기, 2: 자전거, 3: 수영, 4: 요가, 5: 웨이트
  final int duration; // 분
  final int intensity; // 0: 가볍게, 1: 보통, 2: 격하게
  final DateTime recordedAt;

  const ExerciseRecordEntity({
    this.id,
    required this.exerciseType,
    required this.duration,
    required this.intensity,
    required this.recordedAt,
  });

  String get exerciseTypeLabel {
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
        return '알 수 없음';
    }
  }

  String get intensityLabel {
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

  ExerciseRecordEntity copyWith({
    int? id,
    int? exerciseType,
    int? duration,
    int? intensity,
    DateTime? recordedAt,
  }) {
    return ExerciseRecordEntity(
      id: id ?? this.id,
      exerciseType: exerciseType ?? this.exerciseType,
      duration: duration ?? this.duration,
      intensity: intensity ?? this.intensity,
      recordedAt: recordedAt ?? this.recordedAt,
    );
  }
}
