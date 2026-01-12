# 미구현 Feature 클린 아키텍처 마이그레이션 구현 계획

**날짜**: 2026-01-10
**작성자**: Claude
**관련 연구 문서**: `thoughts/shared/research/poozizic_unimplemented_features_clean_architecture_2026-01-10.md`

---

## 요약 (Executive Summary)

### 목표
poozizic 앱의 미구현된 5개 화면에 클린 아키텍처와 Riverpod을 적용합니다.

### 대상 Feature
| Feature | 현재 상태 | 복잡도 |
|---------|----------|--------|
| WaterRecord | screens/water_record_screen.dart | 중 |
| MealRecord | screens/meal_record_screen.dart | 중 |
| ExerciseRecord | screens/exercise_record_screen.dart | 중 |
| Home | screens/home_screen.dart | 상 |
| Analytics | screens/analytics_screen.dart | 상 |

### 예상 파일 수
- **총 77개 파일** 생성 예정
- Phase 1: 41개 (WaterRecord 13 + MealRecord 14 + ExerciseRecord 14)
- Phase 2: 36개 (Home 17 + Analytics 19)

### 구현 순서
```
Phase 1 (병렬 가능) → Phase 2 (순차) → Phase 3 (통합)
```

### 핵심 패턴
- Clean Architecture: Data/Domain/Presentation 분리
- Riverpod StateNotifier + Sealed State
- UseCase 기반 비즈니스 로직
- Repository 패턴 (LocalDataSource 목업)

---

## 1. 요구사항

### 기능 개요
poozizic 앱의 미구현된 5개 화면(WaterRecord, MealRecord, ExerciseRecord, Home, Analytics)에 클린 아키텍처와 Riverpod 상태관리를 적용합니다. 이미 구현된 Record, Calendar, Settings Feature의 패턴을 동일하게 적용합니다.

### 목표
- Record Feature와 동일한 클린 아키텍처 패턴 적용
- Data/Domain/Presentation 레이어 분리
- Riverpod StateNotifier + Sealed State 패턴 적용
- 기존 UI 코드 최대한 재사용
- Feature 간 데이터 연동 (Home/Analytics에서 모든 Record 데이터 조회)

### 성공 기준
- [ ] 앱이 정상적으로 빌드 및 실행됨
- [ ] 5개 화면이 클린 아키텍처로 마이그레이션됨
- [ ] 각 기록 Feature에서 CRUD 동작 확인
- [ ] Home 화면에서 모든 기록 데이터 표시
- [ ] Analytics 화면에서 통계 데이터 표시
- [ ] 기존 screens 폴더 정리 완료

---

## 2. 기술적 접근

### 아키텍처 선택
- **Clean Architecture**: Data/Domain/Presentation 레이어 분리
- **Feature-based 구조**: feature/[feature_name]/ 구조
- **상태관리**: Riverpod StateNotifier + Sealed State

### 사용할 패키지
```yaml
dependencies:
  flutter_riverpod: ^2.6.1   # 이미 추가됨
  dartz: ^0.10.1             # 이미 추가됨
  fl_chart: ^0.69.0          # Analytics 차트용 (이미 사용 중)
```

### 전체 파일 구조
```
lib/
├── main.dart                     # 수정: import 경로 변경
├── shared/
│   └── domain/
│       ├── failure/
│       │   └── failure.dart      # 기존 유지
│       └── usecase/
│           └── usecase.dart      # 기존 유지
│
├── feature/
│   ├── record/                   # 기존 완료
│   ├── calendar/                 # 기존 완료
│   ├── settings/                 # 기존 완료
│   │
│   ├── water_record/             # Phase 1에서 구현
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── water_record_local_datasource.dart
│   │   │   └── repository/
│   │   │       └── water_record_repository_impl.dart
│   │   ├── di/
│   │   │   └── water_record_providers.dart
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── water_record_entity.dart
│   │   │   ├── failure/
│   │   │   │   └── water_record_failure.dart
│   │   │   ├── repository/
│   │   │   │   └── water_record_repository.dart
│   │   │   └── usecase/
│   │   │       ├── create_water_record_usecase.dart
│   │   │       └── get_water_records_by_date_usecase.dart
│   │   └── presentation/
│   │       ├── page/
│   │       │   └── water_record_page.dart
│   │       ├── provider/
│   │       │   ├── water_record_form_notifier.dart
│   │       │   └── water_record_form_state.dart
│   │       └── widget/
│   │           ├── water_amount_card.dart
│   │           └── preset_grid.dart
│   │
│   ├── meal_record/              # Phase 1에서 구현
│   │   └── ... (동일 구조)
│   │
│   ├── exercise_record/          # Phase 1에서 구현
│   │   └── ... (동일 구조)
│   │
│   ├── home/                     # Phase 2에서 구현
│   │   └── ... (동일 구조)
│   │
│   └── analytics/                # Phase 2에서 구현
│       └── ... (동일 구조)
│
└── screens/                      # Phase 3에서 삭제
    ├── home_screen.dart          # 삭제 예정
    ├── analytics_screen.dart     # 삭제 예정
    ├── water_record_screen.dart  # 삭제 예정
    ├── meal_record_screen.dart   # 삭제 예정
    └── exercise_record_screen.dart # 삭제 예정
```

---

## 3. 구현 단계

### Phase 1: 독립적인 Record Feature 구현 (병렬 가능)

#### Phase 1.1: WaterRecord Feature
**목표**: 수분 기록 기능을 클린 아키텍처로 구현

**작업 목록**:

##### Domain Layer
- [ ] 1.1.1. `lib/feature/water_record/domain/entity/water_record_entity.dart`
  ```dart
  class WaterRecordEntity {
    final int? id;
    final DateTime dateTime;
    final int amountMl;
    final String? presetType; // cup, mug, can, bottle
    final DateTime createdAt;
    // copyWith, const constructor
  }
  ```

- [ ] 1.1.2. `lib/feature/water_record/domain/failure/water_record_failure.dart`
  ```dart
  class WaterRecordFailure extends Failure { ... }
  class CreateWaterRecordFailure extends WaterRecordFailure { ... }
  ```

- [ ] 1.1.3. `lib/feature/water_record/domain/repository/water_record_repository.dart`
  ```dart
  abstract class WaterRecordRepository {
    Future<WaterRecordEntity> createRecord(WaterRecordEntity record);
    Future<List<WaterRecordEntity>> getRecordsByDate(DateTime date);
    Future<int> getDailyTotal(DateTime date);
  }
  ```

- [ ] 1.1.4. `lib/feature/water_record/domain/usecase/create_water_record_usecase.dart`
- [ ] 1.1.5. `lib/feature/water_record/domain/usecase/get_water_records_by_date_usecase.dart`

##### Data Layer
- [ ] 1.1.6. `lib/feature/water_record/data/datasource/water_record_local_datasource.dart`
  - 목업 데이터 생성 (오늘 기준 최근 7일)
  - 프리셋: 컵(200ml), 머그컵(250ml), 캔(355ml), 물병(500ml)

- [ ] 1.1.7. `lib/feature/water_record/data/repository/water_record_repository_impl.dart`

##### Presentation Layer
- [ ] 1.1.8. `lib/feature/water_record/presentation/provider/water_record_form_state.dart`
  ```dart
  sealed class WaterRecordFormState { ... }
  class WaterRecordFormInProgress extends WaterRecordFormState {
    final double waterAmount;
    final int? selectedPreset;
  }
  class WaterRecordFormSubmitting extends WaterRecordFormState { ... }
  class WaterRecordFormSuccess extends WaterRecordFormState { ... }
  class WaterRecordFormError extends WaterRecordFormState { ... }
  ```

- [ ] 1.1.9. `lib/feature/water_record/presentation/provider/water_record_form_notifier.dart`
  ```dart
  class WaterRecordFormNotifier extends StateNotifier<WaterRecordFormState> {
    void setAmount(double amount);
    void selectPreset(int index);
    Future<void> submit();
  }
  ```

- [ ] 1.1.10. `lib/feature/water_record/presentation/page/water_record_page.dart`
  - 기존 `water_record_screen.dart` UI 재사용
  - ConsumerStatefulWidget 변환

- [ ] 1.1.11. `lib/feature/water_record/presentation/widget/water_amount_card.dart`
- [ ] 1.1.12. `lib/feature/water_record/presentation/widget/preset_grid.dart`

##### DI Layer
- [ ] 1.1.13. `lib/feature/water_record/di/water_record_providers.dart`
  ```dart
  final waterRecordLocalDataSourceProvider = Provider<...>((ref) => ...);
  final waterRecordRepositoryProvider = Provider<...>((ref) => ...);
  final createWaterRecordUseCaseProvider = Provider<...>((ref) => ...);
  final waterRecordFormNotifierProvider = StateNotifierProvider.autoDispose<...>((ref) => ...);
  ```

**생성 파일**: 13개

**검증 방법**:
- [ ] WaterRecord 화면 진입 시 정상 렌더링
- [ ] 슬라이더로 수분량 조절 가능
- [ ] 프리셋 버튼 선택 시 수분량 변경
- [ ] 기록 완료 시 성공 메시지 및 화면 닫힘

---

#### Phase 1.2: MealRecord Feature
**목표**: 식사 기록 기능을 클린 아키텍처로 구현

**작업 목록**:

##### Domain Layer
- [ ] 1.2.1. `lib/feature/meal_record/domain/entity/meal_record_entity.dart`
  ```dart
  class MealRecordEntity {
    final int? id;
    final DateTime dateTime;
    final int mealType;        // 0: 아침, 1: 점심, 2: 저녁, 3: 간식
    final List<String> foods;
    final int fiberLevel;      // 0: 많음, 1: 보통, 2: 적음
    final DateTime createdAt;
    // getter: mealTypeName, fiberLevelName
  }
  ```

- [ ] 1.2.2. `lib/feature/meal_record/domain/failure/meal_record_failure.dart`
- [ ] 1.2.3. `lib/feature/meal_record/domain/repository/meal_record_repository.dart`
- [ ] 1.2.4. `lib/feature/meal_record/domain/usecase/create_meal_record_usecase.dart`
- [ ] 1.2.5. `lib/feature/meal_record/domain/usecase/get_meal_records_by_date_usecase.dart`

##### Data Layer
- [ ] 1.2.6. `lib/feature/meal_record/data/datasource/meal_record_local_datasource.dart`
- [ ] 1.2.7. `lib/feature/meal_record/data/repository/meal_record_repository_impl.dart`

##### Presentation Layer
- [ ] 1.2.8. `lib/feature/meal_record/presentation/provider/meal_record_form_state.dart`
  ```dart
  sealed class MealRecordFormState { ... }
  class MealRecordFormInProgress extends MealRecordFormState {
    final int selectedMealType;
    final List<String> foods;
    final int? selectedFiber;
    bool get canSubmit => foods.isNotEmpty && selectedFiber != null;
  }
  ```

- [ ] 1.2.9. `lib/feature/meal_record/presentation/provider/meal_record_form_notifier.dart`
  ```dart
  class MealRecordFormNotifier extends StateNotifier<MealRecordFormState> {
    void selectMealType(int type);
    void addFood(String food);
    void removeFood(String food);
    void selectFiber(int level);
    Future<void> submit();
  }
  ```

- [ ] 1.2.10. `lib/feature/meal_record/presentation/page/meal_record_page.dart`
- [ ] 1.2.11. `lib/feature/meal_record/presentation/widget/meal_type_selector.dart`
- [ ] 1.2.12. `lib/feature/meal_record/presentation/widget/food_input_section.dart`
- [ ] 1.2.13. `lib/feature/meal_record/presentation/widget/fiber_level_selector.dart`

##### DI Layer
- [ ] 1.2.14. `lib/feature/meal_record/di/meal_record_providers.dart`

**생성 파일**: 14개

**검증 방법**:
- [ ] MealRecord 화면 진입 시 정상 렌더링
- [ ] 식사 구분 선택 가능
- [ ] 음식 추가/삭제 가능
- [ ] 식이섬유 함량 선택 가능
- [ ] 필수 입력 미완료 시 버튼 비활성화
- [ ] 기록 완료 시 성공 메시지

---

#### Phase 1.3: ExerciseRecord Feature
**목표**: 운동 기록 기능을 클린 아키텍처로 구현

**작업 목록**:

##### Domain Layer
- [ ] 1.3.1. `lib/feature/exercise_record/domain/entity/exercise_record_entity.dart`
  ```dart
  class ExerciseRecordEntity {
    final int? id;
    final DateTime dateTime;
    final int exerciseType;    // 0-5 (달리기, 걷기, 자전거, 수영, 요가, 웨이트)
    final int durationMinutes;
    final int intensity;       // 0: 가볍게, 1: 보통, 2: 격하게
    final DateTime createdAt;
  }
  ```

- [ ] 1.3.2. `lib/feature/exercise_record/domain/failure/exercise_record_failure.dart`
- [ ] 1.3.3. `lib/feature/exercise_record/domain/repository/exercise_record_repository.dart`
- [ ] 1.3.4. `lib/feature/exercise_record/domain/usecase/create_exercise_record_usecase.dart`
- [ ] 1.3.5. `lib/feature/exercise_record/domain/usecase/get_exercise_records_by_date_usecase.dart`

##### Data Layer
- [ ] 1.3.6. `lib/feature/exercise_record/data/datasource/exercise_record_local_datasource.dart`
- [ ] 1.3.7. `lib/feature/exercise_record/data/repository/exercise_record_repository_impl.dart`

##### Presentation Layer
- [ ] 1.3.8. `lib/feature/exercise_record/presentation/provider/exercise_record_form_state.dart`
  ```dart
  sealed class ExerciseRecordFormState { ... }
  class ExerciseRecordFormInProgress extends ExerciseRecordFormState {
    final int? selectedExercise;
    final double duration;
    final int? selectedIntensity;
    bool get canSubmit => selectedExercise != null && selectedIntensity != null;
  }
  ```

- [ ] 1.3.9. `lib/feature/exercise_record/presentation/provider/exercise_record_form_notifier.dart`
- [ ] 1.3.10. `lib/feature/exercise_record/presentation/page/exercise_record_page.dart`
- [ ] 1.3.11. `lib/feature/exercise_record/presentation/widget/exercise_type_grid.dart`
- [ ] 1.3.12. `lib/feature/exercise_record/presentation/widget/duration_slider.dart`
- [ ] 1.3.13. `lib/feature/exercise_record/presentation/widget/intensity_selector.dart`

##### DI Layer
- [ ] 1.3.14. `lib/feature/exercise_record/di/exercise_record_providers.dart`

**생성 파일**: 14개

**검증 방법**:
- [ ] ExerciseRecord 화면 진입 시 정상 렌더링
- [ ] 운동 종류 선택 가능
- [ ] 시간 슬라이더 조절 가능
- [ ] 빠른 시간 버튼 동작
- [ ] 강도 선택 가능
- [ ] 필수 선택 미완료 시 버튼 비활성화

---

### Phase 2: 의존성 있는 Feature 구현

#### Phase 2.1: Home Feature
**목표**: 홈 화면을 클린 아키텍처로 구현 (모든 Record Feature 의존)

**의존성**: Phase 1 완료 필요 (모든 Record Repository 사용)

**작업 목록**:

##### Domain Layer
- [ ] 2.1.1. `lib/feature/home/domain/entity/daily_summary_entity.dart`
  ```dart
  class DailySummaryEntity {
    final DateTime date;
    final DateTime? lastBowelTime;
    final int consecutiveDays;
    final int weeklyBowelCount;
    final int waterIntakeMl;
    final int waterGoalMl;

    double get waterProgress => waterGoalMl > 0 ? waterIntakeMl / waterGoalMl : 0;
    String get lastBowelText => _formatTimeDiff(lastBowelTime);
  }
  ```

- [ ] 2.1.2. `lib/feature/home/domain/entity/health_score_entity.dart`
  ```dart
  class HealthScoreEntity {
    final int totalScore;
    final int bowelConditionScore;    // /30
    final int bowelRegularityScore;   // /25
    final int waterIntakeScore;       // /20
    final int bowelComfortScore;      // /15
    final int bowelFrequencyScore;    // /10
    final List<String> positiveFeedbacks;
    final List<String> negativeFeedbacks;
  }
  ```

- [ ] 2.1.3. `lib/feature/home/domain/entity/recent_record_entity.dart`
  ```dart
  enum RecordType { bowel, meal, water, exercise }

  class RecentRecordEntity {
    final RecordType type;
    final String emoji;
    final String title;
    final String subtitle;
    final String time;
    final Color backgroundColor;
  }
  ```

- [ ] 2.1.4. `lib/feature/home/domain/failure/home_failure.dart`
- [ ] 2.1.5. `lib/feature/home/domain/repository/home_repository.dart`
  ```dart
  abstract class HomeRepository {
    Future<DailySummaryEntity> getDailySummary(DateTime date);
    Future<HealthScoreEntity> getHealthScore(DateTime date);
    Future<List<RecentRecordEntity>> getRecentRecords(DateTime date);
  }
  ```

- [ ] 2.1.6. `lib/feature/home/domain/usecase/get_daily_summary_usecase.dart`
- [ ] 2.1.7. `lib/feature/home/domain/usecase/get_health_score_usecase.dart`
- [ ] 2.1.8. `lib/feature/home/domain/usecase/get_recent_records_usecase.dart`

##### Data Layer
- [ ] 2.1.9. `lib/feature/home/data/repository/home_repository_impl.dart`
  - RecordRepository, WaterRecordRepository, MealRecordRepository, ExerciseRecordRepository 의존
  - 각 Repository에서 데이터 조회 후 조합

##### Presentation Layer
- [ ] 2.1.10. `lib/feature/home/presentation/provider/home_state.dart`
  ```dart
  sealed class HomeState { ... }
  class HomeLoading extends HomeState { ... }
  class HomeLoaded extends HomeState {
    final DateTime selectedDate;
    final DailySummaryEntity summary;
    final HealthScoreEntity healthScore;
    final List<RecentRecordEntity> recentRecords;
    final bool isHealthScoreExpanded;
  }
  class HomeError extends HomeState { ... }
  ```

- [ ] 2.1.11. `lib/feature/home/presentation/provider/home_notifier.dart`
  ```dart
  class HomeNotifier extends StateNotifier<HomeState> {
    void selectDate(DateTime date);
    void toggleHealthScoreExpanded();
    Future<void> loadData();
  }
  ```

- [ ] 2.1.12. `lib/feature/home/presentation/page/home_page.dart`
- [ ] 2.1.13. `lib/feature/home/presentation/widget/today_status_card.dart`
- [ ] 2.1.14. `lib/feature/home/presentation/widget/water_progress_section.dart`
- [ ] 2.1.15. `lib/feature/home/presentation/widget/health_score_card.dart`
- [ ] 2.1.16. `lib/feature/home/presentation/widget/recent_records_section.dart`

##### DI Layer
- [ ] 2.1.17. `lib/feature/home/di/home_providers.dart`
  ```dart
  final homeRepositoryProvider = Provider<HomeRepository>((ref) {
    final recordRepo = ref.watch(recordRepositoryProvider);
    final waterRepo = ref.watch(waterRecordRepositoryProvider);
    final mealRepo = ref.watch(mealRecordRepositoryProvider);
    final exerciseRepo = ref.watch(exerciseRecordRepositoryProvider);
    return HomeRepositoryImpl(recordRepo, waterRepo, mealRepo, exerciseRepo);
  });

  final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
    // autoDispose 사용하지 않음 (메인 화면)
  });
  ```

**생성 파일**: 17개

**검증 방법**:
- [ ] Home 화면 진입 시 정상 렌더링
- [ ] 오늘의 상태 표시 (마지막 배변, 연속 기록, 주간 배변)
- [ ] 수분 섭취 진행률 표시
- [ ] 건강 점수 카드 토글
- [ ] 날짜 변경 시 데이터 갱신
- [ ] 최근 기록 표시 (배변, 식사, 수분, 운동)
- [ ] 기록 추가 후 Home 화면 자동 갱신

---

#### Phase 2.2: Analytics Feature
**목표**: 분석 화면을 클린 아키텍처로 구현 (Record Feature 의존)

**의존성**: Phase 1 완료 필요

**작업 목록**:

##### Domain Layer
- [ ] 2.2.1. `lib/feature/analytics/domain/entity/analytics_summary_entity.dart`
  ```dart
  class AnalyticsSummaryEntity {
    final int healthScore;
    final double normalRatio;      // 정상 비율 (%)
    final double averageInterval;  // 평균 간격 (일)
    final int period;              // 분석 기간 (일)
  }
  ```

- [ ] 2.2.2. `lib/feature/analytics/domain/entity/bowel_distribution_entity.dart`
  ```dart
  class BowelDistributionEntity {
    final int type1_2Count;  // 딱딱 (변비)
    final int type3_4Count;  // 정상
    final int type5_6Count;  // 무른
    final int type7Count;    // 설사

    int get total => ...;
    double get normalRatio => type3_4Count / total;
  }
  ```

- [ ] 2.2.3. `lib/feature/analytics/domain/entity/weekly_frequency_entity.dart`
  ```dart
  class WeeklyFrequencyEntity {
    final List<int> dailyCounts; // [월, 화, 수, 목, 금, 토, 일]
    int get totalCount => dailyCounts.fold(0, (a, b) => a + b);
  }
  ```

- [ ] 2.2.4. `lib/feature/analytics/domain/entity/insight_entity.dart`
  ```dart
  enum InsightType { positive, water, time, warning }

  class InsightEntity {
    final InsightType type;
    final String title;
    final String description;
  }
  ```

- [ ] 2.2.5. `lib/feature/analytics/domain/failure/analytics_failure.dart`
- [ ] 2.2.6. `lib/feature/analytics/domain/repository/analytics_repository.dart`
- [ ] 2.2.7. `lib/feature/analytics/domain/usecase/get_analytics_summary_usecase.dart`
- [ ] 2.2.8. `lib/feature/analytics/domain/usecase/get_bowel_distribution_usecase.dart`
- [ ] 2.2.9. `lib/feature/analytics/domain/usecase/get_weekly_frequency_usecase.dart`
- [ ] 2.2.10. `lib/feature/analytics/domain/usecase/get_insights_usecase.dart`

##### Data Layer
- [ ] 2.2.11. `lib/feature/analytics/data/repository/analytics_repository_impl.dart`
  - RecordRepository 의존
  - 최근 30일 데이터 분석

##### Presentation Layer
- [ ] 2.2.12. `lib/feature/analytics/presentation/provider/analytics_state.dart`
  ```dart
  sealed class AnalyticsState { ... }
  class AnalyticsLoading extends AnalyticsState { ... }
  class AnalyticsLoaded extends AnalyticsState {
    final AnalyticsSummaryEntity summary;
    final BowelDistributionEntity distribution;
    final WeeklyFrequencyEntity weeklyFrequency;
    final List<InsightEntity> insights;
  }
  class AnalyticsError extends AnalyticsState { ... }
  ```

- [ ] 2.2.13. `lib/feature/analytics/presentation/provider/analytics_notifier.dart`
- [ ] 2.2.14. `lib/feature/analytics/presentation/page/analytics_page.dart`
- [ ] 2.2.15. `lib/feature/analytics/presentation/widget/stat_cards_row.dart`
- [ ] 2.2.16. `lib/feature/analytics/presentation/widget/bowel_distribution_chart.dart`
- [ ] 2.2.17. `lib/feature/analytics/presentation/widget/weekly_frequency_chart.dart`
- [ ] 2.2.18. `lib/feature/analytics/presentation/widget/insight_card.dart`

##### DI Layer
- [ ] 2.2.19. `lib/feature/analytics/di/analytics_providers.dart`

**생성 파일**: 19개

**검증 방법**:
- [ ] Analytics 화면 진입 시 정상 렌더링
- [ ] 상단 통계 카드 3개 표시
- [ ] 도넛 차트 (배변 상태 분포) 정상 렌더링
- [ ] 막대 차트 (주간 빈도) 정상 렌더링
- [ ] 인사이트 카드들 표시
- [ ] 기록 추가 후 통계 자동 갱신

---

### Phase 3: 통합 및 정리

**목표**: 전체 시스템 통합, main.dart 수정, 기존 screens 폴더 정리

**의존성**: Phase 1, Phase 2 모두 완료 필요

**작업 목록**:

##### main.dart 수정
- [ ] 3.1. import 경로 변경
  ```dart
  // Before
  import 'screens/home_screen.dart';
  import 'screens/analytics_screen.dart';
  import 'screens/water_record_screen.dart';
  import 'screens/meal_record_screen.dart';
  import 'screens/exercise_record_screen.dart';

  // After
  import 'feature/home/presentation/page/home_page.dart';
  import 'feature/analytics/presentation/page/analytics_page.dart';
  import 'feature/water_record/presentation/page/water_record_page.dart';
  import 'feature/meal_record/presentation/page/meal_record_page.dart';
  import 'feature/exercise_record/presentation/page/exercise_record_page.dart';
  ```

- [ ] 3.2. _screens 리스트 수정
  ```dart
  final List<Widget> _screens = [
    const HomePage(),           // HomeScreen -> HomePage
    const CalendarPage(),       // 기존 유지
    const Center(child: Text('기록 화면')),
    const AnalyticsPage(),      // AnalyticsScreen -> AnalyticsPage
    const SettingsPage(),       // 기존 유지
  ];
  ```

- [ ] 3.3. _showQuickRecordBottomSheet 수정
  ```dart
  // WaterRecordScreen -> WaterRecordPage
  // MealRecordScreen -> MealRecordPage
  // ExerciseRecordScreen -> ExerciseRecordPage
  ```

##### 데이터 갱신 연동
- [ ] 3.4. Record 추가 시 Home/Analytics 갱신
  ```dart
  // 각 Record Feature의 success 처리에서
  void refreshRecords(WidgetRef ref) {
    ref.invalidate(recordsProvider);
    ref.invalidate(waterRecordsProvider);
    ref.invalidate(mealRecordsProvider);
    ref.invalidate(exerciseRecordsProvider);
    ref.invalidate(homeNotifierProvider);
    ref.invalidate(analyticsNotifierProvider);
  }
  ```

##### 기존 screens 폴더 정리
- [ ] 3.5. `lib/screens/home_screen.dart` 삭제
- [ ] 3.6. `lib/screens/analytics_screen.dart` 삭제
- [ ] 3.7. `lib/screens/water_record_screen.dart` 삭제
- [ ] 3.8. `lib/screens/meal_record_screen.dart` 삭제
- [ ] 3.9. `lib/screens/exercise_record_screen.dart` 삭제
- [ ] 3.10. `lib/screens/` 폴더 삭제 (모든 파일 마이그레이션 완료 시)

##### 최적화
- [ ] 3.11. const 생성자 최적화
- [ ] 3.12. 불필요한 import 정리
- [ ] 3.13. `flutter analyze` 실행 및 경고 수정

**검증 방법**:
- [ ] `flutter analyze` 경고 없음
- [ ] `flutter run` 정상 실행
- [ ] 모든 화면 네비게이션 정상
- [ ] 기록 추가 후 Home/Analytics 자동 갱신 확인

---

## 4. 리스크 및 대응

### 리스크 1: Feature 간 순환 의존성
- **확률**: Medium
- **영향도**: High
- **완화 방안**:
  - Home/Analytics는 각 Record Repository의 Provider만 의존
  - Record Feature 간에는 의존성 없음
  - 공통 데이터 갱신은 `ref.invalidate()` 사용

### 리스크 2: LocalDataSource 싱글톤 관리
- **확률**: Low
- **영향도**: Medium
- **완화 방안**:
  - 각 Feature의 LocalDataSource는 Provider에서 싱글톤으로 관리
  - `Provider<XxxLocalDataSource>`는 자동으로 한 번만 생성됨

### 리스크 3: 목업 데이터 앱 재시작 시 초기화
- **확률**: High (예상된 동작)
- **영향도**: Low
- **완화 방안**:
  - 현재 개발 단계에서는 정상 동작
  - 나중에 SharedPreferences 또는 Supabase로 전환 시 DataSource만 교체

### 리스크 4: UI 마이그레이션 시 기존 스타일 손실
- **확률**: Medium
- **영향도**: Medium
- **완화 방안**:
  - 기존 Screen의 build() 메서드 내 UI 코드 최대한 복사
  - 상태 관련 코드만 StateNotifier로 분리
  - 스타일 관련 상수는 그대로 유지

---

## 5. 전체 검증 계획

### 자동 테스트 (선택적)
- [ ] UseCase 단위 테스트
- [ ] Repository 단위 테스트
- [ ] Notifier 상태 변경 테스트

### 수동 테스트

#### 시나리오 1: 수분 기록 플로우
1. 앱 실행 → FAB(+) 버튼 클릭
2. "수분 기록" 선택
3. 슬라이더로 수분량 조절 (300ml)
4. "기록 완료" 클릭
5. 성공 메시지 확인
6. Home 화면에서 수분 섭취량 증가 확인

#### 시나리오 2: 식사 기록 플로우
1. FAB(+) 버튼 클릭 → "식사 기록" 선택
2. "점심" 선택
3. "김치찌개" 입력 후 추가
4. "밥" 입력 후 추가
5. 식이섬유 "보통" 선택
6. "기록 완료" 클릭
7. Home 화면 최근 기록에서 확인

#### 시나리오 3: 운동 기록 플로우
1. FAB(+) 버튼 클릭 → "운동 기록" 선택
2. "달리기" 선택
3. 시간 슬라이더 45분 설정
4. 강도 "보통" 선택
5. "기록 완료" 클릭

#### 시나리오 4: Home 화면 데이터 확인
1. Home 탭 진입
2. 오늘의 상태 확인 (마지막 배변 시간)
3. 수분 섭취 진행률 확인
4. 건강 점수 카드 탭 → 상세 점수 확인
5. 날짜 변경 (어제) → 데이터 변경 확인
6. 최근 기록 목록 확인

#### 시나리오 5: Analytics 화면 검증
1. 분석 탭 진입
2. 상단 통계 카드 3개 확인
3. 도넛 차트 렌더링 확인
4. 막대 차트 렌더링 확인
5. 인사이트 카드 확인
6. 배변 기록 추가 후 통계 변경 확인

### 성능 체크
- [ ] `flutter run` 빌드 시간 정상
- [ ] 화면 전환 시 지연 없음
- [ ] 메모리 누수 없음 (autoDispose 적용 확인)

---

## 6. 예상 생성 파일 요약

| Phase | Feature | 파일 수 |
|-------|---------|--------|
| 1.1 | WaterRecord | 13개 |
| 1.2 | MealRecord | 14개 |
| 1.3 | ExerciseRecord | 14개 |
| 2.1 | Home | 17개 |
| 2.2 | Analytics | 19개 |
| 3 | 통합/정리 | 0개 (수정만) |
| **합계** | - | **77개** |

---

## 7. 구현 순서 요약

```
1. Phase 1.1 ~ 1.3 (병렬 가능)
   ├── WaterRecord Feature (13개 파일)
   ├── MealRecord Feature (14개 파일)
   └── ExerciseRecord Feature (14개 파일)

2. Phase 2.1 ~ 2.2 (순차)
   ├── Home Feature (17개 파일) - 모든 Record 의존
   └── Analytics Feature (19개 파일) - Record 의존

3. Phase 3: 통합 및 정리
   ├── main.dart 수정
   ├── 데이터 갱신 연동
   └── 기존 screens 폴더 삭제
```

---

## 8. 핵심 코드 스니펫

### 8.1 WaterRecordEntity
```dart
class WaterRecordEntity {
  final int? id;
  final DateTime dateTime;
  final int amountMl;
  final String? presetType;
  final DateTime createdAt;

  const WaterRecordEntity({
    this.id,
    required this.dateTime,
    required this.amountMl,
    this.presetType,
    required this.createdAt,
  });

  WaterRecordEntity copyWith({
    int? id,
    DateTime? dateTime,
    int? amountMl,
    String? presetType,
    DateTime? createdAt,
  }) {
    return WaterRecordEntity(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      amountMl: amountMl ?? this.amountMl,
      presetType: presetType ?? this.presetType,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

### 8.2 WaterRecordFormState
```dart
sealed class WaterRecordFormState {
  const WaterRecordFormState();
}

class WaterRecordFormInProgress extends WaterRecordFormState {
  final double waterAmount;
  final int? selectedPreset;

  const WaterRecordFormInProgress({
    this.waterAmount = 250,
    this.selectedPreset = 1, // 머그컵 기본
  });

  WaterRecordFormInProgress copyWith({
    double? waterAmount,
    int? selectedPreset,
  }) {
    return WaterRecordFormInProgress(
      waterAmount: waterAmount ?? this.waterAmount,
      selectedPreset: selectedPreset,
    );
  }
}

class WaterRecordFormSubmitting extends WaterRecordFormState {
  const WaterRecordFormSubmitting();
}

class WaterRecordFormSuccess extends WaterRecordFormState {
  final WaterRecordEntity record;
  const WaterRecordFormSuccess(this.record);
}

class WaterRecordFormError extends WaterRecordFormState {
  final String message;
  const WaterRecordFormError(this.message);
}
```

### 8.3 HomeRepositoryImpl (의존성 조합 예시)
```dart
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl(
    this._recordRepository,
    this._waterRecordRepository,
    this._mealRecordRepository,
    this._exerciseRecordRepository,
  );

  final RecordRepository _recordRepository;
  final WaterRecordRepository _waterRecordRepository;
  final MealRecordRepository _mealRecordRepository;
  final ExerciseRecordRepository _exerciseRecordRepository;

  @override
  Future<DailySummaryEntity> getDailySummary(DateTime date) async {
    final records = await _recordRepository.getRecordsByDate(date);
    final waterRecords = await _waterRecordRepository.getRecordsByDate(date);

    final lastBowel = records.isNotEmpty ? records.first.dateTime : null;
    final waterTotal = waterRecords.fold(0, (sum, r) => sum + r.amountMl);

    return DailySummaryEntity(
      date: date,
      lastBowelTime: lastBowel,
      waterIntakeMl: waterTotal,
      waterGoalMl: 2000, // 설정에서 가져오기 가능
      // ... 기타 계산
    );
  }
}
```

---

## 9. 주의사항

### 9.1 ConsumerStatefulWidget vs ConsumerWidget
- **ConsumerStatefulWidget**: 로컬 상태가 필요한 경우 (TextEditingController 등)
- **ConsumerWidget**: 순수하게 Provider 상태만 사용하는 경우

### 9.2 autoDispose 사용 규칙
- **autoDispose 사용**: Form 화면들 (WaterRecord, MealRecord, ExerciseRecord)
- **autoDispose 미사용**: 메인 탭 화면들 (Home, Analytics) - 데이터 유지 필요

### 9.3 UI 코드 재사용
- 기존 Screen의 `_buildXxx()` 메서드들은 별도 Widget 클래스로 분리
- 스타일 상수 (Color, TextStyle 등)는 그대로 유지
- 상태 접근만 `ref.watch()`, `ref.read()`로 변경

### 9.4 데이터 갱신 타이밍
- Record 추가 성공 시 즉시 `ref.invalidate()` 호출
- Home/Analytics는 진입 시 자동으로 최신 데이터 로드

---

## 10. 상세 구현 가이드

### 10.1 각 Feature 구현 시 체크리스트

#### Domain Layer 구현 순서
```
1. entity/ - 데이터 모델 정의 (가장 먼저)
2. failure/ - 에러 클래스 정의
3. repository/ - 인터페이스 정의
4. usecase/ - 비즈니스 로직 정의
```

#### Data Layer 구현 순서
```
1. datasource/ - 목업 데이터 및 CRUD 메서드
2. repository/ - Repository 구현체 (DataSource 의존)
```

#### Presentation Layer 구현 순서
```
1. provider/state - Sealed State 클래스
2. provider/notifier - StateNotifier 클래스
3. widget/ - 재사용 가능한 위젯들
4. page/ - ConsumerStatefulWidget 페이지
```

#### DI Layer
```
1. providers.dart - 모든 Provider 정의 (마지막)
```

### 10.2 프리셋 상수 정의

#### WaterRecord 프리셋
```dart
// lib/feature/water_record/domain/entity/water_preset.dart
class WaterPreset {
  static const List<Map<String, dynamic>> presets = [
    {'emoji': '☕', 'label': '컵 1잔', 'amount': 200, 'type': 'cup'},
    {'emoji': '🥤', 'label': '머그컵', 'amount': 250, 'type': 'mug'},
    {'emoji': '🥫', 'label': '캔', 'amount': 355, 'type': 'can'},
    {'emoji': '🧃', 'label': '물병', 'amount': 500, 'type': 'bottle'},
  ];

  static const List<int> quickAmounts = [100, 150, 300, 750];
}
```

#### MealRecord 프리셋
```dart
// lib/feature/meal_record/domain/entity/meal_preset.dart
class MealPreset {
  static const List<Map<String, String>> mealTypes = [
    {'emoji': '🌅', 'label': '아침'},
    {'emoji': '☀️', 'label': '점심'},
    {'emoji': '🍌', 'label': '저녁'},
    {'emoji': '🍪', 'label': '간식'},
  ];

  static const List<Map<String, String>> fiberLevels = [
    {'emoji': '🥬', 'label': '많음'},
    {'emoji': '🍽️', 'label': '보통'},
    {'emoji': '🥩', 'label': '적음'},
  ];
}
```

#### ExerciseRecord 프리셋
```dart
// lib/feature/exercise_record/domain/entity/exercise_preset.dart
class ExercisePreset {
  static const List<Map<String, String>> exercises = [
    {'emoji': '🏃', 'label': '달리기'},
    {'emoji': '🚶', 'label': '걷기'},
    {'emoji': '🚴', 'label': '자전거'},
    {'emoji': '🏊', 'label': '수영'},
    {'emoji': '🧘', 'label': '요가'},
    {'emoji': '🏋️', 'label': '웨이트'},
  ];

  static const List<Map<String, String>> intensities = [
    {'emoji': '😌', 'label': '가볍게'},
    {'emoji': '💪', 'label': '보통'},
    {'emoji': '🔥', 'label': '격하게'},
  ];

  static const List<int> quickDurations = [15, 30, 45, 60];
}
```

### 10.3 목업 데이터 생성 가이드

#### WaterRecord 목업 데이터
```dart
List<WaterRecordEntity> _generateMockData() {
  final now = DateTime.now();
  final records = <WaterRecordEntity>[];
  int id = 1;

  // 오늘 기록 (6회)
  records.addAll([
    WaterRecordEntity(id: id++, dateTime: DateTime(now.year, now.month, now.day, 7, 0), amountMl: 200, presetType: 'cup', createdAt: ...),
    WaterRecordEntity(id: id++, dateTime: DateTime(now.year, now.month, now.day, 9, 30), amountMl: 250, presetType: 'mug', createdAt: ...),
    // ... 총 1500ml 정도
  ]);

  // 최근 7일 각 1000~2000ml 랜덤 기록
  for (int day = 1; day <= 7; day++) {
    final date = now.subtract(Duration(days: day));
    // 3~5회 기록 추가
  }

  return records;
}
```

### 10.4 Home 화면 데이터 계산 로직

#### 마지막 배변 시간 계산
```dart
String _formatLastBowelTime(DateTime? lastBowelTime) {
  if (lastBowelTime == null) return '기록 없음';

  final now = DateTime.now();
  final diff = now.difference(lastBowelTime);

  if (diff.inMinutes < 60) {
    return '${diff.inMinutes}분 전';
  } else if (diff.inHours < 24) {
    return '${diff.inHours}시간 전';
  } else {
    return '${diff.inDays}일 전';
  }
}
```

#### 연속 기록 일수 계산
```dart
int _calculateConsecutiveDays(List<RecordEntity> records) {
  if (records.isEmpty) return 0;

  final today = DateTime.now();
  final recordDates = records
      .map((r) => DateTime(r.dateTime.year, r.dateTime.month, r.dateTime.day))
      .toSet()
      .toList()
    ..sort((a, b) => b.compareTo(a));

  int count = 0;
  DateTime checkDate = DateTime(today.year, today.month, today.day);

  for (final date in recordDates) {
    if (date == checkDate) {
      count++;
      checkDate = checkDate.subtract(const Duration(days: 1));
    } else {
      break;
    }
  }

  return count;
}
```

### 10.5 Analytics 통계 계산 로직

#### 배변 상태 분포 계산
```dart
BowelDistributionEntity _calculateDistribution(List<RecordEntity> records) {
  int type1_2 = 0, type3_4 = 0, type5_6 = 0, type7 = 0;

  for (final record in records) {
    switch (record.bristolType) {
      case 1:
      case 2:
        type1_2++;
        break;
      case 3:
      case 4:
        type3_4++;
        break;
      case 5:
      case 6:
        type5_6++;
        break;
      case 7:
        type7++;
        break;
    }
  }

  return BowelDistributionEntity(
    type1_2Count: type1_2,
    type3_4Count: type3_4,
    type5_6Count: type5_6,
    type7Count: type7,
  );
}
```

#### 주간 빈도 계산
```dart
WeeklyFrequencyEntity _calculateWeeklyFrequency(List<RecordEntity> records) {
  final now = DateTime.now();
  final weekStart = now.subtract(Duration(days: now.weekday - 1)); // 이번 주 월요일

  final dailyCounts = List<int>.filled(7, 0);

  for (final record in records) {
    final recordDate = DateTime(record.dateTime.year, record.dateTime.month, record.dateTime.day);
    final diff = recordDate.difference(weekStart).inDays;
    if (diff >= 0 && diff < 7) {
      dailyCounts[diff]++;
    }
  }

  return WeeklyFrequencyEntity(dailyCounts: dailyCounts);
}
```

---

## 11. 실행 명령어

### Phase 1 완료 후 검증
```bash
cd /Users/pyowonsik/Downloads/workspace/poozizic
flutter analyze
flutter run
```

### 각 Phase 완료 후
```bash
flutter analyze    # 정적 분석
flutter run        # 실행 테스트
```

### 전체 완료 후
```bash
flutter analyze
flutter test       # 테스트 작성 시
flutter build ios  # iOS 빌드 테스트
flutter build apk  # Android 빌드 테스트
```

---

## 12. 구현 순서 상세 (권장)

### Day 1: Phase 1.1 WaterRecord
1. Domain Layer 전체 (5개 파일)
2. Data Layer 전체 (2개 파일)
3. Presentation Layer 전체 (5개 파일)
4. DI Layer (1개 파일)
5. 검증: WaterRecord 화면 테스트

### Day 2: Phase 1.2 MealRecord
1. Domain Layer 전체
2. Data Layer 전체
3. Presentation Layer 전체
4. DI Layer
5. 검증: MealRecord 화면 테스트

### Day 3: Phase 1.3 ExerciseRecord
1. Domain Layer 전체
2. Data Layer 전체
3. Presentation Layer 전체
4. DI Layer
5. 검증: ExerciseRecord 화면 테스트

### Day 4: Phase 2.1 Home
1. Domain Layer (3개 Entity, 4개 UseCase)
2. Data Layer (HomeRepositoryImpl)
3. Presentation Layer (State, Notifier, Page, 4개 Widget)
4. DI Layer
5. 검증: Home 화면 테스트

### Day 5: Phase 2.2 Analytics
1. Domain Layer (4개 Entity, 4개 UseCase)
2. Data Layer (AnalyticsRepositoryImpl)
3. Presentation Layer (State, Notifier, Page, 4개 Widget)
4. DI Layer
5. 검증: Analytics 화면 테스트

### Day 6: Phase 3 통합
1. main.dart 수정
2. 데이터 갱신 연동 테스트
3. 기존 screens 폴더 삭제
4. flutter analyze 및 최종 검증

---

## 13. 에러 처리 패턴

### 13.1 Failure 클래스 계층 구조
```dart
// shared/domain/failure/failure.dart (기존)
abstract class Failure {
  const Failure(this.message, {this.exception, this.stackTrace});
  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;
}

// feature/water_record/domain/failure/water_record_failure.dart
class WaterRecordFailure extends Failure {
  const WaterRecordFailure(super.message, {super.exception, super.stackTrace});

  factory WaterRecordFailure.invalidAmount() =>
      const WaterRecordFailure('수분량은 50ml에서 1000ml 사이여야 합니다');

  factory WaterRecordFailure.createFailed(Exception e) =>
      WaterRecordFailure('수분 기록 저장에 실패했습니다', exception: e);
}
```

### 13.2 UseCase에서 에러 처리
```dart
@override
Future<Either<Failure, WaterRecordEntity>> call(CreateWaterRecordParams params) async {
  try {
    // 유효성 검사
    if (params.amountMl < 50 || params.amountMl > 1000) {
      return Left(WaterRecordFailure.invalidAmount());
    }

    final record = WaterRecordEntity(
      dateTime: DateTime.now(),
      amountMl: params.amountMl,
      presetType: params.presetType,
      createdAt: DateTime.now(),
    );

    final result = await repository.createRecord(record);
    return Right(result);
  } on Exception catch (e, stackTrace) {
    return Left(WaterRecordFailure.createFailed(e));
  }
}
```

### 13.3 Notifier에서 에러 상태 처리
```dart
Future<void> submit() async {
  final currentState = state;
  if (currentState is! WaterRecordFormInProgress) return;

  state = const WaterRecordFormSubmitting();

  final result = await _createWaterRecordUseCase(
    CreateWaterRecordParams(
      amountMl: currentState.waterAmount.toInt(),
      presetType: _getPresetType(currentState.selectedPreset),
    ),
  );

  result.fold(
    (failure) => state = WaterRecordFormError(failure.message),
    (record) => state = WaterRecordFormSuccess(record),
  );
}
```

### 13.4 UI에서 에러 표시
```dart
@override
Widget build(BuildContext context) {
  final state = ref.watch(waterRecordFormNotifierProvider);

  ref.listen<WaterRecordFormState>(
    waterRecordFormNotifierProvider,
    (previous, next) {
      if (next is WaterRecordFormError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message),
            backgroundColor: Colors.red,
          ),
        );
      } else if (next is WaterRecordFormSuccess) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${next.record.amountMl}ml가 기록되었습니다'),
            backgroundColor: const Color(0xFF4CAF50),
          ),
        );
      }
    },
  );

  return switch (state) {
    WaterRecordFormInProgress() => _buildForm(state),
    WaterRecordFormSubmitting() => _buildLoading(),
    WaterRecordFormSuccess() => const SizedBox.shrink(),
    WaterRecordFormError() => _buildForm(state as WaterRecordFormInProgress),
  };
}
```

---

## 14. 테스트 케이스 (선택적)

### 14.1 Entity 테스트
```dart
// test/feature/water_record/domain/entity/water_record_entity_test.dart
void main() {
  group('WaterRecordEntity', () {
    test('should create entity with required fields', () {
      final entity = WaterRecordEntity(
        dateTime: DateTime.now(),
        amountMl: 250,
        createdAt: DateTime.now(),
      );

      expect(entity.amountMl, 250);
      expect(entity.presetType, isNull);
    });

    test('copyWith should create new instance with updated values', () {
      final original = WaterRecordEntity(
        id: 1,
        dateTime: DateTime.now(),
        amountMl: 250,
        createdAt: DateTime.now(),
      );

      final updated = original.copyWith(amountMl: 500);

      expect(updated.amountMl, 500);
      expect(updated.id, 1);
    });
  });
}
```

### 14.2 UseCase 테스트
```dart
// test/feature/water_record/domain/usecase/create_water_record_usecase_test.dart
void main() {
  late CreateWaterRecordUseCase useCase;
  late MockWaterRecordRepository mockRepository;

  setUp(() {
    mockRepository = MockWaterRecordRepository();
    useCase = CreateWaterRecordUseCase(mockRepository);
  });

  group('CreateWaterRecordUseCase', () {
    test('should return Right with entity when successful', () async {
      when(mockRepository.createRecord(any)).thenAnswer(
        (_) async => WaterRecordEntity(
          id: 1,
          dateTime: DateTime.now(),
          amountMl: 250,
          createdAt: DateTime.now(),
        ),
      );

      final result = await useCase(const CreateWaterRecordParams(amountMl: 250));

      expect(result.isRight(), true);
    });

    test('should return Left with failure when amount is invalid', () async {
      final result = await useCase(const CreateWaterRecordParams(amountMl: 30));

      expect(result.isLeft(), true);
    });
  });
}
```

### 14.3 Notifier 테스트
```dart
// test/feature/water_record/presentation/provider/water_record_form_notifier_test.dart
void main() {
  late WaterRecordFormNotifier notifier;
  late MockCreateWaterRecordUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockCreateWaterRecordUseCase();
    notifier = WaterRecordFormNotifier(mockUseCase);
  });

  group('WaterRecordFormNotifier', () {
    test('initial state should be InProgress with default values', () {
      expect(notifier.state, isA<WaterRecordFormInProgress>());
      final state = notifier.state as WaterRecordFormInProgress;
      expect(state.waterAmount, 250);
      expect(state.selectedPreset, 1);
    });

    test('setAmount should update waterAmount', () {
      notifier.setAmount(500);

      final state = notifier.state as WaterRecordFormInProgress;
      expect(state.waterAmount, 500);
      expect(state.selectedPreset, isNull);
    });

    test('selectPreset should update both selectedPreset and waterAmount', () {
      notifier.selectPreset(0); // 컵 200ml

      final state = notifier.state as WaterRecordFormInProgress;
      expect(state.selectedPreset, 0);
      expect(state.waterAmount, 200);
    });
  });
}
```

---

## 15. 파일 생성 순서 체크리스트

### Phase 1.1: WaterRecord (13개 파일)
```
[ ] 1. lib/feature/water_record/domain/entity/water_record_entity.dart
[ ] 2. lib/feature/water_record/domain/entity/water_preset.dart
[ ] 3. lib/feature/water_record/domain/failure/water_record_failure.dart
[ ] 4. lib/feature/water_record/domain/repository/water_record_repository.dart
[ ] 5. lib/feature/water_record/domain/usecase/create_water_record_usecase.dart
[ ] 6. lib/feature/water_record/domain/usecase/get_water_records_by_date_usecase.dart
[ ] 7. lib/feature/water_record/data/datasource/water_record_local_datasource.dart
[ ] 8. lib/feature/water_record/data/repository/water_record_repository_impl.dart
[ ] 9. lib/feature/water_record/presentation/provider/water_record_form_state.dart
[ ] 10. lib/feature/water_record/presentation/provider/water_record_form_notifier.dart
[ ] 11. lib/feature/water_record/presentation/widget/water_amount_card.dart
[ ] 12. lib/feature/water_record/presentation/widget/preset_grid.dart
[ ] 13. lib/feature/water_record/presentation/page/water_record_page.dart
[ ] 14. lib/feature/water_record/di/water_record_providers.dart
```

### Phase 1.2: MealRecord (14개 파일)
```
[ ] 1. lib/feature/meal_record/domain/entity/meal_record_entity.dart
[ ] 2. lib/feature/meal_record/domain/entity/meal_preset.dart
[ ] 3. lib/feature/meal_record/domain/failure/meal_record_failure.dart
[ ] 4. lib/feature/meal_record/domain/repository/meal_record_repository.dart
[ ] 5. lib/feature/meal_record/domain/usecase/create_meal_record_usecase.dart
[ ] 6. lib/feature/meal_record/domain/usecase/get_meal_records_by_date_usecase.dart
[ ] 7. lib/feature/meal_record/data/datasource/meal_record_local_datasource.dart
[ ] 8. lib/feature/meal_record/data/repository/meal_record_repository_impl.dart
[ ] 9. lib/feature/meal_record/presentation/provider/meal_record_form_state.dart
[ ] 10. lib/feature/meal_record/presentation/provider/meal_record_form_notifier.dart
[ ] 11. lib/feature/meal_record/presentation/widget/meal_type_selector.dart
[ ] 12. lib/feature/meal_record/presentation/widget/food_input_section.dart
[ ] 13. lib/feature/meal_record/presentation/widget/fiber_level_selector.dart
[ ] 14. lib/feature/meal_record/presentation/page/meal_record_page.dart
[ ] 15. lib/feature/meal_record/di/meal_record_providers.dart
```

### Phase 1.3: ExerciseRecord (14개 파일)
```
[ ] 1. lib/feature/exercise_record/domain/entity/exercise_record_entity.dart
[ ] 2. lib/feature/exercise_record/domain/entity/exercise_preset.dart
[ ] 3. lib/feature/exercise_record/domain/failure/exercise_record_failure.dart
[ ] 4. lib/feature/exercise_record/domain/repository/exercise_record_repository.dart
[ ] 5. lib/feature/exercise_record/domain/usecase/create_exercise_record_usecase.dart
[ ] 6. lib/feature/exercise_record/domain/usecase/get_exercise_records_by_date_usecase.dart
[ ] 7. lib/feature/exercise_record/data/datasource/exercise_record_local_datasource.dart
[ ] 8. lib/feature/exercise_record/data/repository/exercise_record_repository_impl.dart
[ ] 9. lib/feature/exercise_record/presentation/provider/exercise_record_form_state.dart
[ ] 10. lib/feature/exercise_record/presentation/provider/exercise_record_form_notifier.dart
[ ] 11. lib/feature/exercise_record/presentation/widget/exercise_type_grid.dart
[ ] 12. lib/feature/exercise_record/presentation/widget/duration_slider.dart
[ ] 13. lib/feature/exercise_record/presentation/widget/intensity_selector.dart
[ ] 14. lib/feature/exercise_record/presentation/page/exercise_record_page.dart
[ ] 15. lib/feature/exercise_record/di/exercise_record_providers.dart
```

### Phase 2.1: Home (17개 파일)
```
[ ] 1. lib/feature/home/domain/entity/daily_summary_entity.dart
[ ] 2. lib/feature/home/domain/entity/health_score_entity.dart
[ ] 3. lib/feature/home/domain/entity/recent_record_entity.dart
[ ] 4. lib/feature/home/domain/failure/home_failure.dart
[ ] 5. lib/feature/home/domain/repository/home_repository.dart
[ ] 6. lib/feature/home/domain/usecase/get_daily_summary_usecase.dart
[ ] 7. lib/feature/home/domain/usecase/get_health_score_usecase.dart
[ ] 8. lib/feature/home/domain/usecase/get_recent_records_usecase.dart
[ ] 9. lib/feature/home/data/repository/home_repository_impl.dart
[ ] 10. lib/feature/home/presentation/provider/home_state.dart
[ ] 11. lib/feature/home/presentation/provider/home_notifier.dart
[ ] 12. lib/feature/home/presentation/widget/today_status_card.dart
[ ] 13. lib/feature/home/presentation/widget/water_progress_section.dart
[ ] 14. lib/feature/home/presentation/widget/health_score_card.dart
[ ] 15. lib/feature/home/presentation/widget/recent_records_section.dart
[ ] 16. lib/feature/home/presentation/page/home_page.dart
[ ] 17. lib/feature/home/di/home_providers.dart
```

### Phase 2.2: Analytics (19개 파일)
```
[ ] 1. lib/feature/analytics/domain/entity/analytics_summary_entity.dart
[ ] 2. lib/feature/analytics/domain/entity/bowel_distribution_entity.dart
[ ] 3. lib/feature/analytics/domain/entity/weekly_frequency_entity.dart
[ ] 4. lib/feature/analytics/domain/entity/insight_entity.dart
[ ] 5. lib/feature/analytics/domain/failure/analytics_failure.dart
[ ] 6. lib/feature/analytics/domain/repository/analytics_repository.dart
[ ] 7. lib/feature/analytics/domain/usecase/get_analytics_summary_usecase.dart
[ ] 8. lib/feature/analytics/domain/usecase/get_bowel_distribution_usecase.dart
[ ] 9. lib/feature/analytics/domain/usecase/get_weekly_frequency_usecase.dart
[ ] 10. lib/feature/analytics/domain/usecase/get_insights_usecase.dart
[ ] 11. lib/feature/analytics/data/repository/analytics_repository_impl.dart
[ ] 12. lib/feature/analytics/presentation/provider/analytics_state.dart
[ ] 13. lib/feature/analytics/presentation/provider/analytics_notifier.dart
[ ] 14. lib/feature/analytics/presentation/widget/stat_cards_row.dart
[ ] 15. lib/feature/analytics/presentation/widget/bowel_distribution_chart.dart
[ ] 16. lib/feature/analytics/presentation/widget/weekly_frequency_chart.dart
[ ] 17. lib/feature/analytics/presentation/widget/insight_card.dart
[ ] 18. lib/feature/analytics/presentation/page/analytics_page.dart
[ ] 19. lib/feature/analytics/di/analytics_providers.dart
```

### Phase 3: 통합 (수정만)
```
[ ] 1. lib/main.dart - import 및 참조 수정
[ ] 2. 기존 lib/screens/ 폴더 삭제
```

---

## 16. Provider 간 의존성 상세

### 16.1 전체 Provider 의존성 다이어그램
```
                    ┌─────────────────────────────┐
                    │   shared/domain             │
                    │   - Failure (base class)    │
                    │   - UseCase (interface)     │
                    └─────────────┬───────────────┘
                                  │
    ┌─────────────────────────────┼─────────────────────────────┐
    │                             │                             │
    ▼                             ▼                             ▼
┌────────────────┐    ┌────────────────┐    ┌────────────────┐
│ RecordProviders │    │ WaterProviders │    │ MealProviders  │
│ (기존)          │    │ (Phase 1.1)    │    │ (Phase 1.2)    │
└────────┬───────┘    └────────┬───────┘    └────────┬───────┘
         │                     │                     │
         │              ┌──────┴──────┐             │
         │              │             │             │
         │              ▼             │             │
         │      ┌────────────────┐   │             │
         │      │ExerciseProviders│   │             │
         │      │ (Phase 1.3)    │   │             │
         │      └────────┬───────┘   │             │
         │               │           │             │
         └───────────────┴───────────┴─────────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
                    ▼                           ▼
            ┌────────────────┐         ┌────────────────┐
            │ HomeProviders  │         │AnalyticsProviders│
            │ (Phase 2.1)    │         │ (Phase 2.2)      │
            └────────────────┘         └──────────────────┘
```

### 16.2 HomeRepositoryImpl 의존성
```dart
// lib/feature/home/data/repository/home_repository_impl.dart
class HomeRepositoryImpl implements HomeRepository {
  const HomeRepositoryImpl({
    required RecordRepository recordRepository,
    required WaterRecordRepository waterRecordRepository,
    required MealRecordRepository mealRecordRepository,
    required ExerciseRecordRepository exerciseRecordRepository,
  })  : _recordRepository = recordRepository,
        _waterRecordRepository = waterRecordRepository,
        _mealRecordRepository = mealRecordRepository,
        _exerciseRecordRepository = exerciseRecordRepository;

  final RecordRepository _recordRepository;
  final WaterRecordRepository _waterRecordRepository;
  final MealRecordRepository _mealRecordRepository;
  final ExerciseRecordRepository _exerciseRecordRepository;
}
```

### 16.3 HomeProviders 정의
```dart
// lib/feature/home/di/home_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../record/di/record_providers.dart';
import '../../water_record/di/water_record_providers.dart';
import '../../meal_record/di/meal_record_providers.dart';
import '../../exercise_record/di/exercise_record_providers.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(
    recordRepository: ref.watch(recordRepositoryProvider),
    waterRecordRepository: ref.watch(waterRecordRepositoryProvider),
    mealRecordRepository: ref.watch(mealRecordRepositoryProvider),
    exerciseRecordRepository: ref.watch(exerciseRecordRepositoryProvider),
  );
});

final getDailySummaryUseCaseProvider = Provider<GetDailySummaryUseCase>((ref) {
  return GetDailySummaryUseCase(ref.watch(homeRepositoryProvider));
});

final getHealthScoreUseCaseProvider = Provider<GetHealthScoreUseCase>((ref) {
  return GetHealthScoreUseCase(ref.watch(homeRepositoryProvider));
});

final getRecentRecordsUseCaseProvider = Provider<GetRecentRecordsUseCase>((ref) {
  return GetRecentRecordsUseCase(ref.watch(homeRepositoryProvider));
});

// autoDispose 미사용 (메인 탭 화면)
final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(
    getDailySummaryUseCase: ref.watch(getDailySummaryUseCaseProvider),
    getHealthScoreUseCase: ref.watch(getHealthScoreUseCaseProvider),
    getRecentRecordsUseCase: ref.watch(getRecentRecordsUseCaseProvider),
  );
});
```

---

## 17. 데이터 갱신 연동 상세

### 17.1 Record 추가 시 갱신 패턴
```dart
// lib/feature/water_record/presentation/page/water_record_page.dart
class _WaterRecordPageState extends ConsumerState<WaterRecordPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen<WaterRecordFormState>(
      waterRecordFormNotifierProvider,
      (previous, next) {
        if (next is WaterRecordFormSuccess) {
          // 1. 성공 메시지 표시
          ScaffoldMessenger.of(context).showSnackBar(...);

          // 2. 관련 데이터 갱신
          _refreshRelatedData(ref);

          // 3. 화면 닫기
          Navigator.pop(context);
        }
      },
    );
    // ...
  }

  void _refreshRelatedData(WidgetRef ref) {
    // Home 화면 데이터 갱신
    ref.invalidate(homeNotifierProvider);

    // Analytics 화면 데이터 갱신
    ref.invalidate(analyticsNotifierProvider);
  }
}
```

### 17.2 공통 갱신 유틸리티
```dart
// lib/shared/utils/refresh_utils.dart
void refreshAllRecordData(WidgetRef ref) {
  // 각 Record Feature의 리스트 Provider 갱신
  ref.invalidate(recordsProvider);
  ref.invalidate(waterRecordsProvider);
  ref.invalidate(mealRecordsProvider);
  ref.invalidate(exerciseRecordsProvider);

  // 집계 화면 갱신
  ref.invalidate(homeNotifierProvider);
  ref.invalidate(analyticsNotifierProvider);
}

void refreshHomeData(WidgetRef ref) {
  ref.invalidate(homeNotifierProvider);
}

void refreshAnalyticsData(WidgetRef ref) {
  ref.invalidate(analyticsNotifierProvider);
}
```

### 17.3 Home 화면 자동 로드
```dart
// lib/feature/home/presentation/page/home_page.dart
class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // 화면 진입 시 데이터 로드
    Future.microtask(() {
      ref.read(homeNotifierProvider.notifier).loadData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);

    return switch (state) {
      HomeInitial() || HomeLoading() => _buildLoading(),
      HomeLoaded(:final summary, :final healthScore, :final recentRecords) =>
        _buildLoaded(summary, healthScore, recentRecords),
      HomeError(:final message) => _buildError(message),
    };
  }
}
```

### 17.4 HomeNotifier 구현
```dart
// lib/feature/home/presentation/provider/home_notifier.dart
class HomeNotifier extends StateNotifier<HomeState> {
  HomeNotifier({
    required GetDailySummaryUseCase getDailySummaryUseCase,
    required GetHealthScoreUseCase getHealthScoreUseCase,
    required GetRecentRecordsUseCase getRecentRecordsUseCase,
  })  : _getDailySummaryUseCase = getDailySummaryUseCase,
        _getHealthScoreUseCase = getHealthScoreUseCase,
        _getRecentRecordsUseCase = getRecentRecordsUseCase,
        super(HomeInitial());

  final GetDailySummaryUseCase _getDailySummaryUseCase;
  final GetHealthScoreUseCase _getHealthScoreUseCase;
  final GetRecentRecordsUseCase _getRecentRecordsUseCase;

  DateTime _selectedDate = DateTime.now();

  Future<void> loadData() async {
    state = HomeLoading();

    try {
      final summaryResult = await _getDailySummaryUseCase(_selectedDate);
      final healthScoreResult = await _getHealthScoreUseCase(_selectedDate);
      final recentRecordsResult = await _getRecentRecordsUseCase(_selectedDate);

      // Either 처리
      final summary = summaryResult.fold((f) => throw f, (s) => s);
      final healthScore = healthScoreResult.fold((f) => throw f, (s) => s);
      final recentRecords = recentRecordsResult.fold((f) => throw f, (s) => s);

      state = HomeLoaded(
        selectedDate: _selectedDate,
        summary: summary,
        healthScore: healthScore,
        recentRecords: recentRecords,
        isHealthScoreExpanded: false,
      );
    } catch (e) {
      state = HomeError(e.toString());
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    loadData();
  }

  void toggleHealthScoreExpanded() {
    final currentState = state;
    if (currentState is HomeLoaded) {
      state = currentState.copyWith(
        isHealthScoreExpanded: !currentState.isHealthScoreExpanded,
      );
    }
  }
}
```

---

## 18. UI 마이그레이션 가이드

### 18.1 WaterRecordScreen → WaterRecordPage 변환

#### Before (water_record_screen.dart)
```dart
class _WaterRecordScreenState extends State<WaterRecordScreen> {
  double _waterAmount = 250;
  int? _selectedPreset = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ...
      child: Slider(
        value: _waterAmount,
        onChanged: (value) {
          setState(() {
            _waterAmount = value;
            _selectedPreset = null;
          });
        },
      ),
    );
  }
}
```

#### After (water_record_page.dart)
```dart
class _WaterRecordPageState extends ConsumerState<WaterRecordPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waterRecordFormNotifierProvider);

    if (state is! WaterRecordFormInProgress) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      // ...
      child: Slider(
        value: state.waterAmount,
        onChanged: (value) {
          ref.read(waterRecordFormNotifierProvider.notifier).setAmount(value);
        },
      ),
    );
  }
}
```

### 18.2 변환 체크리스트
```
[ ] 1. StatefulWidget → ConsumerStatefulWidget 변경
[ ] 2. State → ConsumerState 변경
[ ] 3. setState 호출 → ref.read(provider.notifier).method() 변경
[ ] 4. 로컬 상태 변수 제거 (Provider State로 이동)
[ ] 5. initState에서 초기화 → Provider 초기값으로 이동
[ ] 6. dispose 로직 확인 (autoDispose로 대체)
[ ] 7. ref.listen 추가 (성공/에러 처리)
[ ] 8. switch 표현식으로 상태별 UI 분기
```

---

## 19. 롤백 전략

### 19.1 Phase 단위 롤백
각 Phase는 독립적으로 롤백 가능합니다.

#### Phase 1 롤백
```bash
# WaterRecord 롤백
rm -rf lib/feature/water_record/

# MealRecord 롤백
rm -rf lib/feature/meal_record/

# ExerciseRecord 롤백
rm -rf lib/feature/exercise_record/

# main.dart는 기존 screens 사용하므로 수정 불필요
```

#### Phase 2 롤백
```bash
# Phase 2 전체 롤백 (Phase 1은 유지)
rm -rf lib/feature/home/
rm -rf lib/feature/analytics/

# main.dart 원복 필요
```

### 19.2 Git 브랜치 전략
```bash
# 작업 시작 전
git checkout develop
git checkout -b feature/clean-architecture-remaining

# Phase 1 완료 후 커밋
git add .
git commit -m "feat: Phase 1 - WaterRecord, MealRecord, ExerciseRecord Feature 클린 아키텍처 적용"

# Phase 2 완료 후 커밋
git add .
git commit -m "feat: Phase 2 - Home, Analytics Feature 클린 아키텍처 적용"

# Phase 3 완료 후 커밋
git add .
git commit -m "refactor: Phase 3 - main.dart 수정 및 screens 폴더 정리"

# 전체 완료 후 develop에 병합
git checkout develop
git merge feature/clean-architecture-remaining
```

---

## 20. Analytics 차트 구현 가이드

### 20.1 fl_chart 도넛 차트 (배변 상태 분포)
```dart
// lib/feature/analytics/presentation/widget/bowel_distribution_chart.dart
import 'package:fl_chart/fl_chart.dart';

class BowelDistributionChart extends StatelessWidget {
  const BowelDistributionChart({
    super.key,
    required this.distribution,
  });

  final BowelDistributionEntity distribution;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: PieChart(
        PieChartData(
          sections: _buildSections(),
          centerSpaceRadius: 50,
          sectionsSpace: 2,
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections() {
    final total = distribution.total;
    if (total == 0) {
      return [
        PieChartSectionData(
          value: 1,
          color: Colors.grey.shade300,
          title: '기록 없음',
          radius: 50,
        ),
      ];
    }

    return [
      _buildSection(
        value: distribution.type1_2Count.toDouble(),
        total: total,
        color: const Color(0xFF6B7280),  // 회색 (변비)
        title: '딱딱',
      ),
      _buildSection(
        value: distribution.type3_4Count.toDouble(),
        total: total,
        color: const Color(0xFF4CAF50),  // 초록 (정상)
        title: '정상',
      ),
      _buildSection(
        value: distribution.type5_6Count.toDouble(),
        total: total,
        color: const Color(0xFFFFA726),  // 주황 (무른)
        title: '무른',
      ),
      _buildSection(
        value: distribution.type7Count.toDouble(),
        total: total,
        color: const Color(0xFFEF5350),  // 빨강 (설사)
        title: '설사',
      ),
    ].where((s) => s.value > 0).toList();
  }

  PieChartSectionData _buildSection({
    required double value,
    required int total,
    required Color color,
    required String title,
  }) {
    final percentage = (value / total * 100).toStringAsFixed(0);
    return PieChartSectionData(
      value: value,
      color: color,
      title: '$title\n$percentage%',
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      radius: 50,
    );
  }
}
```

### 20.2 fl_chart 막대 차트 (주간 빈도)
```dart
// lib/feature/analytics/presentation/widget/weekly_frequency_chart.dart
import 'package:fl_chart/fl_chart.dart';

class WeeklyFrequencyChart extends StatelessWidget {
  const WeeklyFrequencyChart({
    super.key,
    required this.weeklyFrequency,
  });

  final WeeklyFrequencyEntity weeklyFrequency;

  static const _weekDays = ['월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: _calculateMaxY(),
          barGroups: _buildBarGroups(),
          titlesData: _buildTitlesData(),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  double _calculateMaxY() {
    final max = weeklyFrequency.dailyCounts.reduce((a, b) => a > b ? a : b);
    return (max + 1).toDouble();
  }

  List<BarChartGroupData> _buildBarGroups() {
    return List.generate(7, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: weeklyFrequency.dailyCounts[index].toDouble(),
            color: const Color(0xFF4CAF50),
            width: 24,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(4),
            ),
          ),
        ],
      );
    });
  }

  FlTitlesData _buildTitlesData() {
    return FlTitlesData(
      show: true,
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      leftTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 28,
          interval: 1,
        ),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _weekDays[value.toInt()],
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF666666),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### 20.3 인사이트 카드 위젯
```dart
// lib/feature/analytics/presentation/widget/insight_card.dart
class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.insight,
  });

  final InsightEntity insight;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(_getEmoji(), style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  insight.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    return switch (insight.type) {
      InsightType.positive => const Color(0xFF4CAF50),
      InsightType.water => const Color(0xFF2196F3),
      InsightType.time => const Color(0xFFFFA726),
      InsightType.warning => const Color(0xFFEF5350),
    };
  }

  String _getEmoji() {
    return switch (insight.type) {
      InsightType.positive => '✨',
      InsightType.water => '💧',
      InsightType.time => '⏰',
      InsightType.warning => '⚠️',
    };
  }
}
```

---

## 21. 트러블슈팅

### 21.1 Provider not found 에러
```
ProviderNotFoundException: Could not find the correct Provider<XxxRepository>
```

**원인**: Provider가 정의되지 않았거나 import가 누락됨

**해결**:
```dart
// 1. providers.dart 파일에 Provider 정의 확인
final waterRecordRepositoryProvider = Provider<WaterRecordRepository>((ref) {
  final dataSource = ref.watch(waterRecordLocalDataSourceProvider);
  return WaterRecordRepositoryImpl(dataSource);
});

// 2. 사용하는 파일에서 import 확인
import '../../water_record/di/water_record_providers.dart';
```

### 21.2 StateNotifier state 변경 시 UI 업데이트 안됨
**원인**: state를 직접 수정하지 않고 새 인스턴스 생성 필요

**잘못된 코드**:
```dart
void setAmount(double amount) {
  (state as WaterRecordFormInProgress).waterAmount = amount; // 잘못됨
}
```

**올바른 코드**:
```dart
void setAmount(double amount) {
  final currentState = state;
  if (currentState is WaterRecordFormInProgress) {
    state = currentState.copyWith(
      waterAmount: amount,
      selectedPreset: null,
    );
  }
}
```

### 21.3 ref.invalidate 후 데이터가 다시 로드되지 않음
**원인**: Notifier의 loadData()가 자동 호출되지 않음

**해결**:
```dart
// 방법 1: Provider에 autoDispose 사용
final homeNotifierProvider = StateNotifierProvider.autoDispose<...>((ref) {
  // Provider가 다시 생성될 때 자동으로 초기 상태로
});

// 방법 2: invalidate 후 명시적 로드 호출
ref.invalidate(homeNotifierProvider);
ref.read(homeNotifierProvider.notifier).loadData();

// 방법 3: Widget에서 ref.listen으로 감지 후 재로드
ref.listen(someProvider, (prev, next) {
  ref.read(homeNotifierProvider.notifier).loadData();
});
```

### 21.4 Sealed class에서 switch가 exhaustive하지 않음
**원인**: Dart 3.0 미만 버전 또는 sealed 키워드 누락

**해결**:
```dart
// pubspec.yaml에서 Dart 버전 확인
environment:
  sdk: '>=3.0.0 <4.0.0'

// sealed 키워드 사용
sealed class WaterRecordFormState {
  const WaterRecordFormState();
}
```

### 21.5 fl_chart에서 빈 데이터 처리
**원인**: 데이터가 없을 때 차트가 렌더링 실패

**해결**:
```dart
if (distribution.total == 0) {
  return const Center(
    child: Text(
      '아직 기록이 없습니다',
      style: TextStyle(color: Color(0xFF999999)),
    ),
  );
}

// 또는 기본 데이터 표시
List<PieChartSectionData> _buildSections() {
  if (distribution.total == 0) {
    return [
      PieChartSectionData(
        value: 1,
        color: Colors.grey.shade300,
        title: '',
        radius: 50,
      ),
    ];
  }
  // ...
}
```

### 21.6 ConsumerStatefulWidget에서 ref 접근 에러
**원인**: initState에서 ref 직접 사용 불가

**잘못된 코드**:
```dart
@override
void initState() {
  super.initState();
  ref.read(notifier).loadData(); // 에러!
}
```

**올바른 코드**:
```dart
@override
void initState() {
  super.initState();
  Future.microtask(() {
    ref.read(notifier).loadData();
  });
}

// 또는
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    ref.read(notifier).loadData();
  });
}
```

---

## 22. 완료 체크리스트

### Phase 1 완료 조건
- [ ] WaterRecord Feature 구현 완료
- [ ] MealRecord Feature 구현 완료
- [ ] ExerciseRecord Feature 구현 완료
- [ ] 각 Feature별 기록 추가 테스트 통과
- [ ] `flutter analyze` 경고 없음

### Phase 2 완료 조건
- [ ] Home Feature 구현 완료
- [ ] Analytics Feature 구현 완료
- [ ] 모든 Record 데이터 Home에서 표시 확인
- [ ] Analytics 차트 렌더링 확인
- [ ] `flutter analyze` 경고 없음

### Phase 3 완료 조건
- [ ] main.dart 수정 완료
- [ ] 기존 screens 폴더 삭제
- [ ] 모든 화면 네비게이션 정상
- [ ] 기록 추가 후 Home/Analytics 자동 갱신
- [ ] `flutter run` 정상 실행
- [ ] 최종 `flutter analyze` 경고 없음

---

## 23. 참고 문서

- [Flutter Riverpod 공식 문서](https://riverpod.dev)
- [fl_chart 공식 문서](https://pub.dev/packages/fl_chart)
- [dartz 패키지](https://pub.dev/packages/dartz)
- 기존 구현 참조: `lib/feature/record/`, `lib/feature/calendar/`, `lib/feature/settings/`
