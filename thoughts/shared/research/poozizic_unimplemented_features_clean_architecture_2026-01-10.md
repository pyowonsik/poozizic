# poozizic 미구현 Feature 클린 아키텍처 마이그레이션 연구

**날짜**: 2026-01-10
**분석 대상**: 미구현 screens의 클린 아키텍처 및 Riverpod 적용 방안
**참조 문서**: `thoughts/shared/plans/clean_architecture_migration_plan_2026-01-09.md`

---

## 1. 현재 상태 분석

### 1.1 이미 클린 아키텍처가 적용된 Feature (3개)

| Feature | 위치 | 상태 |
|---------|------|------|
| Record (배변 기록) | `lib/feature/record/` | 완료 |
| Calendar (캘린더) | `lib/feature/calendar/` | 완료 |
| Settings (설정) | `lib/feature/settings/` | 완료 |

### 1.2 미구현 Screens (5개)

| Screen | 파일 위치 | 현재 상태 |
|--------|----------|----------|
| HomeScreen | `lib/screens/home_screen.dart` | StatefulWidget, 하드코딩된 목업 데이터 |
| AnalyticsScreen | `lib/screens/analytics_screen.dart` | StatelessWidget, 하드코딩된 목업 데이터 |
| WaterRecordScreen | `lib/screens/water_record_screen.dart` | StatefulWidget, 상태만 로컬 관리 |
| MealRecordScreen | `lib/screens/meal_record_screen.dart` | StatefulWidget, 상태만 로컬 관리 |
| ExerciseRecordScreen | `lib/screens/exercise_record_screen.dart` | StatefulWidget, 상태만 로컬 관리 |

---

## 2. 구현된 패턴 분석 (Record Feature 기준)

### 2.1 폴더 구조
```
lib/feature/record/
├── data/
│   ├── datasource/
│   │   └── record_local_datasource.dart   # 목업 데이터 저장소
│   └── repository/
│       └── record_repository_impl.dart    # Repository 구현체
├── di/
│   └── record_providers.dart              # Riverpod Provider 정의
├── domain/
│   ├── entity/
│   │   └── record_entity.dart             # 도메인 모델
│   ├── failure/
│   │   └── record_failure.dart            # 도메인 에러 정의
│   ├── repository/
│   │   └── record_repository.dart         # Repository 인터페이스
│   └── usecase/
│       ├── create_record_usecase.dart     # 생성 비즈니스 로직
│       ├── get_records_by_date_usecase.dart
│       └── get_records_usecase.dart
└── presentation/
    ├── page/
    │   └── record_page.dart               # ConsumerStatefulWidget
    ├── provider/
    │   ├── record_form_notifier.dart      # StateNotifier
    │   └── record_form_state.dart         # Sealed State 클래스
    └── widget/
        ├── bristol_scale_step.dart
        ├── feeling_step.dart
        └── time_step.dart
```

### 2.2 Sealed State 패턴
```dart
sealed class RecordFormState {
  const RecordFormState();
}

class RecordFormInitial extends RecordFormState { ... }
class RecordFormInProgress extends RecordFormState { ... }
class RecordFormSubmitting extends RecordFormState { ... }
class RecordFormSuccess extends RecordFormState { ... }
class RecordFormError extends RecordFormState { ... }
```

### 2.3 StateNotifier 패턴
```dart
class RecordFormNotifier extends StateNotifier<RecordFormState> {
  RecordFormNotifier(this._createRecordUseCase)
      : super(const RecordFormInProgress(currentStep: 0));

  final CreateRecordUseCase _createRecordUseCase;

  void selectBristolType(int type) { ... }
  Future<void> submitRecord() async { ... }
}
```

### 2.4 Provider 구성 (DI)
```dart
// DataSource → Repository → UseCase → Notifier 순서로 의존성 주입
final recordLocalDataSourceProvider = Provider<RecordLocalDataSource>((ref) => ...);
final recordRepositoryProvider = Provider<RecordRepository>((ref) => ...);
final createRecordUseCaseProvider = Provider<CreateRecordUseCase>((ref) => ...);
final recordFormNotifierProvider = StateNotifierProvider.autoDispose<...>((ref) => ...);
```

---

## 3. 미구현 Feature별 마이그레이션 계획

### 3.1 WaterRecord Feature (수분 기록)

#### 현재 코드 분석 (`water_record_screen.dart`)
- **상태**: `_waterAmount`, `_selectedPreset`
- **UI**: 슬라이더, 프리셋 버튼 (컵, 머그컵, 캔, 물병)
- **기능**: 수분량 선택 후 기록 완료

#### 클린 아키텍처 구조
```
lib/feature/water_record/
├── data/
│   ├── datasource/
│   │   └── water_record_local_datasource.dart
│   └── repository/
│       └── water_record_repository_impl.dart
├── di/
│   └── water_record_providers.dart
├── domain/
│   ├── entity/
│   │   └── water_record_entity.dart
│   ├── failure/
│   │   └── water_record_failure.dart
│   ├── repository/
│   │   └── water_record_repository.dart
│   └── usecase/
│       ├── create_water_record_usecase.dart
│       ├── get_water_records_by_date_usecase.dart
│       └── get_daily_water_total_usecase.dart
└── presentation/
    ├── page/
    │   └── water_record_page.dart
    ├── provider/
    │   ├── water_record_form_notifier.dart
    │   └── water_record_form_state.dart
    └── widget/
        ├── water_amount_display.dart
        ├── preset_grid.dart
        └── amount_slider.dart
```

#### Entity 설계
```dart
class WaterRecordEntity {
  final int? id;
  final DateTime dateTime;
  final int amountMl;        // 수분량 (ml)
  final String? presetType;  // cup, mug, can, bottle
  final DateTime createdAt;
}
```

#### State 설계
```dart
sealed class WaterRecordFormState { ... }
class WaterRecordFormInitial extends WaterRecordFormState { ... }
class WaterRecordFormInProgress extends WaterRecordFormState {
  final double waterAmount;
  final int? selectedPreset;
}
class WaterRecordFormSubmitting extends WaterRecordFormState { ... }
class WaterRecordFormSuccess extends WaterRecordFormState { ... }
class WaterRecordFormError extends WaterRecordFormState { ... }
```

---

### 3.2 MealRecord Feature (식사 기록)

#### 현재 코드 분석 (`meal_record_screen.dart`)
- **상태**: `_selectedMealType`, `_foods` (리스트), `_selectedFiber`
- **UI**: 식사 구분 (아침/점심/저녁/간식), 음식 입력, 식이섬유 함량 선택
- **기능**: 식사 정보 입력 후 기록 완료

#### 클린 아키텍처 구조
```
lib/feature/meal_record/
├── data/
│   ├── datasource/
│   │   └── meal_record_local_datasource.dart
│   └── repository/
│       └── meal_record_repository_impl.dart
├── di/
│   └── meal_record_providers.dart
├── domain/
│   ├── entity/
│   │   └── meal_record_entity.dart
│   ├── failure/
│   │   └── meal_record_failure.dart
│   ├── repository/
│   │   └── meal_record_repository.dart
│   └── usecase/
│       ├── create_meal_record_usecase.dart
│       ├── get_meal_records_by_date_usecase.dart
│       └── get_daily_meal_summary_usecase.dart
└── presentation/
    ├── page/
    │   └── meal_record_page.dart
    ├── provider/
    │   ├── meal_record_form_notifier.dart
    │   └── meal_record_form_state.dart
    └── widget/
        ├── meal_type_selector.dart
        ├── food_input_section.dart
        └── fiber_level_selector.dart
```

#### Entity 설계
```dart
class MealRecordEntity {
  final int? id;
  final DateTime dateTime;
  final int mealType;         // 0: 아침, 1: 점심, 2: 저녁, 3: 간식
  final List<String> foods;   // 먹은 음식 목록
  final int fiberLevel;       // 0: 많음, 1: 보통, 2: 적음
  final DateTime createdAt;

  String get mealTypeName => ['아침', '점심', '저녁', '간식'][mealType];
  String get fiberLevelName => ['많음', '보통', '적음'][fiberLevel];
}
```

#### State 설계
```dart
sealed class MealRecordFormState { ... }
class MealRecordFormInitial extends MealRecordFormState { ... }
class MealRecordFormInProgress extends MealRecordFormState {
  final int selectedMealType;
  final List<String> foods;
  final int? selectedFiber;

  bool get canSubmit => foods.isNotEmpty && selectedFiber != null;
}
class MealRecordFormSubmitting extends MealRecordFormState { ... }
class MealRecordFormSuccess extends MealRecordFormState { ... }
class MealRecordFormError extends MealRecordFormState { ... }
```

---

### 3.3 ExerciseRecord Feature (운동 기록)

#### 현재 코드 분석 (`exercise_record_screen.dart`)
- **상태**: `_selectedExercise`, `_duration`, `_selectedIntensity`
- **UI**: 운동 종류 그리드, 시간 슬라이더, 강도 선택
- **기능**: 운동 정보 입력 후 기록 완료

#### 클린 아키텍처 구조
```
lib/feature/exercise_record/
├── data/
│   ├── datasource/
│   │   └── exercise_record_local_datasource.dart
│   └── repository/
│       └── exercise_record_repository_impl.dart
├── di/
│   └── exercise_record_providers.dart
├── domain/
│   ├── entity/
│   │   └── exercise_record_entity.dart
│   ├── failure/
│   │   └── exercise_record_failure.dart
│   ├── repository/
│   │   └── exercise_record_repository.dart
│   └── usecase/
│       ├── create_exercise_record_usecase.dart
│       ├── get_exercise_records_by_date_usecase.dart
│       └── get_weekly_exercise_summary_usecase.dart
└── presentation/
    ├── page/
    │   └── exercise_record_page.dart
    ├── provider/
    │   ├── exercise_record_form_notifier.dart
    │   └── exercise_record_form_state.dart
    └── widget/
        ├── exercise_type_grid.dart
        ├── duration_slider.dart
        └── intensity_selector.dart
```

#### Entity 설계
```dart
class ExerciseRecordEntity {
  final int? id;
  final DateTime dateTime;
  final int exerciseType;     // 0: 달리기, 1: 걷기, 2: 자전거, 3: 수영, 4: 요가, 5: 웨이트
  final int durationMinutes;
  final int intensity;        // 0: 가볍게, 1: 보통, 2: 격하게
  final DateTime createdAt;

  String get exerciseTypeName => ['달리기', '걷기', '자전거', '수영', '요가', '웨이트'][exerciseType];
  String get intensityName => ['가볍게', '보통', '격하게'][intensity];
}
```

---

### 3.4 Home Feature (홈 화면)

#### 현재 코드 분석 (`home_screen.dart`)
- **상태**: `_selectedDate`, `_isHealthScoreExpanded`
- **데이터**: 하드코딩된 목업 (마지막 배변, 연속 기록, 수분 섭취, 건강 점수 등)
- **UI**: 오늘의 상태, 수분 섭취 진행률, 건강 점수, 최근 기록

#### 클린 아키텍처 구조
```
lib/feature/home/
├── data/
│   └── repository/
│       └── home_repository_impl.dart
├── di/
│   └── home_providers.dart
├── domain/
│   ├── entity/
│   │   ├── daily_summary_entity.dart
│   │   └── health_score_entity.dart
│   ├── failure/
│   │   └── home_failure.dart
│   ├── repository/
│   │   └── home_repository.dart
│   └── usecase/
│       ├── get_daily_summary_usecase.dart
│       ├── get_health_score_usecase.dart
│       └── get_recent_records_usecase.dart
└── presentation/
    ├── page/
    │   └── home_page.dart
    ├── provider/
    │   ├── home_notifier.dart
    │   └── home_state.dart
    └── widget/
        ├── today_status_card.dart
        ├── water_progress_section.dart
        ├── health_score_card.dart
        └── recent_records_section.dart
```

#### Entity 설계
```dart
class DailySummaryEntity {
  final DateTime date;
  final DateTime? lastBowelTime;
  final int consecutiveDays;
  final int weeklyBowelCount;
  final int waterIntakeMl;
  final int waterGoalMl;

  double get waterProgress => waterIntakeMl / waterGoalMl;
  String get lastBowelText => ...; // "2시간 전" 등
}

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

#### State 설계
```dart
sealed class HomeState { ... }
class HomeInitial extends HomeState { ... }
class HomeLoading extends HomeState { ... }
class HomeLoaded extends HomeState {
  final DateTime selectedDate;
  final DailySummaryEntity summary;
  final HealthScoreEntity healthScore;
  final List<dynamic> recentRecords; // 여러 타입의 기록
  final bool isHealthScoreExpanded;
}
class HomeError extends HomeState { ... }
```

#### 중요 의존성
- Home Feature는 다른 모든 Record Feature들의 데이터를 조합해야 함
- `recordRepositoryProvider`, `waterRecordRepositoryProvider`, `mealRecordRepositoryProvider`, `exerciseRecordRepositoryProvider` 의존

---

### 3.5 Analytics Feature (분석 화면)

#### 현재 코드 분석 (`analytics_screen.dart`)
- **상태**: StatelessWidget (상태 없음)
- **데이터**: 하드코딩된 목업 (건강 점수, 정상 비율, 평균 간격, 차트 데이터)
- **UI**: 통계 카드, 도넛 차트 (배변 상태 분포), 막대 차트 (주간 빈도), 인사이트 카드

#### 클린 아키텍처 구조
```
lib/feature/analytics/
├── data/
│   └── repository/
│       └── analytics_repository_impl.dart
├── di/
│   └── analytics_providers.dart
├── domain/
│   ├── entity/
│   │   ├── analytics_summary_entity.dart
│   │   ├── bowel_distribution_entity.dart
│   │   ├── weekly_frequency_entity.dart
│   │   └── insight_entity.dart
│   ├── failure/
│   │   └── analytics_failure.dart
│   ├── repository/
│   │   └── analytics_repository.dart
│   └── usecase/
│       ├── get_analytics_summary_usecase.dart
│       ├── get_bowel_distribution_usecase.dart
│       ├── get_weekly_frequency_usecase.dart
│       └── get_insights_usecase.dart
└── presentation/
    ├── page/
    │   └── analytics_page.dart
    ├── provider/
    │   ├── analytics_notifier.dart
    │   └── analytics_state.dart
    └── widget/
        ├── stat_cards_row.dart
        ├── bowel_distribution_chart.dart
        ├── weekly_frequency_chart.dart
        └── insight_card.dart
```

#### Entity 설계
```dart
class AnalyticsSummaryEntity {
  final int healthScore;
  final double normalRatio;      // 정상 비율 (%)
  final double averageInterval;  // 평균 간격 (일)
  final int period;              // 분석 기간 (일)
}

class BowelDistributionEntity {
  final int type1_2Count;
  final int type3_4Count;
  final int type5_6Count;
  final int type7Count;

  int get total => type1_2Count + type3_4Count + type5_6Count + type7Count;
}

class WeeklyFrequencyEntity {
  final List<int> dailyCounts;  // 월~일 배변 횟수 [1, 1, 2, 1, 1, 0, 1]
}

class InsightEntity {
  final String title;
  final String description;
  final String iconType;        // positive, water, time
}
```

---

## 4. 구현 우선순위 및 의존성

### 4.1 권장 구현 순서

```
Phase 1: 독립적인 기록 Feature (병렬 가능)
  ├── WaterRecord Feature
  ├── MealRecord Feature
  └── ExerciseRecord Feature

Phase 2: 의존성 있는 Feature
  ├── Home Feature (모든 Record Feature 의존)
  └── Analytics Feature (Record Feature 의존)
```

### 4.2 의존성 다이어그램
```
                    ┌─────────────────┐
                    │  shared/domain  │
                    │  - Failure      │
                    │  - UseCase      │
                    └────────┬────────┘
                             │
         ┌───────────────────┼───────────────────┐
         │                   │                   │
    ┌────▼────┐        ┌─────▼────┐       ┌─────▼────┐
    │ Record  │        │  Water   │       │  Meal    │
    │ Feature │        │ Feature  │       │ Feature  │
    └────┬────┘        └────┬─────┘       └────┬─────┘
         │                  │                   │
         │            ┌─────▼─────┐             │
         │            │ Exercise  │             │
         │            │ Feature   │             │
         │            └─────┬─────┘             │
         │                  │                   │
         └─────────────────┬┴──────────────────┘
                           │
                    ┌──────▼──────┐
                    │    Home     │
                    │   Feature   │
                    └──────┬──────┘
                           │
                    ┌──────▼──────┐
                    │  Analytics  │
                    │   Feature   │
                    └─────────────┘
```

---

## 5. 공통 패턴 및 베스트 프랙티스

### 5.1 Failure 클래스 패턴
```dart
// 각 Feature별 Failure 정의
class WaterRecordFailure extends Failure {
  const WaterRecordFailure(super.message, {super.exception, super.stackTrace});

  factory WaterRecordFailure.invalidAmount() =>
      const WaterRecordFailure('유효하지 않은 수분량입니다');
}
```

### 5.2 Repository Interface 패턴
```dart
abstract class WaterRecordRepository {
  Future<Either<Failure, WaterRecordEntity>> createWaterRecord(WaterRecordEntity record);
  Future<Either<Failure, List<WaterRecordEntity>>> getRecordsByDate(DateTime date);
  Future<Either<Failure, int>> getDailyTotal(DateTime date);
}
```

### 5.3 UseCase 패턴
```dart
class CreateWaterRecordUseCase extends UseCase<WaterRecordEntity, CreateWaterRecordParams, WaterRecordRepository> {
  CreateWaterRecordUseCase(this._repo);

  final WaterRecordRepository _repo;

  @override
  WaterRecordRepository get repo => _repo;

  @override
  Future<Either<Failure, WaterRecordEntity>> call(CreateWaterRecordParams params) {
    return repo.createWaterRecord(
      WaterRecordEntity(
        dateTime: DateTime.now(),
        amountMl: params.amountMl,
        presetType: params.presetType,
        createdAt: DateTime.now(),
      ),
    );
  }
}

class CreateWaterRecordParams {
  final int amountMl;
  final String? presetType;

  const CreateWaterRecordParams({required this.amountMl, this.presetType});
}
```

### 5.4 Provider 패턴
```dart
// DataSource (singleton)
final waterRecordLocalDataSourceProvider = Provider<WaterRecordLocalDataSource>((ref) {
  return WaterRecordLocalDataSource();
});

// Repository
final waterRecordRepositoryProvider = Provider<WaterRecordRepository>((ref) {
  final dataSource = ref.watch(waterRecordLocalDataSourceProvider);
  return WaterRecordRepositoryImpl(dataSource);
});

// UseCase
final createWaterRecordUseCaseProvider = Provider<CreateWaterRecordUseCase>((ref) {
  final repository = ref.watch(waterRecordRepositoryProvider);
  return CreateWaterRecordUseCase(repository);
});

// Notifier (autoDispose for form screens)
final waterRecordFormNotifierProvider =
    StateNotifierProvider.autoDispose<WaterRecordFormNotifier, WaterRecordFormState>((ref) {
  final useCase = ref.watch(createWaterRecordUseCaseProvider);
  return WaterRecordFormNotifier(useCase);
});
```

### 5.5 ConsumerStatefulWidget 패턴
```dart
class WaterRecordPage extends ConsumerStatefulWidget {
  const WaterRecordPage({super.key});

  @override
  ConsumerState<WaterRecordPage> createState() => _WaterRecordPageState();
}

class _WaterRecordPageState extends ConsumerState<WaterRecordPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(waterRecordFormNotifierProvider);

    return switch (state) {
      WaterRecordFormInitial() => const SizedBox.shrink(),
      WaterRecordFormInProgress(:final waterAmount) => _buildForm(waterAmount),
      WaterRecordFormSubmitting() => const Center(child: CircularProgressIndicator()),
      WaterRecordFormSuccess(:final record) => _buildSuccess(record),
      WaterRecordFormError(:final message) => _buildError(message),
    };
  }

  void _onSubmit() {
    ref.read(waterRecordFormNotifierProvider.notifier).submit();
  }
}
```

---

## 6. main.dart 수정 계획

### 현재 상태
```dart
// 미구현 screens 직접 import
import 'screens/home_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/meal_record_screen.dart';
import 'screens/water_record_screen.dart';
import 'screens/exercise_record_screen.dart';
```

### 마이그레이션 후
```dart
// 모든 feature 사용
import 'feature/home/presentation/page/home_page.dart';
import 'feature/analytics/presentation/page/analytics_page.dart';
import 'feature/water_record/presentation/page/water_record_page.dart';
import 'feature/meal_record/presentation/page/meal_record_page.dart';
import 'feature/exercise_record/presentation/page/exercise_record_page.dart';
// 이미 적용됨
import 'feature/calendar/presentation/page/calendar_page.dart';
import 'feature/record/presentation/page/record_page.dart';
import 'feature/settings/presentation/page/settings_page.dart';
```

---

## 7. 예상 파일 수

| Feature | 예상 파일 수 |
|---------|-------------|
| WaterRecord | ~13개 |
| MealRecord | ~13개 |
| ExerciseRecord | ~13개 |
| Home | ~14개 |
| Analytics | ~15개 |
| **합계** | ~68개 |

---

## 8. 결론 및 권장사항

### 8.1 핵심 포인트
1. **이미 검증된 패턴 활용**: Record, Calendar, Settings에서 적용된 패턴을 동일하게 적용
2. **Feature 독립성 유지**: 각 Feature는 자체 data/domain/presentation 레이어를 가짐
3. **의존성 주입**: Riverpod Provider를 통한 일관된 DI 패턴 사용
4. **Sealed State**: 타입 안전한 상태 관리로 UI 분기 명확화
5. **autoDispose**: Form 화면은 autoDispose로 메모리 관리

### 8.2 주의사항
1. **Home/Analytics 의존성**: 여러 Repository를 조합해야 하므로 마지막에 구현
2. **데이터 동기화**: Record 추가 시 Home/Analytics 갱신 필요 (`ref.invalidate()`)
3. **목업 데이터 유지**: 백엔드 없이 LocalDataSource로 인메모리 데이터 관리
4. **기존 UI 재사용**: 현재 screens의 UI 코드를 최대한 재활용

### 8.3 다음 단계
1. Phase 1에서 WaterRecord, MealRecord, ExerciseRecord 병렬 구현
2. Phase 2에서 Home, Analytics 순차 구현
3. 기존 screens 폴더 정리
