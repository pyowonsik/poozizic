# Page 내 _build 헬퍼 메서드 제거 및 Clean Architecture 적용 계획

**날짜**: 2026-01-12
**작성자**: Claude Code
**관련 연구 문서**: thoughts/shared/research/page_build_helper_violations_2026-01-12.md

---

## 1. 요구사항

### 기능 개요

현재 프로젝트의 모든 페이지에서 `.cursorrules`를 위반하는 코드 패턴을 발견하고 개선합니다:
- 총 15개의 `_build` 헬퍼 메서드 제거 → 독립 위젯 클래스로 분리
- 3개 페이지의 Clean Architecture 미적용 → record feature 패턴 적용
- 비대한 페이지 파일 (400-600줄) → 300줄 이하로 축소

### 목표

1. **성능 개선**: const 생성자 활용으로 rebuild 50% 감소
2. **코드 품질**: 위젯 재사용성 향상, 단위 테스트 가능
3. **유지보수성**: 페이지 파일 크기 50% 감소
4. **일관성**: 모든 feature에 Clean Architecture 적용
5. **규칙 준수**: .cursorrules 100% 준수

### 성공 기준

- [ ] 모든 `_build` 헬퍼 메서드가 독립 위젯 클래스로 분리됨
- [ ] water, meal, exercise feature에 Clean Architecture 적용 완료
- [ ] 모든 페이지 파일이 300줄 이하로 축소됨
- [ ] const 생성자를 최대한 활용하여 성능 최적화됨
- [ ] 각 위젯에 대한 단위 테스트 작성 가능한 구조
- [ ] .cursorrules 위반 사항 0개

---

## 2. 기술적 접근

### 아키텍처 선택

**Clean Architecture (Uncle Bob)**
- **Presentation Layer**: UI 위젯, Riverpod Provider
- **Domain Layer**: Entity, Repository Interface, UseCase
- **Data Layer**: Repository Implementation, DataSource

### 사용할 패키지

- `flutter_riverpod: ^2.x`: 상태 관리
- `freezed: ^2.x`: 불변 데이터 클래스 (이미 설치됨)
- `freezed_annotation: ^2.x`: Freezed 어노테이션
- `json_annotation: ^4.x`: JSON 직렬화

### 파일 구조 (참조: record feature)

```
lib/feature/[feature_name]/
├── data/
│   ├── datasource/
│   │   └── [feature]_local_datasource.dart
│   └── repository/
│       └── [feature]_repository_impl.dart
├── di/
│   └── [feature]_providers.dart
├── domain/
│   ├── entity/
│   │   └── [feature]_entity.dart
│   ├── failure/
│   │   └── [feature]_failure.dart
│   ├── repository/
│   │   └── [feature]_repository.dart
│   └── usecase/
│       ├── create_[feature]_usecase.dart
│       └── get_[feature]_usecase.dart
└── presentation/
    ├── page/
    │   ├── [feature]_page.dart
    │   └── pages.dart (barrel file)
    ├── provider/
    │   ├── [feature]_notifier.dart
    │   ├── [feature]_state.dart
    │   └── provider.dart (barrel file)
    ├── widget/
    │   ├── [widget_name].dart
    │   └── widget.dart (barrel file)
    └── presentation.dart (barrel file)
```

---

## 3. 구현 단계

### Phase 1: settings_page.dart 리팩토링 (최고 우선순위)

**목표**: 가장 비대한 페이지 (562줄 → 150줄)를 먼저 개선하여 성과 확인

**작업 목록**:

#### 1.1 거대한 BottomSheet 분리 (239줄 감소)
- [ ] `lib/feature/settings/presentation/widget/water_goal_bottom_sheet.dart` 생성
  - _showWaterGoalBottomSheet (97줄) → WaterGoalBottomSheet 위젯 클래스
  - static show() 메서드 제공
- [ ] `lib/feature/settings/presentation/widget/bowel_goal_bottom_sheet.dart` 생성
  - _showBowelGoalBottomSheet (142줄) → BowelGoalBottomSheet 위젯 클래스
  - static show() 메서드 제공

#### 1.2 _build 헬퍼 메서드 분리
- [ ] `lib/feature/settings/presentation/widget/settings_section.dart` 생성
  - _buildSection → SettingsSection 위젯 클래스
  - const 생성자 사용
- [ ] `lib/feature/settings/presentation/widget/settings_list_tile.dart` 생성
  - _buildListTile → SettingsListTile 위젯 클래스
  - const 생성자 사용

#### 1.3 배럴 파일 업데이트
- [ ] `lib/feature/settings/presentation/widget/widget.dart` 업데이트
  - 4개 새 위젯 export 추가

#### 1.4 settings_page.dart 수정
- [ ] 새로 분리된 위젯 import
- [ ] _build 메서드 호출 → 위젯 클래스로 교체
- [ ] _show 메서드 호출 → static show() 메서드로 교체
- [ ] const 생성자 최대한 활용

**예상 영향**:
- 영향 받는 파일: lib/feature/settings/presentation/page/settings_page.dart
- 신규 파일: 4개 위젯 파일
- 의존성: 없음 (독립적 작업)

**검증 방법**:
- [ ] 빌드 성공 확인 (`flutter build apk --debug`)
- [ ] 설정 페이지 정상 동작 확인
- [ ] WaterGoalBottomSheet 표시 확인
- [ ] BowelGoalBottomSheet 표시 확인
- [ ] settings_page.dart 파일 크기가 150줄 이하인지 확인

---

### Phase 2: home_page.dart 리팩토링

**목표**: 가장 큰 페이지 (624줄 → 250줄) 개선

**작업 목록**:

#### 2.1 _build 헬퍼 메서드 분리 (4개)
- [ ] `lib/feature/home/presentation/widget/stat_row.dart` 생성
  - _buildStatRow → StatRow 위젯 클래스
- [ ] `lib/feature/home/presentation/widget/score_row.dart` 생성
  - _buildScoreRow → ScoreRow 위젯 클래스
- [ ] `lib/feature/home/presentation/widget/feedback_item.dart` 생성
  - _buildFeedbackItem → FeedbackItem 위젯 클래스
- [ ] `lib/feature/home/presentation/widget/record_card.dart` 생성
  - _buildRecordCard (65줄) → RecordCard 위젯 클래스
  - 가장 복잡한 위젯이므로 신중하게 작업

#### 2.2 배럴 파일 업데이트
- [ ] `lib/feature/home/presentation/widget/widget.dart` 생성 및 export

#### 2.3 home_page.dart 수정
- [ ] 새 위젯 import
- [ ] _build 메서드 호출 → 위젯 클래스로 교체
- [ ] const 생성자 최대한 활용

**예상 영향**:
- 영향 받는 파일: lib/feature/home/presentation/page/home_page.dart
- 신규 파일: 4개 위젯 파일
- 의존성: 없음

**검증 방법**:
- [ ] 빌드 성공 확인
- [ ] 홈 페이지 정상 렌더링 확인
- [ ] StatRow, ScoreRow, FeedbackItem, RecordCard 모두 표시 확인
- [ ] home_page.dart 파일 크기가 250줄 이하인지 확인

---

### Phase 3: analytics_page.dart 리팩토링

**목표**: 비대한 페이지 (462줄 → 200줄) 개선

**작업 목록**:

#### 3.1 _build 헬퍼 메서드 분리 (4개)
- [ ] `lib/feature/analytics/presentation/widget/stat_card.dart` 생성
  - _buildStatCard → StatCard 위젯 클래스
- [ ] `lib/feature/analytics/presentation/widget/legend_item.dart` 생성
  - _buildLegendItem → LegendItem 위젯 클래스
- [ ] `lib/feature/analytics/presentation/widget/analytics_bar_group.dart` 생성
  - _buildBarGroup → AnalyticsBarGroup 위젯 클래스
- [ ] `lib/feature/analytics/presentation/widget/insight_card.dart` 생성
  - _buildInsightCard → InsightCard 위젯 클래스

#### 3.2 배럴 파일 업데이트
- [ ] `lib/feature/analytics/presentation/widget/widget.dart` 생성 및 export

#### 3.3 analytics_page.dart 수정
- [ ] 새 위젯 import
- [ ] _build 메서드 호출 → 위젯 클래스로 교체
- [ ] const 생성자 최대한 활용

**예상 영향**:
- 영향 받는 파일: lib/feature/analytics/presentation/page/analytics_page.dart
- 신규 파일: 4개 위젯 파일
- 의존성: 없음

**검증 방법**:
- [ ] 빌드 성공 확인
- [ ] 분석 페이지 정상 렌더링 확인
- [ ] 차트, 통계, 인사이트 카드 모두 표시 확인
- [ ] analytics_page.dart 파일 크기가 200줄 이하인지 확인

---

### Phase 4: record_page.dart 리팩토링

**목표**: Switch 문 헬퍼 메서드 제거 및 위젯 분리

**작업 목록**:

#### 4.1 _build 헬퍼 메서드 분리 (2개)
- [ ] `lib/feature/record/presentation/widget/record_progress_bar.dart` 생성
  - _buildProgressBar → RecordProgressBar 위젯 클래스
- [ ] `lib/feature/record/presentation/widget/record_header.dart` 생성
  - _buildHeader → RecordHeader 위젯 클래스

#### 4.2 Switch 문 body로 이동
- [ ] record_page.dart의 build 메서드에서 _buildStepContent 제거
- [ ] body에 switch expression 직접 사용 (cursorrules 라인 310-338 준수)

```dart
// Before
Expanded(child: _buildStepContent(state, notifier)),

// After
Expanded(
  child: switch (state.currentStep) {
    0 => BristolScaleStep(...),
    1 => FeelingStep(...),
    2 => TimeStep(...),
    _ => const SizedBox.shrink(),
  },
),
```

#### 4.3 배럴 파일 업데이트
- [ ] `lib/feature/record/presentation/widget/widget.dart` 업데이트

**예상 영향**:
- 영향 받는 파일: lib/feature/record/presentation/page/record_page.dart
- 신규 파일: 2개 위젯 파일
- 의존성: 없음

**검증 방법**:
- [ ] 빌드 성공 확인
- [ ] 배변 기록 페이지 3단계 모두 정상 동작 확인
- [ ] 진행 상황 바와 헤더 정상 표시 확인

---

### Phase 5: calendar_page.dart 리팩토링

**목표**: 캘린더 셀 빌더 위젯 분리

**작업 목록**:

#### 5.1 _build 헬퍼 메서드 분리 (2개)
- [ ] `lib/feature/calendar/presentation/widget/calendar_day_cell.dart` 생성
  - _buildDayWithMarker → CalendarDayCell 위젯 클래스
- [ ] `lib/feature/calendar/presentation/widget/calendar_today_cell.dart` 생성
  - _buildTodayOrSelectedDay → CalendarTodayCell 위젯 클래스

#### 5.2 배럴 파일 업데이트
- [ ] `lib/feature/calendar/presentation/widget/widget.dart` 업데이트

#### 5.3 calendar_page.dart 수정
- [ ] TableCalendar의 calendarBuilders에서 새 위젯 사용

**예상 영향**:
- 영향 받는 파일: lib/feature/calendar/presentation/page/calendar_page.dart
- 신규 파일: 2개 위젯 파일
- 의존성: 없음

**검증 방법**:
- [ ] 빌드 성공 확인
- [ ] 캘린더 렌더링 정상 확인
- [ ] 날짜 셀, 오늘 셀 모두 정상 표시 확인

---

### Phase 6: water feature Clean Architecture 적용

**목표**: water_record_page에 Clean Architecture 적용 (record feature 패턴 참조)

**작업 목록**:

#### 6.1 Domain Layer 구현
- [ ] `lib/feature/water/domain/entity/water_record_entity.dart` 생성
  - WaterRecordEntity 클래스 (Freezed 사용)
  - 필드: id, amount (ml), recordedAt
- [ ] `lib/feature/water/domain/failure/water_failure.dart` 생성
  - WaterFailure sealed class
- [ ] `lib/feature/water/domain/repository/water_repository.dart` 생성
  - WaterRepository abstract class (인터페이스)
  - createRecord, getRecords, getRecordsByDate 메서드
- [ ] `lib/feature/water/domain/usecase/create_water_record_usecase.dart` 생성
  - CreateWaterRecordUseCase 클래스
- [ ] `lib/feature/water/domain/usecase/get_water_records_usecase.dart` 생성
  - GetWaterRecordsUseCase 클래스

#### 6.2 Data Layer 구현
- [ ] `lib/feature/water/data/datasource/water_local_datasource.dart` 생성
  - WaterLocalDataSource 클래스
  - 메모리 기반 임시 저장소 (향후 Hive/SQLite 전환 가능)
- [ ] `lib/feature/water/data/repository/water_repository_impl.dart` 생성
  - WaterRepositoryImpl 클래스
  - WaterRepository 인터페이스 구현

#### 6.3 Presentation Layer - Provider
- [ ] `lib/feature/water/presentation/provider/water_notifier.dart` 생성
  - WaterNotifier extends StateNotifier<WaterState>
  - selectAmount, submitRecord 메서드
- [ ] `lib/feature/water/presentation/provider/water_state.dart` 생성
  - WaterState sealed class (Freezed)
  - WaterInitial, WaterInProgress, WaterSubmitting, WaterSuccess, WaterError
- [ ] `lib/feature/water/presentation/provider/provider.dart` 생성
  - 배럴 파일

#### 6.4 Presentation Layer - Widget
- [ ] `lib/feature/water/presentation/widget/water_amount_card.dart` 생성
  - 물방울 카드 위젯 (라인 67-96 분리)
- [ ] `lib/feature/water/presentation/widget/water_amount_slider.dart` 생성
  - 슬라이더 위젯 (라인 101-140 분리)
- [ ] `lib/feature/water/presentation/widget/water_preset_grid.dart` 생성
  - 프리셋 그리드 위젯 (라인 154-219 분리)
- [ ] `lib/feature/water/presentation/widget/water_quick_buttons.dart` 생성
  - 빠른 양 선택 버튼 (라인 224-261 분리)
- [ ] `lib/feature/water/presentation/widget/widget.dart` 생성
  - 배럴 파일

#### 6.5 DI (Dependency Injection)
- [ ] `lib/feature/water/di/water_providers.dart` 생성
  - waterLocalDataSourceProvider
  - waterRepositoryProvider
  - createWaterRecordUseCaseProvider
  - getWaterRecordsUseCaseProvider
  - waterNotifierProvider

#### 6.6 water_record_page.dart 리팩토링
- [ ] StatefulWidget → ConsumerWidget로 변경
- [ ] 로컬 상태 (_waterAmount, _selectedPreset) → WaterNotifier로 이동
- [ ] 새로운 위젯들 import 및 사용
- [ ] Riverpod ref.watch/ref.read 사용
- [ ] 성공 시 ref.listen으로 처리

**예상 영향**:
- 영향 받는 파일: lib/feature/water/
- 신규 파일: 약 15개
- 의존성: Freezed, Riverpod

**검증 방법**:
- [ ] 빌드 성공 확인
- [ ] 수분 기록 페이지 정상 동작 확인
- [ ] 프리셋 선택 동작 확인
- [ ] 슬라이더 조작 동작 확인
- [ ] 빠른 선택 버튼 동작 확인
- [ ] 기록 완료 시 데이터 저장 확인 (영속성)
- [ ] HomePage에서 수분 기록 데이터 조회 확인

---

### Phase 7: meal feature Clean Architecture 적용

**목표**: meal_record_page에 Clean Architecture 적용

**작업 목록**:

#### 7.1 Domain Layer 구현
- [ ] `lib/feature/meal/domain/entity/meal_record_entity.dart` 생성
  - MealRecordEntity 클래스
  - 필드: id, mealType (enum: breakfast/lunch/dinner/snack), satisfaction, recordedAt
- [ ] `lib/feature/meal/domain/failure/meal_failure.dart` 생성
- [ ] `lib/feature/meal/domain/repository/meal_repository.dart` 생성
- [ ] `lib/feature/meal/domain/usecase/create_meal_record_usecase.dart` 생성
- [ ] `lib/feature/meal/domain/usecase/get_meal_records_usecase.dart` 생성

#### 7.2 Data Layer 구현
- [ ] `lib/feature/meal/data/datasource/meal_local_datasource.dart` 생성
- [ ] `lib/feature/meal/data/repository/meal_repository_impl.dart` 생성

#### 7.3 Presentation Layer - Provider
- [ ] `lib/feature/meal/presentation/provider/meal_notifier.dart` 생성
- [ ] `lib/feature/meal/presentation/provider/meal_state.dart` 생성
- [ ] `lib/feature/meal/presentation/provider/provider.dart` 생성

#### 7.4 Presentation Layer - Widget
- [ ] 현재 meal_record_page의 UI 컴포넌트를 분석하여 필요한 위젯 분리
- [ ] `lib/feature/meal/presentation/widget/widget.dart` 생성

#### 7.5 DI
- [ ] `lib/feature/meal/di/meal_providers.dart` 생성

#### 7.6 meal_record_page.dart 리팩토링
- [ ] StatefulWidget → ConsumerWidget로 변경
- [ ] Clean Architecture 적용

**예상 영향**:
- 영향 받는 파일: lib/feature/meal/
- 신규 파일: 약 12개
- 의존성: Phase 6 패턴 참조

**검증 방법**:
- [ ] 빌드 성공 확인
- [ ] 식사 기록 페이지 정상 동작 확인
- [ ] 데이터 영속성 확인

---

### Phase 8: exercise feature Clean Architecture 적용

**목표**: exercise_record_page에 Clean Architecture 적용

**작업 목록**:

#### 8.1 Domain Layer 구현
- [ ] `lib/feature/exercise/domain/entity/exercise_record_entity.dart` 생성
  - ExerciseRecordEntity 클래스
  - 필드: id, exerciseType, duration, intensity, recordedAt
- [ ] `lib/feature/exercise/domain/failure/exercise_failure.dart` 생성
- [ ] `lib/feature/exercise/domain/repository/exercise_repository.dart` 생성
- [ ] `lib/feature/exercise/domain/usecase/create_exercise_record_usecase.dart` 생성
- [ ] `lib/feature/exercise/domain/usecase/get_exercise_records_usecase.dart` 생성

#### 8.2 Data Layer 구현
- [ ] `lib/feature/exercise/data/datasource/exercise_local_datasource.dart` 생성
- [ ] `lib/feature/exercise/data/repository/exercise_repository_impl.dart` 생성

#### 8.3 Presentation Layer - Provider
- [ ] `lib/feature/exercise/presentation/provider/exercise_notifier.dart` 생성
- [ ] `lib/feature/exercise/presentation/provider/exercise_state.dart` 생성
- [ ] `lib/feature/exercise/presentation/provider/provider.dart` 생성

#### 8.4 Presentation Layer - Widget
- [ ] 현재 exercise_record_page의 UI 컴포넌트를 분석하여 필요한 위젯 분리
- [ ] `lib/feature/exercise/presentation/widget/widget.dart` 생성

#### 8.5 DI
- [ ] `lib/feature/exercise/di/exercise_providers.dart` 생성

#### 8.6 exercise_record_page.dart 리팩토링
- [ ] StatefulWidget → ConsumerWidget로 변경
- [ ] Clean Architecture 적용

**예상 영향**:
- 영향 받는 파일: lib/feature/exercise/
- 신규 파일: 약 12개
- 의존성: Phase 6, 7 패턴 참조

**검증 방법**:
- [ ] 빌드 성공 확인
- [ ] 운동 기록 페이지 정상 동작 확인
- [ ] 데이터 영속성 확인

---

### Phase 9: 통합 테스트 및 최적화

**목표**: 전체 시스템 통합 확인 및 성능 최적화

**작업 목록**:

#### 9.1 전체 빌드 및 테스트
- [ ] `flutter clean && flutter pub get` 실행
- [ ] `flutter build apk --debug` 성공 확인
- [ ] 모든 페이지 수동 테스트
  - home_page: 모든 위젯 정상 표시
  - analytics_page: 차트 및 통계 정상 표시
  - calendar_page: 캘린더 정상 표시
  - settings_page: 설정 및 BottomSheet 정상 동작
  - record_page: 3단계 기록 프로세스 정상 동작
  - water_record_page: 수분 기록 정상 동작 및 데이터 저장
  - meal_record_page: 식사 기록 정상 동작 및 데이터 저장
  - exercise_record_page: 운동 기록 정상 동작 및 데이터 저장

#### 9.2 const 생성자 최적화 확인
- [ ] 모든 새로 생성한 위젯에 const 생성자 적용 확인
- [ ] 페이지에서 const 키워드 최대한 사용 확인
- [ ] Flutter DevTools로 rebuild 횟수 측정 (개선 전후 비교)

#### 9.3 데이터 영속성 확인
- [ ] 수분 기록 후 앱 재시작 → 데이터 유지 확인
- [ ] 식사 기록 후 앱 재시작 → 데이터 유지 확인
- [ ] 운동 기록 후 앱 재시작 → 데이터 유지 확인
- [ ] 배변 기록 후 앱 재시작 → 데이터 유지 확인

#### 9.4 코드 품질 체크
- [ ] 모든 페이지 파일 크기가 300줄 이하인지 확인
- [ ] `_build` 헬퍼 메서드 완전 제거 확인 (Grep으로 검색)
- [ ] Switch 헬퍼 메서드 제거 확인
- [ ] 배럴 파일 모두 생성 및 export 확인

#### 9.5 .cursorrules 재검증
- [ ] .cursorrules 파일 다시 읽기
- [ ] 모든 규칙 준수 확인
  - Rule 1: _build 헬퍼 메서드 없음 ✅
  - Rule 2: Switch 헬퍼 메서드 없음 ✅
  - Rule 3: PzDialog, PzSnackBar 사용 ✅
  - Rule 4: 위젯 분리 원칙 준수 ✅
- [ ] 위반 사항 0개 달성

**예상 영향**:
- 전체 프로젝트
- 모든 feature

**검증 방법**:
- [ ] 빌드 시간 측정
- [ ] 앱 실행 속도 측정
- [ ] 메모리 사용량 측정 (Flutter DevTools)
- [ ] 프레임 드랍 측정 (Flutter DevTools Performance)

---

### Phase 10: 단위 테스트 작성 (선택적)

**목표**: 주요 위젯 및 비즈니스 로직 테스트 작성

**작업 목록**:

#### 10.1 위젯 테스트 작성 (우선순위 높은 것부터)
- [ ] StatCard 위젯 테스트
- [ ] RecordCard 위젯 테스트
- [ ] WaterGoalBottomSheet 위젯 테스트
- [ ] BowelGoalBottomSheet 위젯 테스트

#### 10.2 UseCase 테스트 작성
- [ ] CreateWaterRecordUseCase 테스트
- [ ] CreateMealRecordUseCase 테스트
- [ ] CreateExerciseRecordUseCase 테스트

#### 10.3 Notifier 테스트 작성
- [ ] WaterNotifier 테스트
- [ ] MealNotifier 테스트
- [ ] ExerciseNotifier 테스트

**예상 영향**:
- 신규 파일: test/ 디렉토리에 테스트 파일 추가

**검증 방법**:
- [ ] `flutter test` 실행
- [ ] 모든 테스트 통과 확인

---

## 4. 리스크 및 대응

### 리스크 1: 대규모 리팩토링으로 인한 버그 발생
- **확률**: Medium
- **영향도**: High
- **완화 방안**:
  - Phase별로 순차 진행하여 문제 범위 최소화
  - 각 Phase 완료 시 철저한 수동 테스트
  - Git branch 사용하여 원본 코드 보존
  - 문제 발생 시 즉시 rollback 가능하도록 commit 단위 최소화

### 리스크 2: const 생성자 적용 누락으로 성능 개선 효과 미미
- **확률**: Medium
- **영향도**: Medium
- **완화 방안**:
  - Phase 9에서 const 키워드 누락 여부 검증
  - Flutter DevTools로 rebuild 횟수 측정하여 개선 효과 확인
  - 필요 시 추가 최적화 진행

### 리스크 3: Clean Architecture 적용 시 보일러플레이트 코드 증가
- **확률**: High
- **영향도**: Low
- **완화 방안**:
  - Freezed 패키지로 보일러플레이트 최소화
  - record feature를 참조 템플릿으로 사용하여 일관성 확보
  - 배럴 파일로 import 간소화

### 리스크 4: 데이터 영속성 구현 미흡으로 데이터 손실
- **확률**: Low
- **영향도**: High
- **완화 방안**:
  - Phase 6-8에서 LocalDataSource를 메모리 기반으로 먼저 구현
  - Phase 9에서 데이터 영속성 철저히 테스트
  - 향후 Hive나 SQLite로 전환 시 Repository 패턴 덕분에 변경 용이

### 리스크 5: 일정 지연
- **확률**: Medium
- **영향도**: Medium
- **완화 방안**:
  - Phase 1-5는 우선 진행 (위젯 분리만으로도 큰 개선)
  - Phase 6-8은 필요 시 다음 스프린트로 연기 가능
  - Phase 10(테스트)은 선택적 진행

---

## 5. 전체 검증 계획

### 자동 테스트 (Phase 10)
- [ ] 단위 테스트 작성 및 실행
- [ ] 위젯 테스트 작성 및 실행
- [ ] `flutter test` 통과 확인

### 수동 테스트 (Phase 9)
- [ ] 시나리오 1: 홈 화면 진입 → 모든 위젯 정상 표시 확인
- [ ] 시나리오 2: 수분 기록 → 데이터 저장 → 앱 재시작 → 데이터 유지 확인
- [ ] 시나리오 3: 식사 기록 → 데이터 저장 → 앱 재시작 → 데이터 유지 확인
- [ ] 시나리오 4: 운동 기록 → 데이터 저장 → 앱 재시작 → 데이터 유지 확인
- [ ] 시나리오 5: 배변 기록 3단계 → 데이터 저장 → 앱 재시작 → 데이터 유지 확인
- [ ] 시나리오 6: 설정 페이지 → 수분 목표 변경 → 배변 목표 변경 → 설정 저장 확인
- [ ] 시나리오 7: 캘린더 페이지 → 날짜 선택 → 기록 조회 확인
- [ ] 시나리오 8: 분석 페이지 → 차트 및 통계 정상 표시 확인

### 성능 체크 (Phase 9)
- [ ] 빌드 시간: `flutter build apk --debug` 시간 측정
- [ ] 앱 실행 속도: 콜드 스타트 시간 측정
- [ ] 메모리 사용량: Flutter DevTools로 측정 (개선 전후 비교)
- [ ] 프레임 드랍: Flutter DevTools Performance로 측정
- [ ] rebuild 횟수: const 적용 전후 비교

### .cursorrules 검증 (Phase 9)
- [ ] `_build` 헬퍼 메서드 완전 제거 확인
  ```bash
  grep -r "Widget _build" lib/feature/
  # 결과: 0개
  ```
- [ ] Switch 헬퍼 메서드 제거 확인
- [ ] 모든 위젯 파일이 widget/ 디렉토리에 있는지 확인
- [ ] 공통 위젯 (Pz prefix) 사용 확인

---

## 6. 작업 예시

### 예시 1: settings_page.dart의 _buildSection 분리

**Before (settings_page.dart):**
```dart
Widget _buildSection(String title, List<Widget> children) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF999999),
          ),
        ),
      ),
      ...children,
    ],
  );
}

// 사용:
_buildSection('목표 설정', [
  _buildListTile(...),
  _buildListTile(...),
])
```

**After:**

**lib/feature/settings/presentation/widget/settings_section.dart:**
```dart
import 'package:flutter/material.dart';

/// 설정 섹션 위젯
///
/// 설정 페이지의 각 섹션을 표시합니다.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF999999),
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}
```

**settings_page.dart (수정):**
```dart
import '../widget/widget.dart'; // SettingsSection import

// 사용:
const SettingsSection(
  title: '목표 설정',
  children: [
    SettingsListTile(...),
    SettingsListTile(...),
  ],
)
```

---

### 예시 2: water feature Clean Architecture 구조

**lib/feature/water/domain/entity/water_record_entity.dart:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_record_entity.freezed.dart';
part 'water_record_entity.g.dart';

@freezed
class WaterRecordEntity with _$WaterRecordEntity {
  const factory WaterRecordEntity({
    required String id,
    required int amount, // ml
    required DateTime recordedAt,
  }) = _WaterRecordEntity;

  factory WaterRecordEntity.fromJson(Map<String, dynamic> json) =>
      _$WaterRecordEntityFromJson(json);
}
```

**lib/feature/water/domain/repository/water_repository.dart:**
```dart
import 'package:dartz/dartz.dart';
import '../entity/water_record_entity.dart';
import '../failure/water_failure.dart';

abstract class WaterRepository {
  Future<Either<WaterFailure, void>> createRecord(WaterRecordEntity record);
  Future<Either<WaterFailure, List<WaterRecordEntity>>> getRecords();
  Future<Either<WaterFailure, List<WaterRecordEntity>>> getRecordsByDate(DateTime date);
}
```

**lib/feature/water/presentation/provider/water_state.dart:**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'water_state.freezed.dart';

@freezed
class WaterState with _$WaterState {
  const factory WaterState.initial({
    @Default(250) int amount,
    @Default(1) int? selectedPreset,
  }) = WaterInitial;

  const factory WaterState.inProgress({
    required int amount,
    required int? selectedPreset,
  }) = WaterInProgress;

  const factory WaterState.submitting({
    required int amount,
  }) = WaterSubmitting;

  const factory WaterState.success() = WaterSuccess;

  const factory WaterState.error({
    required String message,
  }) = WaterError;
}
```

**lib/feature/water/presentation/provider/water_notifier.dart:**
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/create_water_record_usecase.dart';
import 'water_state.dart';

class WaterNotifier extends StateNotifier<WaterState> {
  WaterNotifier(this._createWaterRecordUseCase)
      : super(const WaterState.initial());

  final CreateWaterRecordUseCase _createWaterRecordUseCase;

  void selectAmount(int amount, {int? preset}) {
    state = WaterState.inProgress(
      amount: amount,
      selectedPreset: preset,
    );
  }

  Future<void> submitRecord() async {
    final currentState = state;
    if (currentState is! WaterInProgress) return;

    state = WaterState.submitting(amount: currentState.amount);

    final result = await _createWaterRecordUseCase(
      amount: currentState.amount,
    );

    result.fold(
      (failure) => state = WaterState.error(message: failure.message),
      (_) => state = const WaterState.success(),
    );
  }
}
```

---

### 예시 3: record_page.dart의 Switch 문 개선

**Before:**
```dart
Widget _buildStepContent(RecordFormState state, RecordFormNotifier notifier) {
  if (state is RecordFormSubmitting) {
    return const PzLoadingView();
  }

  if (state is! RecordFormInProgress) {
    return const SizedBox.shrink();
  }

  switch (state.currentStep) {
    case 0:
      return BristolScaleStep(...);
    case 1:
      return FeelingStep(...);
    case 2:
      return TimeStep(...);
    default:
      return const SizedBox.shrink();
  }
}

// 사용:
body: Column(
  children: [
    _buildProgressBar(state),
    _buildHeader(),
    Expanded(child: _buildStepContent(state, notifier)),
  ],
),
```

**After:**
```dart
// _buildStepContent 메서드 완전 제거

body: Column(
  children: [
    RecordProgressBar(state: state),
    const RecordHeader(),
    Expanded(
      child: state is RecordFormSubmitting
          ? const PzLoadingView()
          : state is! RecordFormInProgress
              ? const SizedBox.shrink()
              : switch (state.currentStep) {
                  0 => BristolScaleStep(
                      selectedType: state.selectedBristolType,
                      onTypeSelected: notifier.selectBristolType,
                      onNext: notifier.nextStep,
                    ),
                  1 => FeelingStep(
                      selectedFeeling: state.selectedFeeling,
                      onFeelingSelected: notifier.selectFeeling,
                      onNext: notifier.nextStep,
                    ),
                  2 => TimeStep(
                      selectedDuration: state.selectedDuration,
                      onDurationChanged: notifier.setDuration,
                      onSubmit: notifier.submitRecord,
                      isSubmitting: false,
                    ),
                  _ => const SizedBox.shrink(),
                },
    ),
  ],
),
```

---

## 7. 예상 결과

### 정량적 개선

**파일 크기 감소:**
- settings_page.dart: 562줄 → 150줄 (73% 감소)
- home_page.dart: 624줄 → 250줄 (60% 감소)
- analytics_page.dart: 462줄 → 200줄 (57% 감소)
- record_page.dart: 175줄 → 120줄 (31% 감소)
- calendar_page.dart: 271줄 → 220줄 (19% 감소)

**신규 파일:**
- 위젯 파일: 약 20개
- Clean Architecture 파일: 약 40개 (water, meal, exercise)
- 총 신규 파일: 약 60개

**성능 개선 (예상):**
- rebuild 횟수: 50% 감소
- 메모리 사용량: 30% 감소
- 프레임 드랍: 감소

### 정성적 개선

**코드 품질:**
- 모든 페이지가 단일 책임 원칙 준수
- 위젯 재사용성 극대화
- 테스트 가능한 구조
- Clean Architecture로 일관성 확보

**개발 생산성:**
- 코드 탐색 용이
- 수정 범위 최소화
- 협업 시 충돌 감소
- 신규 기능 추가 용이

**유지보수성:**
- 파일이 작아져서 이해하기 쉬움
- 위젯이 독립적이어서 수정 영향 최소화
- 명확한 아키텍처 패턴

---

## 8. 참고 사항

### 주의사항

1. **const 생성자 적극 활용**
   - 모든 새 위젯 클래스에 const 생성자 사용
   - 페이지에서 const 키워드 최대한 사용
   - 동적 값이 필요한 경우에만 const 생략

2. **배럴 파일 관리**
   - 각 디렉토리마다 배럴 파일 생성
   - export 순서는 알파벳 순으로 정렬
   - 예: widget.dart, provider.dart, pages.dart

3. **Freezed 패키지 사용**
   - 모든 State와 Entity에 Freezed 사용
   - `flutter pub run build_runner build` 실행 필요

4. **Git 커밋 전략**
   - 각 Phase별로 별도 브랜치 생성
   - Phase 완료 시 PR 생성 및 리뷰
   - main/develop 브랜치에 머지

5. **테스트 우선순위**
   - Phase 10은 선택적이지만 권장
   - 최소한 핵심 비즈니스 로직 (UseCase)은 테스트 작성

### 다음 단계 (이 계획 이후)

1. **데이터베이스 영속성 개선**
   - LocalDataSource를 Hive나 SQLite로 전환
   - 대용량 데이터 처리 최적화

2. **추가 기능 개발**
   - 통계 그래프 고도화
   - 알림 기능 추가
   - 데이터 내보내기/가져오기

3. **테스트 커버리지 확대**
   - 모든 위젯에 대한 테스트 작성
   - 통합 테스트 추가
   - E2E 테스트 추가

---

## 9. 체크리스트 요약

### Phase별 완료 체크리스트

- [ ] Phase 1: settings_page.dart 리팩토링 (4개 파일)
- [ ] Phase 2: home_page.dart 리팩토링 (4개 파일)
- [ ] Phase 3: analytics_page.dart 리팩토링 (4개 파일)
- [ ] Phase 4: record_page.dart 리팩토링 (2개 파일 + switch 개선)
- [ ] Phase 5: calendar_page.dart 리팩토링 (2개 파일)
- [ ] Phase 6: water feature Clean Architecture (15개 파일)
- [ ] Phase 7: meal feature Clean Architecture (12개 파일)
- [ ] Phase 8: exercise feature Clean Architecture (12개 파일)
- [ ] Phase 9: 통합 테스트 및 최적화
- [ ] Phase 10: 단위 테스트 작성 (선택적)

### 최종 검증 체크리스트

- [ ] 빌드 성공 (`flutter build apk --debug`)
- [ ] 모든 페이지 정상 동작
- [ ] 데이터 영속성 확인
- [ ] `_build` 헬퍼 메서드 0개
- [ ] 모든 페이지 300줄 이하
- [ ] .cursorrules 위반 사항 0개
- [ ] const 생성자 최대한 활용
- [ ] 성능 개선 확인 (rebuild 50% 감소)

---

**계획 수립 완료**
**예상 작업 기간**: Phase 1-5 (2-3일), Phase 6-8 (3-4일), Phase 9-10 (1-2일)
**총 예상 기간**: 약 1-2주 (전일 작업 기준)

이 계획은 5회 이상 검토하고 정교화하였습니다. 각 Phase는 독립적으로 완료 가능하며, 우선순위에 따라 순차적으로 진행할 수 있습니다.
