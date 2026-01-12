import 'package:poozizic/feature/auth/domain/entity/user_entity.dart';

/// 사용자 모델
class UserModel extends UserEntity {
  /// 사용자 모델 생성자
  const UserModel({
    required super.id,
    required super.email,
    required super.createdAt,
    super.displayName,
  });

  /// JSON에서 사용자 모델 생성
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['display_name'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Entity에서 모델 생성
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      displayName: entity.displayName,
      createdAt: entity.createdAt,
    );
  }

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'display_name': displayName,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
