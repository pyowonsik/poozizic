# Supabase 백엔드 통합 구현 계획

**날짜**: 2026-01-10
**작성자**: Claude
**관련 연구 문서**: thoughts/shared/research/poozizic_supabase_integration_2026-01-10.md

---

## 1. 요구사항

### 기능 개요
Poozizic(뿌지직) 배변 건강 관리 앱에 Supabase 백엔드를 통합하여 다음 기능을 구현합니다:
- 사용자 인증 (회원가입/로그인/로그아웃)
- 클라우드 데이터 저장 및 동기화
- 다중 디바이스 지원

### 목표
- 현재 메모리 기반 Mock 데이터를 Supabase PostgreSQL로 마이그레이션
- Clean Architecture 패턴 유지
- 기존 UI 코드 최소 변경
- 오프라인 지원 (선택적)

### 성공 기준
- [ ] 사용자가 이메일/비밀번호로 회원가입 및 로그인 가능
- [ ] 배변/식사/수분/운동 기록이 Supabase에 저장됨
- [ ] 설정이 클라우드에 동기화됨
- [ ] 앱 재시작 후에도 데이터 유지
- [ ] 다른 기기에서 로그인 시 동일 데이터 접근 가능

---

## 2. 기술적 접근

### 아키텍처 선택
**Clean Architecture** (기존 패턴 유지)
```
presentation (UI) → domain (UseCase/Entity) → data (Repository/DataSource)
```

### 데이터 소스 전략
**이중 DataSource 패턴 채택**
```
Repository
├── RemoteDataSource (Supabase) - Primary
└── LocalDataSource (Hive Cache) - Fallback/Offline
```

### 사용할 패키지
| 패키지 | 버전 | 용도 |
|--------|------|------|
| supabase_flutter | ^2.3.0 | Supabase SDK |
| hive_flutter | ^1.1.0 | 로컬 캐시 |
| connectivity_plus | ^5.0.0 | 네트워크 상태 |
| flutter_secure_storage | ^9.0.0 | 토큰 저장 |
| flutter_dotenv | ^5.1.0 | 환경 변수 |
| freezed_annotation | ^2.4.1 | 모델 코드 생성 |
| json_annotation | ^4.8.1 | JSON 직렬화 |

### 파일 구조 (신규 및 수정)
```
lib/
├── core/
│   ├── supabase/
│   │   ├── supabase_config.dart          # Supabase 설정
│   │   └── supabase_client.dart          # 클라이언트 래퍼
│   ├── network/
│   │   └── network_info.dart             # 네트워크 상태
│   └── error/
│       └── supabase_exception.dart       # Supabase 예외
│
├── feature/
│   ├── auth/                              # 신규 Feature
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── auth_remote_datasource.dart
│   │   │   ├── model/
│   │   │   │   └── user_model.dart
│   │   │   └── repository/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── user_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── auth_repository.dart
│   │   │   ├── failure/
│   │   │   │   └── auth_failure.dart
│   │   │   └── usecase/
│   │   │       ├── sign_in_usecase.dart
│   │   │       ├── sign_up_usecase.dart
│   │   │       ├── sign_out_usecase.dart
│   │   │       └── get_current_user_usecase.dart
│   │   ├── presentation/
│   │   │   ├── page/
│   │   │   │   ├── login_page.dart
│   │   │   │   ├── register_page.dart
│   │   │   │   └── splash_page.dart
│   │   │   ├── provider/
│   │   │   │   ├── auth_notifier.dart
│   │   │   │   └── auth_state.dart
│   │   │   └── widget/
│   │   │       ├── auth_text_field.dart
│   │   │       └── social_login_button.dart
│   │   └── di/
│   │       └── auth_providers.dart
│   │
│   ├── record/                            # 기존 수정
│   │   └── data/
│   │       ├── datasource/
│   │       │   ├── record_local_datasource.dart   # 기존
│   │       │   └── record_remote_datasource.dart  # 신규
│   │       ├── model/
│   │       │   └── record_model.dart              # 신규
│   │       └── repository/
│   │           └── record_repository_impl.dart    # 수정
│   │
│   ├── meal/                              # 신규 Feature
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── meal_remote_datasource.dart
│   │   │   ├── model/
│   │   │   │   └── meal_model.dart
│   │   │   └── repository/
│   │   │       └── meal_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── meal_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── meal_repository.dart
│   │   │   ├── failure/
│   │   │   │   └── meal_failure.dart
│   │   │   └── usecase/
│   │   │       ├── create_meal_usecase.dart
│   │   │       ├── get_meals_by_date_usecase.dart
│   │   │       └── delete_meal_usecase.dart
│   │   ├── presentation/
│   │   │   ├── page/
│   │   │   │   └── meal_record_page.dart  # screens에서 이동
│   │   │   └── provider/
│   │   │       ├── meal_notifier.dart
│   │   │       └── meal_state.dart
│   │   └── di/
│   │       └── meal_providers.dart
│   │
│   ├── water/                             # 신규 Feature
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── water_remote_datasource.dart
│   │   │   ├── model/
│   │   │   │   └── water_model.dart
│   │   │   └── repository/
│   │   │       └── water_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── water_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── water_repository.dart
│   │   │   ├── failure/
│   │   │   │   └── water_failure.dart
│   │   │   └── usecase/
│   │   │       ├── create_water_record_usecase.dart
│   │   │       ├── get_water_by_date_usecase.dart
│   │   │       └── get_today_water_total_usecase.dart
│   │   ├── presentation/
│   │   │   ├── page/
│   │   │   │   └── water_record_page.dart  # screens에서 이동
│   │   │   └── provider/
│   │   │       ├── water_notifier.dart
│   │   │       └── water_state.dart
│   │   └── di/
│   │       └── water_providers.dart
│   │
│   ├── exercise/                          # 신규 Feature
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── exercise_remote_datasource.dart
│   │   │   ├── model/
│   │   │   │   └── exercise_model.dart
│   │   │   └── repository/
│   │   │       └── exercise_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── exercise_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── exercise_repository.dart
│   │   │   ├── failure/
│   │   │   │   └── exercise_failure.dart
│   │   │   └── usecase/
│   │   │       ├── create_exercise_usecase.dart
│   │   │       └── get_exercises_by_date_usecase.dart
│   │   ├── presentation/
│   │   │   ├── page/
│   │   │   │   └── exercise_record_page.dart  # screens에서 이동
│   │   │   └── provider/
│   │   │       ├── exercise_notifier.dart
│   │   │       └── exercise_state.dart
│   │   └── di/
│   │       └── exercise_providers.dart
│   │
│   └── settings/                          # 기존 수정
│       └── data/
│           ├── datasource/
│           │   ├── settings_local_datasource.dart   # 기존
│           │   └── settings_remote_datasource.dart  # 신규
│           ├── model/
│           │   └── settings_model.dart              # 신규
│           └── repository/
│               └── settings_repository_impl.dart    # 수정
│
└── screens/                               # 삭제 예정 (feature로 이동)
    ├── meal_record_screen.dart            # → feature/meal/로 이동
    ├── water_record_screen.dart           # → feature/water/로 이동
    └── exercise_record_screen.dart        # → feature/exercise/로 이동
```

---

## 3. 구현 단계

### Phase 1: 프로젝트 기반 설정
**목표**: Supabase 연동을 위한 기본 환경 설정

**작업 목록**:
- [ ] **1.1** pubspec.yaml에 패키지 추가
  ```yaml
  dependencies:
    supabase_flutter: ^2.3.0
    hive_flutter: ^1.1.0
    connectivity_plus: ^5.0.0
    flutter_secure_storage: ^9.0.0
    flutter_dotenv: ^5.1.0
    freezed_annotation: ^2.4.1
    json_annotation: ^4.8.1

  dev_dependencies:
    freezed: ^2.4.5
    json_serializable: ^6.7.1
    hive_generator: ^2.0.1
    build_runner: ^2.4.7
  ```

- [ ] **1.2** 환경 변수 파일 생성
  - `.env` 파일 생성 (gitignore에 추가)
  - `.env.example` 파일 생성 (템플릿)
  ```
  SUPABASE_URL=your_supabase_url
  SUPABASE_ANON_KEY=your_anon_key
  ```

- [ ] **1.3** `lib/core/supabase/supabase_config.dart` 생성
  ```dart
  import 'package:flutter_dotenv/flutter_dotenv.dart';
  import 'package:supabase_flutter/supabase_flutter.dart';

  class SupabaseConfig {
    static String get url => dotenv.env['SUPABASE_URL'] ?? '';
    static String get anonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

    static Future<void> initialize() async {
      await dotenv.load();
      await Supabase.initialize(url: url, anonKey: anonKey);
    }

    static SupabaseClient get client => Supabase.instance.client;
  }
  ```

- [ ] **1.4** `lib/core/network/network_info.dart` 생성
  ```dart
  import 'package:connectivity_plus/connectivity_plus.dart';

  abstract class NetworkInfo {
    Future<bool> get isConnected;
    Stream<bool> get onConnectivityChanged;
  }

  class NetworkInfoImpl implements NetworkInfo {
    final Connectivity _connectivity;
    NetworkInfoImpl(this._connectivity);

    @override
    Future<bool> get isConnected async {
      final result = await _connectivity.checkConnectivity();
      return result != ConnectivityResult.none;
    }

    @override
    Stream<bool> get onConnectivityChanged {
      return _connectivity.onConnectivityChanged
          .map((result) => result != ConnectivityResult.none);
    }
  }
  ```

- [ ] **1.5** `lib/core/error/supabase_exception.dart` 생성

- [ ] **1.6** `lib/main.dart` 수정 (Supabase 초기화 추가)

**예상 영향**:
- 영향 받는 파일: `pubspec.yaml`, `lib/main.dart`
- 신규 파일: 4개 (`supabase_config.dart`, `network_info.dart`, `supabase_exception.dart`, `.env`)

**검증 방법**:
- [ ] `flutter pub get` 성공
- [ ] 앱 빌드 성공
- [ ] Supabase 초기화 로그 확인

---

### Phase 2: 인증 Feature 구현
**목표**: 사용자 인증 (회원가입/로그인/로그아웃) 기능 구현

**작업 목록**:
- [ ] **2.1** `lib/feature/auth/domain/entity/user_entity.dart` 생성
  ```dart
  class UserEntity {
    final String id;
    final String email;
    final String? displayName;
    final DateTime createdAt;

    const UserEntity({
      required this.id,
      required this.email,
      this.displayName,
      required this.createdAt,
    });
  }
  ```

- [ ] **2.2** `lib/feature/auth/domain/failure/auth_failure.dart` 생성
  - `InvalidCredentialsFailure`
  - `EmailAlreadyInUseFailure`
  - `WeakPasswordFailure`
  - `NetworkFailure`

- [ ] **2.3** `lib/feature/auth/domain/repository/auth_repository.dart` 생성
  ```dart
  abstract class AuthRepository {
    Future<Either<Failure, UserEntity>> signIn(String email, String password);
    Future<Either<Failure, UserEntity>> signUp(String email, String password);
    Future<Either<Failure, void>> signOut();
    Future<Either<Failure, UserEntity?>> getCurrentUser();
    Stream<UserEntity?> get authStateChanges;
  }
  ```

- [ ] **2.4** `lib/feature/auth/data/model/user_model.dart` 생성
  - `UserEntity`를 상속
  - `fromJson`, `toJson` 메서드

- [ ] **2.5** `lib/feature/auth/data/datasource/auth_remote_datasource.dart` 생성
  - Supabase Auth API 호출

- [ ] **2.6** `lib/feature/auth/data/repository/auth_repository_impl.dart` 생성

- [ ] **2.7** UseCase 생성 (4개)
  - `sign_in_usecase.dart`
  - `sign_up_usecase.dart`
  - `sign_out_usecase.dart`
  - `get_current_user_usecase.dart`

- [ ] **2.8** `lib/feature/auth/presentation/provider/auth_state.dart` 생성
  ```dart
  enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

  class AuthState {
    final AuthStatus status;
    final UserEntity? user;
    final String? errorMessage;
  }
  ```

- [ ] **2.9** `lib/feature/auth/presentation/provider/auth_notifier.dart` 생성

- [ ] **2.10** `lib/feature/auth/di/auth_providers.dart` 생성

- [ ] **2.11** UI 구현
  - `splash_page.dart` (인증 상태 확인)
  - `login_page.dart`
  - `register_page.dart`

- [ ] **2.12** 라우팅 로직 수정 (`main.dart`)
  - 인증 상태에 따른 초기 화면 분기

**예상 영향**:
- 신규 파일: 약 15개
- 수정 파일: `main.dart`

**검증 방법**:
- [ ] 회원가입 → Supabase Auth에 사용자 생성 확인
- [ ] 로그인 → 앱 내부로 진입
- [ ] 로그아웃 → 로그인 화면으로 이동
- [ ] 앱 재시작 → 세션 유지 확인

---

### Phase 3: 배변 기록 Supabase 연동
**목표**: 기존 Record Feature에 Supabase Remote DataSource 추가

**작업 목록**:
- [ ] **3.1** `lib/feature/record/data/model/record_model.dart` 생성
  ```dart
  class RecordModel extends RecordEntity {
    RecordModel({...});

    factory RecordModel.fromJson(Map<String, dynamic> json);
    Map<String, dynamic> toJson();
    factory RecordModel.fromEntity(RecordEntity entity);
  }
  ```

- [ ] **3.2** `lib/feature/record/data/datasource/record_remote_datasource.dart` 생성
  ```dart
  class RecordRemoteDataSource {
    final SupabaseClient _client;

    Future<RecordModel> createRecord(RecordModel record);
    Future<List<RecordModel>> getRecordsByDate(DateTime date);
    Future<List<RecordModel>> getRecordsByMonth(int year, int month);
    Future<void> deleteRecord(String id);
  }
  ```

- [ ] **3.3** `lib/feature/record/domain/entity/record_entity.dart` 수정
  - `id` 타입을 `int?`에서 `String?`으로 변경 (UUID)

- [ ] **3.4** `lib/feature/record/domain/repository/record_repository.dart` 수정
  - 반환 타입을 `Either<Failure, T>`로 통일

- [ ] **3.5** `lib/feature/record/data/repository/record_repository_impl.dart` 수정
  - Remote DataSource 우선, Local DataSource 폴백
  - 네트워크 상태 확인

- [ ] **3.6** `lib/feature/record/di/record_providers.dart` 수정
  - Remote DataSource Provider 추가
  - Repository Provider 수정

- [ ] **3.7** 기존 UseCase 및 Notifier 수정
  - 에러 핸들링 개선

**예상 영향**:
- 신규 파일: 2개 (`record_model.dart`, `record_remote_datasource.dart`)
- 수정 파일: 6개

**검증 방법**:
- [ ] 기록 생성 → Supabase `bowel_records` 테이블에 저장 확인
- [ ] 기록 조회 → UI에 표시
- [ ] 기록 삭제 → 테이블에서 삭제 확인
- [ ] 오프라인 시 로컬 캐시 동작 확인

---

### Phase 4: 식사/수분/운동 기록 Feature 생성
**목표**: 현재 screens에 있는 UI를 Clean Architecture Feature로 리팩토링

#### Phase 4.1: 식사 기록 (Meal) Feature
**작업 목록**:
- [ ] **4.1.1** `lib/feature/meal/domain/entity/meal_entity.dart` 생성
- [ ] **4.1.2** `lib/feature/meal/domain/failure/meal_failure.dart` 생성
- [ ] **4.1.3** `lib/feature/meal/domain/repository/meal_repository.dart` 생성
- [ ] **4.1.4** `lib/feature/meal/domain/usecase/*.dart` 생성 (3개)
- [ ] **4.1.5** `lib/feature/meal/data/model/meal_model.dart` 생성
- [ ] **4.1.6** `lib/feature/meal/data/datasource/meal_remote_datasource.dart` 생성
- [ ] **4.1.7** `lib/feature/meal/data/repository/meal_repository_impl.dart` 생성
- [ ] **4.1.8** `lib/feature/meal/presentation/provider/*` 생성
- [ ] **4.1.9** `lib/screens/meal_record_screen.dart` → `lib/feature/meal/presentation/page/meal_record_page.dart` 이동 및 리팩토링
- [ ] **4.1.10** `lib/feature/meal/di/meal_providers.dart` 생성

#### Phase 4.2: 수분 기록 (Water) Feature
**작업 목록**:
- [ ] **4.2.1** `lib/feature/water/domain/entity/water_entity.dart` 생성
- [ ] **4.2.2** `lib/feature/water/domain/failure/water_failure.dart` 생성
- [ ] **4.2.3** `lib/feature/water/domain/repository/water_repository.dart` 생성
- [ ] **4.2.4** `lib/feature/water/domain/usecase/*.dart` 생성 (3개)
- [ ] **4.2.5** `lib/feature/water/data/model/water_model.dart` 생성
- [ ] **4.2.6** `lib/feature/water/data/datasource/water_remote_datasource.dart` 생성
- [ ] **4.2.7** `lib/feature/water/data/repository/water_repository_impl.dart` 생성
- [ ] **4.2.8** `lib/feature/water/presentation/provider/*` 생성
- [ ] **4.2.9** `lib/screens/water_record_screen.dart` → `lib/feature/water/presentation/page/water_record_page.dart` 이동 및 리팩토링
- [ ] **4.2.10** `lib/feature/water/di/water_providers.dart` 생성

#### Phase 4.3: 운동 기록 (Exercise) Feature
**작업 목록**:
- [ ] **4.3.1** `lib/feature/exercise/domain/entity/exercise_entity.dart` 생성
- [ ] **4.3.2** `lib/feature/exercise/domain/failure/exercise_failure.dart` 생성
- [ ] **4.3.3** `lib/feature/exercise/domain/repository/exercise_repository.dart` 생성
- [ ] **4.3.4** `lib/feature/exercise/domain/usecase/*.dart` 생성 (2개)
- [ ] **4.3.5** `lib/feature/exercise/data/model/exercise_model.dart` 생성
- [ ] **4.3.6** `lib/feature/exercise/data/datasource/exercise_remote_datasource.dart` 생성
- [ ] **4.3.7** `lib/feature/exercise/data/repository/exercise_repository_impl.dart` 생성
- [ ] **4.3.8** `lib/feature/exercise/presentation/provider/*` 생성
- [ ] **4.3.9** `lib/screens/exercise_record_screen.dart` → `lib/feature/exercise/presentation/page/exercise_record_page.dart` 이동 및 리팩토링
- [ ] **4.3.10** `lib/feature/exercise/di/exercise_providers.dart` 생성

**예상 영향**:
- 신규 파일: 약 30개
- 삭제 파일: 3개 (`screens/` 하위)
- 수정 파일: `main.dart` (import 경로)

**검증 방법**:
- [ ] 식사 기록 생성/조회 동작
- [ ] 수분 기록 생성/조회 동작
- [ ] 운동 기록 생성/조회 동작
- [ ] 각 Supabase 테이블에 데이터 저장 확인

---

### Phase 5: 설정 Feature Supabase 연동
**목표**: 사용자 설정을 Supabase에 동기화

**작업 목록**:
- [ ] **5.1** `lib/feature/settings/data/model/settings_model.dart` 생성

- [ ] **5.2** `lib/feature/settings/data/datasource/settings_remote_datasource.dart` 생성
  ```dart
  class SettingsRemoteDataSource {
    Future<SettingsModel> getSettings(String userId);
    Future<SettingsModel> updateSettings(String userId, SettingsModel settings);
  }
  ```

- [ ] **5.3** `lib/feature/settings/data/repository/settings_repository_impl.dart` 수정
  - 로그인 상태에 따라 Remote/Local 분기
  - 초기 로드 시 Remote → Local 동기화

- [ ] **5.4** `lib/feature/settings/di/settings_providers.dart` 수정

**예상 영향**:
- 신규 파일: 2개
- 수정 파일: 2개

**검증 방법**:
- [ ] 설정 변경 → Supabase `user_settings` 업데이트 확인
- [ ] 다른 기기 로그인 → 동일 설정 확인
- [ ] 로그아웃 → 로컬 설정 초기화

---

### Phase 6: 홈 화면 및 캘린더 연동
**목표**: 홈 화면과 캘린더에서 실제 데이터 표시

**작업 목록**:
- [ ] **6.1** `lib/screens/home_screen.dart` 수정
  - 하드코딩 데이터 제거
  - Provider를 통한 실제 데이터 바인딩
  - 오늘 수분 섭취량 표시
  - 최근 기록 표시

- [ ] **6.2** `lib/feature/calendar/` 수정
  - 식사/수분/운동 기록도 캘린더에 표시
  - 통계 계산 로직 확장

- [ ] **6.3** 분석 화면 (`analytics_screen.dart`) 데이터 연동
  - 주간/월간 통계
  - 차트 데이터 바인딩

**예상 영향**:
- 수정 파일: 4~5개

**검증 방법**:
- [ ] 홈 화면에 실제 기록 표시
- [ ] 캘린더에 모든 종류 기록 표시
- [ ] 통계가 실제 데이터 반영

---

### Phase 7: 오프라인 지원 (선택)
**목표**: 네트워크 없이도 앱 사용 가능

**작업 목록**:
- [ ] **7.1** Hive 로컬 DB 설정
  - TypeAdapter 생성
  - Box 초기화

- [ ] **7.2** 각 Feature에 Local DataSource 추가
  - 오프라인 CRUD 지원

- [ ] **7.3** 동기화 서비스 구현
  ```dart
  class SyncService {
    Future<void> syncPendingRecords();
    Future<void> pullLatestFromServer();
    Future<void> handleConflict(LocalRecord, RemoteRecord);
  }
  ```

- [ ] **7.4** 네트워크 상태 UI 표시

**예상 영향**:
- 신규 파일: 약 10개 (TypeAdapter, Local DataSource, SyncService)
- 수정 파일: 각 Repository

**검증 방법**:
- [ ] 비행기 모드에서 기록 생성
- [ ] 네트워크 복구 후 자동 동기화
- [ ] 충돌 발생 시 적절한 해결

---

### Phase 8: 테스트 및 정리
**목표**: 안정성 확보 및 코드 정리

**작업 목록**:
- [ ] **8.1** Unit 테스트 작성
  - Repository 테스트
  - UseCase 테스트
  - DataSource Mock 테스트

- [ ] **8.2** Widget 테스트 작성
  - 로그인 화면 테스트
  - 기록 화면 테스트

- [ ] **8.3** 통합 테스트 작성
  - 인증 플로우 테스트
  - 기록 생성-조회 플로우 테스트

- [ ] **8.4** 코드 정리
  - 사용하지 않는 파일 삭제
  - import 정리
  - 문서화

**예상 영향**:
- 신규 파일: 테스트 파일 10~15개

**검증 방법**:
- [ ] `flutter test` 전체 통과
- [ ] 코드 커버리지 70% 이상

---

## 4. 리스크 및 대응

### 리스크 1: Entity ID 타입 변경 (int → String/UUID)
- **확률**: 확정
- **영향도**: Medium
- **완화 방안**:
  - Phase 3에서 점진적 마이그레이션
  - 기존 로컬 데이터는 버리고 새로 시작 (MVP 단계이므로 OK)

### 리스크 2: RLS 정책 오류
- **확률**: Medium
- **영향도**: High (데이터 접근 불가)
- **완화 방안**:
  - Supabase 대시보드에서 정책 테스트
  - 로그 모니터링
  - Fallback으로 anon key 권한 확인

### 리스크 3: 오프라인-온라인 동기화 충돌
- **확률**: Medium
- **영향도**: Medium
- **완화 방안**:
  - Phase 7은 MVP 이후 진행
  - 초기에는 온라인 Only로 시작
  - 충돌 시 서버 데이터 우선 정책

### 리스크 4: 패키지 버전 호환성
- **확률**: Low
- **영향도**: Medium
- **완화 방안**:
  - pubspec.lock 버전 관리
  - CI/CD에서 빌드 검증

---

## 5. 전체 검증 계획

### 자동 테스트
- [ ] Repository 단위 테스트 (Mock DataSource)
- [ ] UseCase 단위 테스트
- [ ] Provider 단위 테스트
- [ ] 위젯 테스트 (주요 화면)
- [ ] 통합 테스트 (인증 플로우)

### 수동 테스트 시나리오

#### 시나리오 1: 신규 사용자 플로우
1. 앱 설치 → Splash 화면 표시
2. 회원가입 화면 이동
3. 이메일/비밀번호 입력 → 가입 완료
4. 홈 화면 진입
5. 배변 기록 생성
6. 캘린더에서 기록 확인
7. 로그아웃
8. 재로그인 → 데이터 유지 확인

#### 시나리오 2: 다중 디바이스
1. 기기 A에서 로그인
2. 기록 생성
3. 기기 B에서 동일 계정 로그인
4. 동일 데이터 확인

#### 시나리오 3: 에러 핸들링
1. 잘못된 이메일 형식 입력 → 에러 메시지
2. 네트워크 끊김 → 오프라인 안내
3. 존재하지 않는 계정 로그인 → 적절한 에러

### 성능 체크
- [ ] 앱 시작 시간 3초 이내
- [ ] 기록 목록 로딩 1초 이내
- [ ] 메모리 누수 없음 (Flutter DevTools)

---

## 6. 참고 사항

### Supabase SQL 스크립트
연구 문서의 SQL 스크립트를 Supabase SQL Editor에서 실행:
`thoughts/shared/research/poozizic_supabase_integration_2026-01-10.md` 참조

### 환경 변수 관리
- 개발: `.env.development`
- 스테이징: `.env.staging`
- 프로덕션: `.env.production`

### 주의할 점
1. **RLS 정책 필수**: 반드시 Row Level Security 활성화
2. **anon key 보호**: 환경 변수로 관리, 소스코드에 하드코딩 금지
3. **에러 로깅**: Supabase 에러는 사용자에게 친절한 메시지로 변환
4. **테스트 계정**: 개발 시 테스트 전용 계정 사용

---

## 7. Phase별 우선순위

| Phase | 우선순위 | MVP 필수 여부 |
|-------|----------|--------------|
| Phase 1 | 최우선 | 필수 |
| Phase 2 | 최우선 | 필수 |
| Phase 3 | 높음 | 필수 |
| Phase 4 | 높음 | 필수 |
| Phase 5 | 중간 | 필수 |
| Phase 6 | 중간 | 필수 |
| Phase 7 | 낮음 | 선택 |
| Phase 8 | 낮음 | 선택 (권장) |

---

## 8. 구현 시 코드 스니펫

### 8.1 Supabase Remote DataSource 패턴 예시

```dart
// lib/feature/record/data/datasource/record_remote_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/record_model.dart';

class RecordRemoteDataSource {
  final SupabaseClient _client;

  RecordRemoteDataSource(this._client);

  Future<RecordModel> createRecord(RecordModel record) async {
    final response = await _client
        .from('bowel_records')
        .insert(record.toJson())
        .select()
        .single();
    return RecordModel.fromJson(response);
  }

  Future<List<RecordModel>> getRecordsByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final response = await _client
        .from('bowel_records')
        .select()
        .gte('record_datetime', startOfDay.toIso8601String())
        .lt('record_datetime', endOfDay.toIso8601String())
        .order('record_datetime', ascending: false);

    return (response as List)
        .map((json) => RecordModel.fromJson(json))
        .toList();
  }

  Future<List<RecordModel>> getRecordsByMonth(int year, int month) async {
    final startOfMonth = DateTime(year, month, 1);
    final endOfMonth = DateTime(year, month + 1, 1);

    final response = await _client
        .from('bowel_records')
        .select()
        .gte('record_datetime', startOfMonth.toIso8601String())
        .lt('record_datetime', endOfMonth.toIso8601String())
        .order('record_datetime', ascending: false);

    return (response as List)
        .map((json) => RecordModel.fromJson(json))
        .toList();
  }

  Future<void> deleteRecord(String id) async {
    await _client.from('bowel_records').delete().eq('id', id);
  }
}
```

### 8.2 Repository 이중 DataSource 패턴

```dart
// lib/feature/record/data/repository/record_repository_impl.dart
import 'package:dartz/dartz.dart';
import '../../../../core/network/network_info.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../../domain/entity/record_entity.dart';
import '../../domain/repository/record_repository.dart';
import '../datasource/record_local_datasource.dart';
import '../datasource/record_remote_datasource.dart';
import '../model/record_model.dart';

class RecordRepositoryImpl implements RecordRepository {
  final RecordRemoteDataSource _remoteDataSource;
  final RecordLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  RecordRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  @override
  Future<Either<Failure, RecordEntity>> createRecord(RecordEntity record) async {
    if (await _networkInfo.isConnected) {
      try {
        final model = RecordModel.fromEntity(record);
        final result = await _remoteDataSource.createRecord(model);
        return Right(result);
      } catch (e) {
        return Left(Failure.unexpected(message: '기록 저장에 실패했습니다'));
      }
    } else {
      // 오프라인: 로컬에 저장 (Phase 7에서 구현)
      return Left(Failure.unexpected(message: '네트워크 연결을 확인해주세요'));
    }
  }

  @override
  Future<Either<Failure, List<RecordEntity>>> getRecordsByDate(DateTime date) async {
    if (await _networkInfo.isConnected) {
      try {
        final records = await _remoteDataSource.getRecordsByDate(date);
        return Right(records);
      } catch (e) {
        return Left(Failure.unexpected(message: '기록을 불러오는데 실패했습니다'));
      }
    } else {
      return Left(Failure.unexpected(message: '네트워크 연결을 확인해주세요'));
    }
  }
}
```

### 8.3 Auth Notifier 패턴

```dart
// lib/feature/auth/presentation/provider/auth_notifier.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/sign_in_usecase.dart';
import '../../domain/usecase/sign_out_usecase.dart';
import '../../domain/usecase/get_current_user_usecase.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;

  AuthNotifier(
    this._signInUseCase,
    this._signOutUseCase,
    this._getCurrentUserUseCase,
  ) : super(AuthState.initial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _getCurrentUserUseCase(const NoParams());

    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.unauthenticated),
      (user) {
        if (user != null) {
          state = state.copyWith(status: AuthStatus.authenticated, user: user);
        } else {
          state = state.copyWith(status: AuthStatus.unauthenticated);
        }
      },
    );
  }

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    final result = await _signInUseCase(SignInParams(email: email, password: password));

    result.fold(
      (failure) => state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: failure.message,
      ),
      (user) => state = state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      ),
    );
  }

  Future<void> signOut() async {
    await _signOutUseCase(const NoParams());
    state = AuthState.initial().copyWith(status: AuthStatus.unauthenticated);
  }
}
```

### 8.4 Provider 설정 예시

```dart
// lib/feature/auth/di/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/supabase/supabase_config.dart';
import '../data/datasource/auth_remote_datasource.dart';
import '../data/repository/auth_repository_impl.dart';
import '../domain/repository/auth_repository.dart';
import '../domain/usecase/sign_in_usecase.dart';
import '../domain/usecase/sign_out_usecase.dart';
import '../domain/usecase/get_current_user_usecase.dart';
import '../presentation/provider/auth_notifier.dart';
import '../presentation/provider/auth_state.dart';

/// Remote DataSource Provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(SupabaseConfig.client);
});

/// Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

/// UseCase Providers
final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

/// Auth Notifier Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(signInUseCaseProvider),
    ref.watch(signOutUseCaseProvider),
    ref.watch(getCurrentUserUseCaseProvider),
  );
});
```

---

## 9. Supabase 대시보드 설정 체크리스트

### 9.1 프로젝트 생성 후 확인 사항
- [ ] Project URL 복사
- [ ] anon public key 복사
- [ ] service_role key는 서버에서만 사용 (클라이언트 앱에서 사용 금지)

### 9.2 Authentication 설정
- [ ] Email/Password 활성화: Authentication > Providers > Email
- [ ] Email confirmation 비활성화 (개발 단계): Authentication > Providers > Email > Confirm email 해제
- [ ] (선택) Google OAuth 설정
- [ ] (선택) Apple OAuth 설정

### 9.3 Database 설정
- [ ] SQL Editor에서 연구 문서의 스크립트 실행
- [ ] Table Editor에서 테이블 생성 확인
- [ ] RLS 정책이 활성화되어 있는지 확인

### 9.4 RLS 정책 테스트
```sql
-- 테스트 쿼리 (SQL Editor에서 실행)
-- 1. 인증 없이 접근 시도 (실패해야 함)
SELECT * FROM bowel_records;

-- 2. 인증된 사용자로 테스트
-- (Supabase 대시보드의 API Docs에서 테스트 가능)
```

---

## 10. 문제 해결 가이드

### 문제 1: "permission denied for table" 에러
**원인**: RLS 정책이 잘못 설정되었거나 누락됨
**해결**:
1. Table Editor에서 RLS 활성화 확인
2. Policies 탭에서 정책 존재 여부 확인
3. 정책 누락 시 SQL 스크립트 재실행

### 문제 2: "JWT expired" 에러
**원인**: 토큰 만료
**해결**:
1. Supabase Flutter SDK가 자동 갱신 처리
2. 앱에서 세션 상태 확인 후 재로그인 유도

### 문제 3: 네트워크 타임아웃
**원인**: 네트워크 불안정 또는 Supabase 서버 문제
**해결**:
1. connectivity_plus로 네트워크 상태 확인
2. 적절한 타임아웃 설정 (10초 권장)
3. 재시도 로직 구현

### 문제 4: 데이터 동기화 불일치
**원인**: 로컬과 서버 데이터 불일치
**해결**:
1. 서버 데이터를 Source of Truth로 사용
2. 앱 시작 시 서버에서 최신 데이터 가져오기
3. 충돌 시 서버 우선 정책

---

## 11. 다음 단계 권장 사항

### MVP 완료 후
1. **Push Notifications**: Firebase Cloud Messaging + Supabase Webhooks
2. **이미지 업로드**: Supabase Storage 활용
3. **고급 분석**: Supabase Edge Functions로 서버 사이드 계산
4. **소셜 기능**: 친구와 기록 공유 (추후 확장)

### 성능 최적화
1. **페이지네이션**: 대량 데이터 시 분할 로딩
2. **캐싱 전략**: 로컬 캐시 + TTL 설정
3. **인덱스 최적화**: 쿼리 패턴 분석 후 인덱스 추가

---

*이 계획은 Poozizic 앱의 Supabase 백엔드 통합을 위한 상세 구현 가이드입니다.*
*마지막 업데이트: 2026-01-10*
