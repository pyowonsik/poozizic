# poozizic 클린 아키텍처 마이그레이션 구현 계획

**날짜**: 2026-01-09
**작성자**: Claude
**관련 연구 문서**: `thoughts/shared/research/poozizic_clean_architecture_migration_2026-01-09.md`

---

## 1. 요구사항

### 기능 개요
poozizic 앱의 3개 화면(Calendar, Settings, Record)에 클린 아키텍처와 Riverpod 상태관리를 적용합니다.
백엔드가 아직 구현되지 않았으므로 목업 데이터를 사용합니다.

### 목표
- gear_freak_flutter 프로젝트의 아키텍처 패턴 적용
- Data/Domain/Presentation 레이어 분리
- Riverpod StateNotifier + Sealed State 패턴 적용
- 기존 UI 코드 최대한 재사용

### 성공 기준
- [ ] 앱이 정상적으로 빌드 및 실행됨
- [ ] 3개 화면이 클린 아키텍처로 마이그레이션됨
- [ ] 상태 변경이 UI에 반영됨
- [ ] 목업 데이터로 CRUD 동작 확인

---

## 2. 기술적 접근

### 아키텍처 선택
- **Clean Architecture**: Data/Domain/Presentation 레이어 분리
- **Feature-based 구조**: feature/record, feature/calendar, feature/settings
- **상태관리**: Riverpod StateNotifier + Sealed State

### 사용할 패키지
```yaml
dependencies:
  flutter_riverpod: ^2.6.1   # 상태관리
  dartz: ^0.10.1             # Either 타입 (에러 핸들링)
```

### 파일 구조
```
lib/
├── main.dart                    # ProviderScope 추가
│
├── shared/
│   └── domain/
│       ├── failure/
│       │   └── failure.dart     # 기본 Failure 클래스
│       └── usecase/
│           └── usecase.dart     # UseCase 추상 클래스
│
├── feature/
│   ├── record/                  # 배변 기록 기능
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── record_local_datasource.dart
│   │   │   └── repository/
│   │   │       └── record_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── record_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── record_repository.dart
│   │   │   ├── usecase/
│   │   │   │   ├── create_record_usecase.dart
│   │   │   │   └── get_records_usecase.dart
│   │   │   └── failure/
│   │   │       └── record_failure.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── page/
│   │   │   │   └── record_page.dart
│   │   │   ├── provider/
│   │   │   │   ├── record_form_state.dart
│   │   │   │   └── record_form_notifier.dart
│   │   │   └── widget/
│   │   │       ├── bristol_scale_step.dart
│   │   │       ├── feeling_step.dart
│   │   │       └── time_step.dart
│   │   │
│   │   └── di/
│   │       └── record_providers.dart
│   │
│   ├── calendar/                # 캘린더 기능
│   │   ├── data/
│   │   │   └── repository/
│   │   │       └── calendar_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── calendar_statistics.dart
│   │   │   ├── repository/
│   │   │   │   └── calendar_repository.dart
│   │   │   ├── usecase/
│   │   │   │   ├── get_records_by_month_usecase.dart
│   │   │   │   └── get_statistics_usecase.dart
│   │   │   └── failure/
│   │   │       └── calendar_failure.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── page/
│   │   │   │   └── calendar_page.dart
│   │   │   ├── provider/
│   │   │   │   ├── calendar_state.dart
│   │   │   │   └── calendar_notifier.dart
│   │   │   └── widget/
│   │   │       ├── calendar_header.dart
│   │   │       ├── statistics_card.dart
│   │   │       └── record_list_card.dart
│   │   │
│   │   └── di/
│   │       └── calendar_providers.dart
│   │
│   └── settings/                # 설정 기능
│       ├── data/
│       │   ├── datasource/
│       │   │   └── settings_local_datasource.dart
│       │   └── repository/
│       │       └── settings_repository_impl.dart
│       │
│       ├── domain/
│       │   ├── entity/
│       │   │   └── settings_entity.dart
│       │   ├── repository/
│       │   │   └── settings_repository.dart
│       │   ├── usecase/
│       │   │   ├── get_settings_usecase.dart
│       │   │   └── update_settings_usecase.dart
│       │   └── failure/
│       │       └── settings_failure.dart
│       │
│       ├── presentation/
│       │   ├── page/
│       │   │   └── settings_page.dart
│       │   ├── provider/
│       │   │   ├── settings_state.dart
│       │   │   └── settings_notifier.dart
│       │   └── widget/
│       │       ├── profile_section.dart
│       │       ├── goal_section.dart
│       │       ├── notification_section.dart
│       │       └── privacy_section.dart
│       │
│       └── di/
│           └── settings_providers.dart
│
└── screens/                     # 기존 파일들 (점진적 마이그레이션)
    ├── home_screen.dart         # 유지
    ├── analytics_screen.dart    # 유지
    └── ...
```

---

## 3. 구현 단계

### Phase 1: 기반 구조 설정
**목표**: 클린 아키텍처 기반 구조 및 의존성 설정

**작업 목록**:
- [ ] 1.1. pubspec.yaml에 flutter_riverpod, dartz 추가
- [ ] 1.2. lib/shared/domain/failure/failure.dart 생성
- [ ] 1.3. lib/shared/domain/usecase/usecase.dart 생성
- [ ] 1.4. main.dart에 ProviderScope 래핑

**생성할 파일**:
```
lib/shared/domain/failure/failure.dart
lib/shared/domain/usecase/usecase.dart
```

**예상 영향**:
- pubspec.yaml 수정
- main.dart 수정

**검증 방법**:
- [ ] `flutter pub get` 성공
- [ ] `flutter run` 성공 (기존 기능 동작 확인)

---

### Phase 2: Record Feature 구현
**목표**: 배변 기록 기능을 클린 아키텍처로 구현

**작업 목록**:

#### 2.1 Domain Layer
- [ ] 2.1.1. record_entity.dart 생성
- [ ] 2.1.2. record_repository.dart (인터페이스) 생성
- [ ] 2.1.3. record_failure.dart 생성
- [ ] 2.1.4. create_record_usecase.dart 생성
- [ ] 2.1.5. get_records_usecase.dart 생성
- [ ] 2.1.6. get_records_by_date_usecase.dart 생성

#### 2.2 Data Layer
- [ ] 2.2.1. record_local_datasource.dart 생성 (목업 데이터)
- [ ] 2.2.2. record_repository_impl.dart 생성

#### 2.3 Presentation Layer
- [ ] 2.3.1. record_form_state.dart 생성 (Sealed State)
- [ ] 2.3.2. record_form_notifier.dart 생성 (StateNotifier)
- [ ] 2.3.3. record_providers.dart 생성 (DI)
- [ ] 2.3.4. record_page.dart 생성 (ConsumerStatefulWidget)
- [ ] 2.3.5. bristol_scale_step.dart 생성
- [ ] 2.3.6. feeling_step.dart 생성
- [ ] 2.3.7. time_step.dart 생성

#### 2.4 통합
- [ ] 2.4.1. main.dart에서 BowelRecordFlow 대신 RecordPage 연결

**생성할 파일** (총 14개):
```
lib/feature/record/domain/entity/record_entity.dart
lib/feature/record/domain/repository/record_repository.dart
lib/feature/record/domain/failure/record_failure.dart
lib/feature/record/domain/usecase/create_record_usecase.dart
lib/feature/record/domain/usecase/get_records_usecase.dart
lib/feature/record/domain/usecase/get_records_by_date_usecase.dart
lib/feature/record/data/datasource/record_local_datasource.dart
lib/feature/record/data/repository/record_repository_impl.dart
lib/feature/record/presentation/provider/record_form_state.dart
lib/feature/record/presentation/provider/record_form_notifier.dart
lib/feature/record/presentation/page/record_page.dart
lib/feature/record/presentation/widget/bristol_scale_step.dart
lib/feature/record/presentation/widget/feeling_step.dart
lib/feature/record/presentation/widget/time_step.dart
lib/feature/record/di/record_providers.dart
```

**의존성**: Phase 1 완료 필요

**검증 방법**:
- [ ] Record 화면 진입 시 정상 렌더링
- [ ] Bristol Scale 선택 → 다음 단계 이동
- [ ] Feeling 선택 → 다음 단계 이동
- [ ] Time 설정 → 기록 완료
- [ ] 기록 완료 시 성공 메시지 표시

---

### Phase 3: Calendar Feature 구현
**목표**: 캘린더 화면을 클린 아키텍처로 구현 (Record Repository 재사용)

**작업 목록**:

#### 3.1 Domain Layer
- [ ] 3.1.1. calendar_statistics.dart 생성 (Entity)
- [ ] 3.1.2. calendar_repository.dart (인터페이스) 생성
- [ ] 3.1.3. calendar_failure.dart 생성
- [ ] 3.1.4. get_records_by_month_usecase.dart 생성
- [ ] 3.1.5. get_statistics_usecase.dart 생성

#### 3.2 Data Layer
- [ ] 3.2.1. calendar_repository_impl.dart 생성 (RecordRepository 의존)

#### 3.3 Presentation Layer
- [ ] 3.3.1. calendar_state.dart 생성 (Sealed State)
- [ ] 3.3.2. calendar_notifier.dart 생성 (StateNotifier)
- [ ] 3.3.3. calendar_providers.dart 생성 (DI)
- [ ] 3.3.4. calendar_page.dart 생성 (ConsumerStatefulWidget)
- [ ] 3.3.5. statistics_card.dart 생성
- [ ] 3.3.6. record_list_card.dart 생성

#### 3.4 통합
- [ ] 3.4.1. main.dart에서 CalendarScreen 대신 CalendarPage 연결

**생성할 파일** (총 11개):
```
lib/feature/calendar/domain/entity/calendar_statistics.dart
lib/feature/calendar/domain/repository/calendar_repository.dart
lib/feature/calendar/domain/failure/calendar_failure.dart
lib/feature/calendar/domain/usecase/get_records_by_month_usecase.dart
lib/feature/calendar/domain/usecase/get_statistics_usecase.dart
lib/feature/calendar/data/repository/calendar_repository_impl.dart
lib/feature/calendar/presentation/provider/calendar_state.dart
lib/feature/calendar/presentation/provider/calendar_notifier.dart
lib/feature/calendar/presentation/page/calendar_page.dart
lib/feature/calendar/presentation/widget/statistics_card.dart
lib/feature/calendar/presentation/widget/record_list_card.dart
lib/feature/calendar/di/calendar_providers.dart
```

**의존성**: Phase 2 완료 필요 (RecordRepository 사용)

**검증 방법**:
- [ ] Calendar 화면 진입 시 정상 렌더링
- [ ] 날짜 선택 시 해당 날짜의 기록 표시
- [ ] 월 변경 시 통계 업데이트
- [ ] Record 화면에서 기록 추가 후 Calendar에 반영

---

### Phase 4: Settings Feature 구현
**목표**: 설정 화면을 클린 아키텍처로 구현

**작업 목록**:

#### 4.1 Domain Layer
- [ ] 4.1.1. settings_entity.dart 생성
- [ ] 4.1.2. settings_repository.dart (인터페이스) 생성
- [ ] 4.1.3. settings_failure.dart 생성
- [ ] 4.1.4. get_settings_usecase.dart 생성
- [ ] 4.1.5. update_settings_usecase.dart 생성

#### 4.2 Data Layer
- [ ] 4.2.1. settings_local_datasource.dart 생성 (메모리 목업)
- [ ] 4.2.2. settings_repository_impl.dart 생성

#### 4.3 Presentation Layer
- [ ] 4.3.1. settings_state.dart 생성 (Sealed State)
- [ ] 4.3.2. settings_notifier.dart 생성 (StateNotifier)
- [ ] 4.3.3. settings_providers.dart 생성 (DI)
- [ ] 4.3.4. settings_page.dart 생성 (ConsumerStatefulWidget)
- [ ] 4.3.5. profile_section.dart 생성
- [ ] 4.3.6. goal_section.dart 생성
- [ ] 4.3.7. notification_section.dart 생성
- [ ] 4.3.8. privacy_section.dart 생성

#### 4.4 통합
- [ ] 4.4.1. main.dart에서 SettingsScreen 대신 SettingsPage 연결

**생성할 파일** (총 13개):
```
lib/feature/settings/domain/entity/settings_entity.dart
lib/feature/settings/domain/repository/settings_repository.dart
lib/feature/settings/domain/failure/settings_failure.dart
lib/feature/settings/domain/usecase/get_settings_usecase.dart
lib/feature/settings/domain/usecase/update_settings_usecase.dart
lib/feature/settings/data/datasource/settings_local_datasource.dart
lib/feature/settings/data/repository/settings_repository_impl.dart
lib/feature/settings/presentation/provider/settings_state.dart
lib/feature/settings/presentation/provider/settings_notifier.dart
lib/feature/settings/presentation/page/settings_page.dart
lib/feature/settings/presentation/widget/profile_section.dart
lib/feature/settings/presentation/widget/goal_section.dart
lib/feature/settings/presentation/widget/notification_section.dart
lib/feature/settings/presentation/widget/privacy_section.dart
lib/feature/settings/di/settings_providers.dart
```

**의존성**: Phase 1 완료 필요

**검증 방법**:
- [ ] Settings 화면 진입 시 정상 렌더링
- [ ] 수분 목표 변경 시 UI 반영
- [ ] 배변 목표 변경 시 UI 반영
- [ ] 알림 토글 시 상태 변경
- [ ] 프라이버시 설정 토글 시 상태 변경

---

### Phase 5: 통합 및 최적화
**목표**: 전체 시스템 통합 및 최적화

**작업 목록**:
- [ ] 5.1. Feature 간 데이터 동기화 확인 (Record → Calendar)
- [ ] 5.2. 기존 screens/ 폴더의 calendar_screen.dart, settings_screen.dart, record_screen.dart 삭제
- [ ] 5.3. const 생성자 최적화
- [ ] 5.4. 불필요한 import 정리
- [ ] 5.5. 에러 핸들링 검증

**의존성**: Phase 2, 3, 4 모두 완료 필요

**검증 방법**:
- [ ] 전체 앱 플로우 테스트
- [ ] Record 추가 → Calendar 반영 확인
- [ ] Settings 변경 → 다른 화면에서 참조 가능 확인
- [ ] `flutter analyze` 경고 없음

---

## 4. 리스크 및 대응

### 리스크 1: 기존 UI 코드와 새 아키텍처 충돌
- **확률**: Medium
- **영향도**: Medium
- **완화 방안**:
  - 기존 StatefulWidget의 build() 메서드 내 UI 코드는 최대한 재사용
  - state 로직만 StateNotifier로 분리
  - ConsumerStatefulWidget 사용으로 기존 StatefulWidget 로직 유지 가능

### 리스크 2: Feature 간 데이터 공유 복잡성
- **확률**: Medium
- **영향도**: High
- **완화 방안**:
  - RecordLocalDataSource를 singleton으로 관리
  - Provider에서 동일한 DataSource 인스턴스 공유
  - 상태 변경 시 `ref.invalidate()` 또는 `ref.refresh()` 사용

### 리스크 3: 목업 데이터 앱 재시작 시 초기화
- **확률**: High (예상된 동작)
- **영향도**: Low
- **완화 방안**:
  - 개발 단계에서는 정상 동작
  - 나중에 SharedPreferences 또는 로컬 DB로 전환 예정
  - DataSource만 교체하면 되므로 아키텍처 영향 없음

---

## 5. 전체 검증 계획

### 자동 테스트 (선택적)
- [ ] UseCase 단위 테스트
- [ ] Repository 단위 테스트
- [ ] Notifier 상태 변경 테스트

### 수동 테스트

#### 시나리오 1: 배변 기록 플로우
1. 앱 실행 → FAB(+) 버튼 클릭
2. "배변 기록" 선택
3. Bristol Scale 선택 (Type 4) → "다음" 클릭
4. Feeling 선택 (시원함) → "다음" 클릭
5. Time 설정 (10분) → "기록 완료" 클릭
6. 성공 메시지 확인
7. Calendar 화면으로 이동 → 오늘 날짜에 기록 표시 확인

#### 시나리오 2: 캘린더 조회
1. Calendar 탭 클릭
2. 오늘 날짜 선택
3. 기록된 항목 목록 확인
4. 월 변경 (이전/다음)
5. 통계 카드 업데이트 확인

#### 시나리오 3: 설정 변경
1. Settings 탭 클릭
2. 수분 목표 → 2500ml로 변경
3. 배변 목표 → 2회/일로 변경
4. 알림 토글 변경
5. 앱 내 다른 화면 이동 후 Settings로 돌아와서 설정값 유지 확인

### 성능 체크
- [ ] 빌드 시간 정상
- [ ] 화면 전환 시 지연 없음
- [ ] 메모리 누수 없음 (autoDispose 적용)

---

## 6. 참고 사항

### 주의할 점
- 기존 `screens/` 폴더의 파일들은 Phase 5까지 유지 (점진적 마이그레이션)
- ConsumerStatefulWidget 사용 시 `ref.watch()`는 build() 내에서만 사용
- StateNotifier의 state 변경은 반드시 새 객체로 할당 (immutable)

### 참고 문서
- [flutter_riverpod 공식 문서](https://riverpod.dev/)
- [dartz 패키지](https://pub.dev/packages/dartz)
- gear_freak_flutter 프로젝트 코드 (`/Users/pyowonsik/Downloads/workspace/gear_freak/gear_freak_flutter`)

### 네이밍 컨벤션
- Entity: `XxxEntity` (예: RecordEntity)
- Repository Interface: `XxxRepository` (예: RecordRepository)
- Repository Impl: `XxxRepositoryImpl` (예: RecordRepositoryImpl)
- UseCase: `XxxUseCase` (예: CreateRecordUseCase)
- State: `XxxState` (sealed class) + `XxxInitial`, `XxxLoading`, `XxxLoaded`, `XxxError`
- Notifier: `XxxNotifier` (예: RecordFormNotifier)
- Provider: `xxxProvider` (camelCase, 예: recordFormNotifierProvider)

---

## 7. 파일 생성 순서 요약

### Phase 1 (4개 파일)
1. pubspec.yaml (수정)
2. lib/shared/domain/failure/failure.dart
3. lib/shared/domain/usecase/usecase.dart
4. lib/main.dart (수정 - ProviderScope)

### Phase 2 (15개 파일)
Record Feature 전체

### Phase 3 (12개 파일)
Calendar Feature 전체

### Phase 4 (15개 파일)
Settings Feature 전체

### Phase 5
정리 및 최적화

**총 예상 파일**: 약 42개 신규 + 2개 수정

---

## 8. 핵심 코드 스니펫

### 8.1 shared/domain/failure/failure.dart
```dart
import 'package:dartz/dartz.dart';

/// 실패를 나타내는 추상 클래스
abstract class Failure {
  const Failure(this.message, {this.exception, this.stackTrace});

  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  factory Failure.unexpected({required String message, Exception? exception}) {
    return UnexpectedFailure(message, exception: exception);
  }

  @override
  String toString() => message;
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.exception, super.stackTrace});
}
```

### 8.2 shared/domain/usecase/usecase.dart
```dart
import 'package:dartz/dartz.dart';
import '../failure/failure.dart';

/// UseCase 인터페이스
abstract class UseCase<T, Params, Repo> {
  Repo get repo;
  Future<Either<Failure, T>> call(Params params);
}

/// 파라미터가 필요 없는 UseCase용
class NoParams {
  const NoParams();
}
```

### 8.3 Record Entity 예시
```dart
class RecordEntity {
  final int? id;
  final DateTime dateTime;
  final int bristolType;      // 1-7 (Bristol Scale)
  final int feeling;          // 0: 시원함, 1: 보통, 2: 불편함, 3: 잔변감
  final int durationMinutes;
  final String? memo;
  final DateTime createdAt;

  const RecordEntity({
    this.id,
    required this.dateTime,
    required this.bristolType,
    required this.feeling,
    required this.durationMinutes,
    this.memo,
    required this.createdAt,
  });

  bool get isHealthy => bristolType >= 3 && bristolType <= 5;

  RecordEntity copyWith({
    int? id,
    DateTime? dateTime,
    int? bristolType,
    int? feeling,
    int? durationMinutes,
    String? memo,
    DateTime? createdAt,
  }) {
    return RecordEntity(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      bristolType: bristolType ?? this.bristolType,
      feeling: feeling ?? this.feeling,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

### 8.4 Record Form State (Sealed Class)
```dart
sealed class RecordFormState {
  const RecordFormState();
}

class RecordFormInitial extends RecordFormState {
  const RecordFormInitial();
}

class RecordFormInProgress extends RecordFormState {
  final int currentStep;  // 0: Bristol, 1: Feeling, 2: Time
  final int? selectedBristolType;
  final int? selectedFeeling;
  final int selectedDuration;

  const RecordFormInProgress({
    required this.currentStep,
    this.selectedBristolType,
    this.selectedFeeling,
    this.selectedDuration = 10,
  });

  RecordFormInProgress copyWith({
    int? currentStep,
    int? selectedBristolType,
    int? selectedFeeling,
    int? selectedDuration,
  }) {
    return RecordFormInProgress(
      currentStep: currentStep ?? this.currentStep,
      selectedBristolType: selectedBristolType ?? this.selectedBristolType,
      selectedFeeling: selectedFeeling ?? this.selectedFeeling,
      selectedDuration: selectedDuration ?? this.selectedDuration,
    );
  }
}

class RecordFormSubmitting extends RecordFormState {
  const RecordFormSubmitting();
}

class RecordFormSuccess extends RecordFormState {
  final RecordEntity record;
  const RecordFormSuccess(this.record);
}

class RecordFormError extends RecordFormState {
  final String message;
  const RecordFormError(this.message);
}
```

### 8.5 Record Form Notifier
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'record_form_state.dart';
import '../../domain/usecase/create_record_usecase.dart';
import '../../domain/entity/record_entity.dart';

class RecordFormNotifier extends StateNotifier<RecordFormState> {
  RecordFormNotifier(this._createRecordUseCase)
      : super(const RecordFormInProgress(currentStep: 0));

  final CreateRecordUseCase _createRecordUseCase;

  void selectBristolType(int type) {
    final current = state;
    if (current is RecordFormInProgress) {
      state = current.copyWith(selectedBristolType: type);
    }
  }

  void selectFeeling(int feeling) {
    final current = state;
    if (current is RecordFormInProgress) {
      state = current.copyWith(selectedFeeling: feeling);
    }
  }

  void setDuration(int minutes) {
    final current = state;
    if (current is RecordFormInProgress) {
      state = current.copyWith(selectedDuration: minutes);
    }
  }

  void nextStep() {
    final current = state;
    if (current is RecordFormInProgress && current.currentStep < 2) {
      state = current.copyWith(currentStep: current.currentStep + 1);
    }
  }

  void previousStep() {
    final current = state;
    if (current is RecordFormInProgress && current.currentStep > 0) {
      state = current.copyWith(currentStep: current.currentStep - 1);
    }
  }

  Future<void> submitRecord() async {
    final current = state;
    if (current is! RecordFormInProgress) return;
    if (current.selectedBristolType == null || current.selectedFeeling == null) return;

    state = const RecordFormSubmitting();

    final result = await _createRecordUseCase(
      CreateRecordParams(
        bristolType: current.selectedBristolType!,
        feeling: current.selectedFeeling!,
        durationMinutes: current.selectedDuration,
      ),
    );

    result.fold(
      (failure) => state = RecordFormError(failure.message),
      (record) => state = RecordFormSuccess(record),
    );
  }

  void reset() {
    state = const RecordFormInProgress(currentStep: 0);
  }
}
```

### 8.6 Record Providers (DI)
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/datasource/record_local_datasource.dart';
import '../data/repository/record_repository_impl.dart';
import '../domain/repository/record_repository.dart';
import '../domain/usecase/create_record_usecase.dart';
import '../domain/usecase/get_records_usecase.dart';
import '../domain/usecase/get_records_by_date_usecase.dart';
import '../presentation/provider/record_form_state.dart';
import '../presentation/provider/record_form_notifier.dart';

/// DataSource Provider (Singleton)
final recordLocalDataSourceProvider = Provider<RecordLocalDataSource>((ref) {
  return RecordLocalDataSource();
});

/// Repository Provider
final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  final dataSource = ref.watch(recordLocalDataSourceProvider);
  return RecordRepositoryImpl(dataSource);
});

/// UseCase Providers
final createRecordUseCaseProvider = Provider<CreateRecordUseCase>((ref) {
  final repository = ref.watch(recordRepositoryProvider);
  return CreateRecordUseCase(repository);
});

final getRecordsUseCaseProvider = Provider<GetRecordsUseCase>((ref) {
  final repository = ref.watch(recordRepositoryProvider);
  return GetRecordsUseCase(repository);
});

final getRecordsByDateUseCaseProvider = Provider<GetRecordsByDateUseCase>((ref) {
  final repository = ref.watch(recordRepositoryProvider);
  return GetRecordsByDateUseCase(repository);
});

/// Notifier Provider
final recordFormNotifierProvider =
    StateNotifierProvider.autoDispose<RecordFormNotifier, RecordFormState>((ref) {
  final createRecordUseCase = ref.watch(createRecordUseCaseProvider);
  return RecordFormNotifier(createRecordUseCase);
});

/// Records List Provider (for Calendar)
final recordsProvider = FutureProvider<List<RecordEntity>>((ref) async {
  final useCase = ref.watch(getRecordsUseCaseProvider);
  final result = await useCase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (records) => records,
  );
});
```

### 8.7 main.dart 수정 예시
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';  // 추가
import 'package:intl/date_symbol_data_local.dart';
// ... 기존 imports

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  runApp(
    const ProviderScope(  // 추가: ProviderScope로 래핑
      child: MyApp(),
    ),
  );
}

// ... 나머지 코드는 동일
```

---

## 9. 구현 시 주의사항

### 9.1 ConsumerStatefulWidget 사용 패턴
```dart
class RecordPage extends ConsumerStatefulWidget {
  const RecordPage({super.key});

  @override
  ConsumerState<RecordPage> createState() => _RecordPageState();
}

class _RecordPageState extends ConsumerState<RecordPage> {
  @override
  Widget build(BuildContext context) {
    // ref.watch는 build() 내에서만 사용
    final state = ref.watch(recordFormNotifierProvider);

    return switch (state) {
      RecordFormInitial() => const SizedBox.shrink(),
      RecordFormInProgress(:final currentStep) => _buildStepContent(currentStep),
      RecordFormSubmitting() => const Center(child: CircularProgressIndicator()),
      RecordFormSuccess(:final record) => _buildSuccess(record),
      RecordFormError(:final message) => _buildError(message),
    };
  }

  void _onNextPressed() {
    // ref.read는 콜백/이벤트 핸들러에서 사용
    ref.read(recordFormNotifierProvider.notifier).nextStep();
  }
}
```

### 9.2 Feature 간 데이터 공유
- `recordLocalDataSourceProvider`가 singleton이므로 Calendar에서도 동일한 데이터 접근 가능
- Record 추가 후 Calendar 갱신: `ref.invalidate(recordsProvider)` 호출

### 9.3 autoDispose vs 일반 Provider
- **autoDispose 사용**: `recordFormNotifierProvider` (화면 이탈 시 상태 초기화)
- **일반 Provider 사용**: `recordLocalDataSourceProvider` (데이터 유지 필요)

---

## 10. 실행 명령어

### Phase 1 완료 후
```bash
cd /Users/pyowonsik/Downloads/workspace/poozizic
flutter pub get
flutter run
```

### Phase 2-4 각 완료 후
```bash
flutter analyze
flutter run
```

### 전체 완료 후
```bash
flutter analyze
flutter test  # 테스트 작성 시
flutter run --release  # 릴리즈 빌드 테스트
```
