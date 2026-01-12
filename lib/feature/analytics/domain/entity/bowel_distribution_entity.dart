/// 배변 상태 분포 엔티티
class BowelDistributionEntity {
  /// 배변 상태 분포 엔티티
  const BowelDistributionEntity({
    required this.type1_2Count,
    required this.type3_4Count,
    required this.type5_6Count,
    required this.type7Count,
  });

  /// 딱딱 (변비) - Type 1-2
  final int type1_2Count;

  /// 정상 - Type 3-4
  final int type3_4Count;

  /// 무른 - Type 5-6
  final int type5_6Count;

  /// 설사 - Type 7
  final int type7Count;

  /// 전체 기록 수
  int get total => type1_2Count + type3_4Count + type5_6Count + type7Count;

  /// 정상 비율
  double get normalRatio => total > 0 ? (type3_4Count / total) * 100 : 0;

  /// 각 타입별 비율 (파이 차트용)
  double get type1_2Ratio => total > 0 ? type1_2Count / total : 0;

  /// 정상 - Type 3-4
  double get type3_4Ratio => total > 0 ? type3_4Count / total : 0;

  /// 무른 - Type 5-6
  double get type5_6Ratio => total > 0 ? type5_6Count / total : 0;

  /// 설사 - Type 7
  double get type7Ratio => total > 0 ? type7Count / total : 0;

  /// 각 타입별 표시 텍스트
  String get type1_2Text => '$type1_2Count회';

  /// 정상 - Type 3-4
  String get type3_4Text => '$type3_4Count회';

  /// 무른 - Type 5-6
  String get type5_6Text => '$type5_6Count회';

  /// 설사 - Type 7
  String get type7Text => '$type7Count회';
}
