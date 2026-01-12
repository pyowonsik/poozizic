import 'package:poozizic/feature/record/domain/entity/record_entity.dart';

/// 배변 기록 모델
class RecordModel extends RecordEntity {
  /// 배변 기록 모델 생성자
  const RecordModel({
    required super.dateTime,
    required super.bristolType,
    required super.feeling,
    required super.durationMinutes,
    required super.createdAt,
    super.id,
    super.memo,
    this.supabaseId,
    this.userId,
  });

  /// JSON에서 모델 생성
  factory RecordModel.fromJson(Map<String, dynamic> json) {
    return RecordModel(
      supabaseId: json['id'] as String?,
      userId: json['user_id'] as String?,
      dateTime: DateTime.parse(json['record_datetime'] as String),
      bristolType: json['bristol_type'] as int,
      feeling: json['feeling'] as int,
      durationMinutes: json['duration_minutes'] as int,
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Entity에서 모델 생성
  factory RecordModel.fromEntity(RecordEntity entity, {String? userId}) {
    return RecordModel(
      id: entity.id,
      dateTime: entity.dateTime,
      bristolType: entity.bristolType,
      feeling: entity.feeling,
      durationMinutes: entity.durationMinutes,
      memo: entity.memo,
      createdAt: entity.createdAt,
      userId: userId,
    );
  }

  /// Supabase UUID ID
  final String? supabaseId;

  /// 사용자 ID
  final String? userId;

  /// JSON으로 변환 (INSERT용)
  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'user_id': userId,
      'record_datetime': dateTime.toIso8601String(),
      'bristol_type': bristolType,
      'feeling': feeling,
      'duration_minutes': durationMinutes,
      'memo': memo,
    };
  }

  @override
  RecordModel copyWith({
    int? id,
    DateTime? dateTime,
    int? bristolType,
    int? feeling,
    int? durationMinutes,
    String? memo,
    DateTime? createdAt,
    String? supabaseId,
    String? userId,
  }) {
    return RecordModel(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      bristolType: bristolType ?? this.bristolType,
      feeling: feeling ?? this.feeling,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
      supabaseId: supabaseId ?? this.supabaseId,
      userId: userId ?? this.userId,
    );
  }
}
