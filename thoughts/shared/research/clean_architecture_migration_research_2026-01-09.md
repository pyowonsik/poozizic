# poozizic 클린 아키텍처 마이그레이션 연구

**날짜**: 2026-01-09
**분석 대상**: poozizic 프로젝트 (calendar, settings, record 화면)
**참고 프로젝트**: gear_freak_flutter

---

## 1. 프로젝트 개요

### 1.1 poozizic 현재 상태
- **목적**: 배변 기록 및 건강 추적 앱
- **기술 스택**: Flutter (StatefulWidget 기반)
- **현재 구조**: 단순한 screens 폴더 구조, 상태관리 없음

### 1.2 대상 화면 분석

| 화면 | 파일 | 현재 상태 | 주요 기능 |
|------|------|----------|----------|
| **Calendar** | `calendar_screen.dart` | StatefulWidget + 하드코딩 목업 | 캘린더 표시, 기록 조회, 통계 |
| **Settings** | `settings_screen.dart` | StatefulWidget + 로컬 state | 목표 설정, 알림, 프라이버시, 데이터 관리 |
| **Record** | `record_screen.dart` | StatefulWidget + 스텝 UI | Bristol Scale, 배변감, 소요시간 기록 |

---

## 2. gear_freak_flutter 아키텍처 분석

### 2.1 프로젝트 구조
```
lib/
├── core/
│   ├── di/                      # 전역 Provider (현재 비어있음, feature별로 분리됨)
│   ├── route/                   # 라우팅 (go_router)
│   └── util/                    # 유틸리티 함수
│
├── feature/                     # Feature-based 모듈
│   └── chat/                    # 예시: 채팅 기능
│       ├── data/
│       │   ├── datasource/      # Remote/Local DataSource
│       │   ├── repository/      # Repository 구현체
│       │   └── dto/             # Data Transfer Object
│       │
│       ├── domain/
│       │   ├── entity/          # 비즈니스 엔티티
│       │   ├── repository/      # Repository 추상 인터페이스
│       │   ├── usecase/         # UseCase 클래스들
│       │   └── failures/        # Feature별 Failure 클래스
│       │
│       ├── presentation/
│       │   ├── page/            # 화면 Widget
│       │   ├── provider/        # StateNotifier + State
│       │   └── widget/          # 화면별 컴포넌트
│       │
│       └── di/                  # Feature Provider 정의
│           └── chat_providers.dart
│
├── shared/                      # 공유 코드
│   ├── domain/
│   │   ├── failure/failure.dart # 기본 Failure 클래스
│   │   └── usecase/usecase.dart # UseCase 추상 클래스
│   ├── widget/                  # 공용 위젯
│   ├── network/                 # 네트워크 관련 (Interceptor 등)
│   └── service/                 # 공용 서비스
│
└── main.dart
```

### 2.2 핵심 패턴

#### 2.2.1 UseCase 추상 클래스
```dart
// shared/domain/usecase/usecase.dart
abstract class UseCase<T, Params, Repo> {
  Repo get repo;
  Future<Either<Failure, T>> call(Params param);
}
```

#### 2.2.2 Failure 추상 클래스
```dart
// shared/domain/failure/failure.dart
abstract class Failure {
  const Failure(this.message, {this.exception, this.stackTrace});
  final String message;
  final Exception? exception;
  final StackTrace? stackTrace;

  factory Failure.unexpected({required String message, Exception? exception});
  factory Failure.network(String message, {Exception? exception});
  factory Failure.server(String message, {Exception? exception});
  factory Failure.authentication(String message, {Exception? exception});
}
```

#### 2.2.3 Sealed State 패턴
```dart
// feature/chat/presentation/provider/chat_state.dart
sealed class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {
  const ChatInitial({this.product});
  final Product? product;
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  const ChatLoaded({required this.chatRoom, ...});
  final ChatRoomResponseDto chatRoom;
  // ... copyWith 메서드
}

class ChatError extends ChatState {
  const ChatError(this.message);
  final String message;
}
```

#### 2.2.4 StateNotifier 패턴
```dart
// feature/chat/presentation/provider/chat_notifier.dart
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(
    this.ref,
    this.createOrGetChatRoomUseCase,
    this.getChatMessagesUseCase,
    // ... 다른 UseCase들
  ) : super(const ChatInitial());

  final Ref ref;
  final CreateOrGetChatRoomUseCase createOrGetChatRoomUseCase;

  Future<void> loadMessages() async {
    state = const ChatLoading();

    final result = await getChatMessagesUseCase(params);

    result.fold(
      (failure) => state = ChatError(failure.message),
      (messages) => state = ChatLoaded(messages: messages),
    );
  }
}
```

#### 2.2.5 Provider DI 패턴
```dart
// feature/chat/di/chat_providers.dart

/// DataSource Provider
final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  return const ChatRemoteDataSource();
});

/// Repository Provider
final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final remoteDataSource = ref.watch(chatRemoteDataSourceProvider);
  return ChatRepositoryImpl(remoteDataSource);
});

/// UseCase Provider
final getChatMessagesUseCaseProvider = Provider<GetChatMessagesUseCase>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return GetChatMessagesUseCase(repository);
});

/// Notifier Provider
final chatNotifierProvider = StateNotifierProvider.autoDispose<ChatNotifier, ChatState>((ref) {
  final useCase = ref.watch(getChatMessagesUseCaseProvider);
  return ChatNotifier(ref, useCase);
});
```

---

## 3. poozizic 마이그레이션 계획

### 3.1 제안 폴더 구조
```
lib/
├── main.dart
│
├── core/
│   ├── di/
│   │   └── providers.dart          # 전역 Provider (필요시)
│   ├── route/
│   │   └── app_router.dart         # 라우팅 설정
│   └── theme/
│       └── app_theme.dart          # 테마 설정
│
├── feature/
│   │
│   ├── record/                     # 배변 기록 기능
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   ├── record_local_datasource.dart    # 목업 데이터
│   │   │   │   └── record_remote_datasource.dart   # 나중에 API 연동
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
│   │   │   │   ├── get_records_usecase.dart
│   │   │   │   ├── get_records_by_date_usecase.dart
│   │   │   │   └── delete_record_usecase.dart
│   │   │   └── failure/
│   │   │       └── record_failure.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── page/
│   │   │   │   └── record_page.dart        # BowelRecordFlow 마이그레이션
│   │   │   ├── provider/
│   │   │   │   ├── record_state.dart
│   │   │   │   └── record_notifier.dart
│   │   │   └── widget/
│   │   │       ├── bristol_scale_selector.dart
│   │   │       ├── feeling_selector.dart
│   │   │       └── time_selector.dart
│   │   │
│   │   └── di/
│   │       └── record_providers.dart
│   │
│   ├── calendar/                   # 캘린더 기능
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── calendar_local_datasource.dart
│   │   │   └── repository/
│   │   │       └── calendar_repository_impl.dart
│   │   │
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── calendar_statistics.dart
│   │   │   ├── repository/
│   │   │   │   └── calendar_repository.dart
│   │   │   ├── usecase/
│   │   │   │   ├── get_monthly_records_usecase.dart
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
│   │   │       ├── calendar_widget.dart
│   │   │       ├── statistics_card.dart
│   │   │       └── record_card.dart
│   │   │
│   │   └── di/
│   │       └── calendar_providers.dart
│   │
│   └── settings/                   # 설정 기능
│       ├── data/
│       │   ├── datasource/
│       │   │   └── settings_local_datasource.dart  # SharedPreferences
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
│       │   │   ├── update_water_goal_usecase.dart
│       │   │   ├── update_bowel_goal_usecase.dart
│       │   │   └── toggle_notification_usecase.dart
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
│       │       ├── goal_section.dart
│       │       ├── notification_section.dart
│       │       └── privacy_section.dart
│       │
│       └── di/
│           └── settings_providers.dart
│
└── shared/
    ├── domain/
    │   ├── failure/
    │   │   └── failure.dart
    │   └── usecase/
    │       └── usecase.dart
    │
    ├── widget/
    │   ├── app_bar.dart
    │   ├── loading_indicator.dart
    │   └── error_view.dart
    │
    └── util/
        └── date_utils.dart
```

### 3.2 의존성 추가 (pubspec.yaml)
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  dartz: ^0.10.1
  table_calendar: ^3.x.x      # 기존 사용
  intl: ^0.x.x                # 기존 사용
  shared_preferences: ^2.5.x  # 설정 저장용
```

---

## 4. Feature별 상세 구현 계획

### 4.1 Record Feature

#### 4.1.1 Entity
```dart
// feature/record/domain/entity/record_entity.dart
class RecordEntity {
  final int? id;
  final DateTime dateTime;
  final int bristolType;      // 1-7
  final int feeling;          // 0-3 (시원함, 보통, 불편함, 잔변감)
  final int durationMinutes;  // 소요 시간
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
}
```

#### 4.1.2 State
```dart
// feature/record/presentation/provider/record_state.dart
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

  RecordFormInProgress copyWith({...});
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

#### 4.1.3 목업 DataSource
```dart
// feature/record/data/datasource/record_local_datasource.dart
class RecordLocalDataSource {
  // 메모리 내 목업 데이터
  final List<RecordEntity> _mockRecords = [];
  int _nextId = 1;

  Future<RecordEntity> createRecord(RecordEntity record) async {
    await Future.delayed(const Duration(milliseconds: 300)); // 시뮬레이션
    final newRecord = RecordEntity(
      id: _nextId++,
      dateTime: record.dateTime,
      bristolType: record.bristolType,
      feeling: record.feeling,
      durationMinutes: record.durationMinutes,
      memo: record.memo,
      createdAt: DateTime.now(),
    );
    _mockRecords.add(newRecord);
    return newRecord;
  }

  Future<List<RecordEntity>> getAllRecords() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return List.from(_mockRecords);
  }

  Future<List<RecordEntity>> getRecordsByDate(DateTime date) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockRecords.where((r) =>
      r.dateTime.year == date.year &&
      r.dateTime.month == date.month &&
      r.dateTime.day == date.day
    ).toList();
  }
}
```

### 4.2 Calendar Feature

#### 4.2.1 Entity
```dart
// feature/calendar/domain/entity/calendar_statistics.dart
class CalendarStatistics {
  final int monthlyCount;
  final double healthyRatio;
  final double averageInterval;  // 일 단위

  const CalendarStatistics({
    required this.monthlyCount,
    required this.healthyRatio,
    required this.averageInterval,
  });
}
```

#### 4.2.2 State
```dart
// feature/calendar/presentation/provider/calendar_state.dart
sealed class CalendarState {
  const CalendarState();
}

class CalendarInitial extends CalendarState {
  const CalendarInitial();
}

class CalendarLoading extends CalendarState {
  const CalendarLoading();
}

class CalendarLoaded extends CalendarState {
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final Map<DateTime, List<RecordEntity>> recordsByDate;
  final CalendarStatistics statistics;
  final List<RecordEntity> selectedDayRecords;

  const CalendarLoaded({
    required this.focusedDay,
    this.selectedDay,
    required this.recordsByDate,
    required this.statistics,
    this.selectedDayRecords = const [],
  });

  CalendarLoaded copyWith({...});
}

class CalendarError extends CalendarState {
  final String message;
  const CalendarError(this.message);
}
```

### 4.3 Settings Feature

#### 4.3.1 Entity
```dart
// feature/settings/domain/entity/settings_entity.dart
class SettingsEntity {
  // 목표
  final int waterGoal;       // ml
  final int bowelGoal;       // 횟수/일

  // 알림
  final bool bowelReminder;
  final bool waterReminder;
  final bool weeklyReport;

  // 프라이버시
  final bool appLock;
  final bool hideNotificationContent;
  final bool cloudBackup;

  const SettingsEntity({
    this.waterGoal = 2000,
    this.bowelGoal = 1,
    this.bowelReminder = true,
    this.waterReminder = true,
    this.weeklyReport = true,
    this.appLock = false,
    this.hideNotificationContent = false,
    this.cloudBackup = false,
  });

  SettingsEntity copyWith({...});
}
```

#### 4.3.2 State
```dart
// feature/settings/presentation/provider/settings_state.dart
sealed class SettingsState {
  const SettingsState();
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsLoaded extends SettingsState {
  final SettingsEntity settings;
  const SettingsLoaded(this.settings);
}

class SettingsUpdating extends SettingsState {
  final SettingsEntity settings;  // 현재 설정 유지
  const SettingsUpdating(this.settings);
}

class SettingsError extends SettingsState {
  final String message;
  final SettingsEntity? previousSettings;
  const SettingsError(this.message, {this.previousSettings});
}
```

---

## 5. 구현 우선순위

### Phase 1: 기반 구조
1. shared/domain/ 생성 (Failure, UseCase 추상 클래스)
2. pubspec.yaml 의존성 추가
3. main.dart에 ProviderScope 추가

### Phase 2: Record Feature
1. Entity 정의
2. Repository Interface + MockDataSource
3. UseCase 구현
4. State + Notifier 구현
5. Provider 정의
6. UI 마이그레이션 (BowelRecordFlow → ConsumerWidget)

### Phase 3: Calendar Feature
1. record feature와 통합 (RecordRepository 재사용)
2. Statistics 계산 UseCase
3. State + Notifier 구현
4. UI 마이그레이션

### Phase 4: Settings Feature
1. SharedPreferences 연동 DataSource
2. UseCase 구현
3. State + Notifier 구현
4. UI 마이그레이션

---

## 6. 주요 고려사항

### 6.1 목업 데이터 전략
- `RecordLocalDataSource`에서 메모리 내 List로 데이터 관리
- 앱 재시작 시 데이터 초기화 (개발 단계)
- 나중에 `RecordRemoteDataSource`로 쉽게 전환 가능

### 6.2 Feature 간 데이터 공유
- Calendar는 Record의 데이터를 참조해야 함
- `recordRepositoryProvider`를 Calendar에서도 watch하여 사용
- 또는 별도의 `recordsByDateProvider` 생성

### 6.3 UI 마이그레이션 전략
- 기존 StatefulWidget의 UI 코드는 최대한 재사용
- state 관리 로직만 StateNotifier로 이동
- `ConsumerWidget` 또는 `ConsumerStatefulWidget` 사용

### 6.4 테스트 고려
- UseCase와 Repository는 순수 Dart 클래스로 쉽게 테스트 가능
- Mock DataSource로 Provider override 가능
- `ProviderContainer`를 사용한 단위 테스트

---

## 7. 결론

gear_freak_flutter의 클린 아키텍처 패턴을 poozizic에 적용하면:

1. **명확한 관심사 분리**: Data, Domain, Presentation 레이어 분리
2. **테스트 용이성**: UseCase 단위로 비즈니스 로직 테스트 가능
3. **확장성**: 나중에 실제 API 연동 시 DataSource만 교체
4. **유지보수성**: Feature별로 코드가 격리되어 수정 영향 범위 최소화
5. **상태 예측성**: Sealed Class로 모든 가능한 상태 명시

목업 데이터를 사용하면서도 프로덕션 수준의 아키텍처를 적용할 수 있어,
나중에 백엔드 구현 후 최소한의 수정으로 연동 가능합니다.
