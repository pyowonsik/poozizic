/// 사용자 Entity
class UserEntity {
  /// 사용자 Entity 생성자
  const UserEntity({
    required this.id,
    required this.email,
    required this.createdAt,
    this.displayName,
  });

  /// 사용자 ID
  final String id;

  /// 사용자 이메일
  final String email;

  /// 사용자 표시 이름
  final String? displayName;

  /// 생성 시간
  final DateTime createdAt;

  /// 사용자 엔티티 복사
  UserEntity copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
