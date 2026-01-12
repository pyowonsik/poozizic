# Poozizic Supabase 백엔드 통합 연구

**날짜**: 2026-01-10
**분석 대상**: Supabase 백엔드 통합을 위한 ERD 설계 및 작업 목록

---

## 1. 프로젝트 개요

### 1.1 앱 설명
- **앱 이름**: 뿌지직 (Poozizic) - 배변 건강 관리 앱
- **주요 기능**:
  - 배변 기록 (Bristol Scale 기반)
  - 식사 기록
  - 수분 섭취 기록
  - 운동 기록
  - 캘린더 통계
  - 건강 점수 분석
  - 사용자 설정 관리

### 1.2 현재 기술 스택
- **프레임워크**: Flutter (Dart SDK ^3.10.3)
- **상태 관리**: Riverpod (flutter_riverpod: ^2.6.1)
- **아키텍처**: Clean Architecture
- **데이터 레이어**: 현재 로컬 메모리 Mock 데이터 사용

### 1.3 현재 데이터 저장 방식
- `RecordLocalDataSource`: 메모리 기반 Mock 데이터
- `SettingsLocalDataSource`: 메모리 기반 설정 저장
- 실제 영속성 저장소 없음

---

## 2. 데이터 모델 분석

### 2.1 RecordEntity (배변 기록)
```dart
class RecordEntity {
  final int? id;
  final DateTime dateTime;
  final int bristolType;      // 1-7 (Bristol Scale)
  final int feeling;          // 0: 시원함, 1: 보통, 2: 불편함, 3: 잔변감
  final int durationMinutes;
  final String? memo;
  final DateTime createdAt;
}
```

### 2.2 SettingsEntity (사용자 설정)
```dart
class SettingsEntity {
  // 목표 설정
  final int waterGoal;        // 기본값: 2000ml
  final int bowelGoal;        // 기본값: 1회/일

  // 알림 설정
  final bool bowelReminder;
  final bool waterReminder;
  final bool weeklyReport;

  // 프라이버시 설정
  final bool appLock;
  final bool hideNotificationContent;
  final bool cloudBackup;
}
```

### 2.3 식사 기록 (MealRecordScreen에서 추출)
```dart
// 현재 Entity가 없음 - 새로 생성 필요
class MealRecordEntity {
  final int? id;
  final DateTime dateTime;
  final int mealType;         // 0: 아침, 1: 점심, 2: 저녁, 3: 간식
  final List<String> foods;   // 음식 목록
  final int fiberLevel;       // 0: 많음, 1: 보통, 2: 적음
  final DateTime createdAt;
}
```

### 2.4 수분 기록 (WaterRecordScreen에서 추출)
```dart
// 현재 Entity가 없음 - 새로 생성 필요
class WaterRecordEntity {
  final int? id;
  final DateTime dateTime;
  final int amountMl;         // 섭취량 (ml)
  final DateTime createdAt;
}
```

### 2.5 운동 기록 (ExerciseRecordScreen에서 추출)
```dart
// 현재 Entity가 없음 - 새로 생성 필요
class ExerciseRecordEntity {
  final int? id;
  final DateTime dateTime;
  final int exerciseType;     // 0: 달리기, 1: 걷기, 2: 자전거, 3: 수영, 4: 요가, 5: 웨이트
  final int durationMinutes;
  final int intensity;        // 0: 가볍게, 1: 보통, 2: 격하게
  final DateTime createdAt;
}
```

---

## 3. Supabase ERD 설계

### 3.1 테이블 구조

```sql
-- =============================================
-- 1. users 테이블 (Supabase Auth와 연동)
-- =============================================
CREATE TABLE public.users (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT UNIQUE NOT NULL,
  display_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 2. user_settings 테이블 (사용자 설정)
-- =============================================
CREATE TABLE public.user_settings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  -- 목표 설정
  water_goal_ml INT DEFAULT 2000,
  bowel_goal_per_day INT DEFAULT 1,

  -- 알림 설정
  bowel_reminder BOOLEAN DEFAULT TRUE,
  water_reminder BOOLEAN DEFAULT TRUE,
  weekly_report BOOLEAN DEFAULT TRUE,

  -- 프라이버시 설정
  app_lock BOOLEAN DEFAULT FALSE,
  hide_notification_content BOOLEAN DEFAULT FALSE,
  cloud_backup BOOLEAN DEFAULT FALSE,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),

  UNIQUE(user_id)
);

-- =============================================
-- 3. bowel_records 테이블 (배변 기록)
-- =============================================
CREATE TABLE public.bowel_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  record_datetime TIMESTAMPTZ NOT NULL,
  bristol_type INT NOT NULL CHECK (bristol_type BETWEEN 1 AND 7),
  feeling INT NOT NULL CHECK (feeling BETWEEN 0 AND 3),
  -- 0: 시원함, 1: 보통, 2: 불편함, 3: 잔변감
  duration_minutes INT NOT NULL DEFAULT 0,
  memo TEXT,

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 4. meal_records 테이블 (식사 기록)
-- =============================================
CREATE TABLE public.meal_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  record_datetime TIMESTAMPTZ NOT NULL,
  meal_type INT NOT NULL CHECK (meal_type BETWEEN 0 AND 3),
  -- 0: 아침, 1: 점심, 2: 저녁, 3: 간식
  foods TEXT[] NOT NULL DEFAULT '{}',
  fiber_level INT NOT NULL CHECK (fiber_level BETWEEN 0 AND 2),
  -- 0: 많음, 1: 보통, 2: 적음

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 5. water_records 테이블 (수분 기록)
-- =============================================
CREATE TABLE public.water_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  record_datetime TIMESTAMPTZ NOT NULL,
  amount_ml INT NOT NULL CHECK (amount_ml > 0),

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 6. exercise_records 테이블 (운동 기록)
-- =============================================
CREATE TABLE public.exercise_records (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,

  record_datetime TIMESTAMPTZ NOT NULL,
  exercise_type INT NOT NULL CHECK (exercise_type BETWEEN 0 AND 5),
  -- 0: 달리기, 1: 걷기, 2: 자전거, 3: 수영, 4: 요가, 5: 웨이트
  duration_minutes INT NOT NULL CHECK (duration_minutes > 0),
  intensity INT NOT NULL CHECK (intensity BETWEEN 0 AND 2),
  -- 0: 가볍게, 1: 보통, 2: 격하게

  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- =============================================
-- 인덱스 생성
-- =============================================
CREATE INDEX idx_bowel_records_user_date ON public.bowel_records(user_id, record_datetime);
CREATE INDEX idx_meal_records_user_date ON public.meal_records(user_id, record_datetime);
CREATE INDEX idx_water_records_user_date ON public.water_records(user_id, record_datetime);
CREATE INDEX idx_exercise_records_user_date ON public.exercise_records(user_id, record_datetime);

-- =============================================
-- Row Level Security (RLS) 정책
-- =============================================
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.bowel_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meal_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.water_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercise_records ENABLE ROW LEVEL SECURITY;

-- users 테이블 정책
CREATE POLICY "Users can view own profile" ON public.users
  FOR SELECT USING (auth.uid() = id);
CREATE POLICY "Users can update own profile" ON public.users
  FOR UPDATE USING (auth.uid() = id);

-- user_settings 테이블 정책
CREATE POLICY "Users can view own settings" ON public.user_settings
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own settings" ON public.user_settings
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own settings" ON public.user_settings
  FOR UPDATE USING (auth.uid() = user_id);

-- bowel_records 테이블 정책
CREATE POLICY "Users can view own bowel records" ON public.bowel_records
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own bowel records" ON public.bowel_records
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own bowel records" ON public.bowel_records
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own bowel records" ON public.bowel_records
  FOR DELETE USING (auth.uid() = user_id);

-- meal_records 테이블 정책
CREATE POLICY "Users can view own meal records" ON public.meal_records
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own meal records" ON public.meal_records
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own meal records" ON public.meal_records
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own meal records" ON public.meal_records
  FOR DELETE USING (auth.uid() = user_id);

-- water_records 테이블 정책
CREATE POLICY "Users can view own water records" ON public.water_records
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own water records" ON public.water_records
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own water records" ON public.water_records
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own water records" ON public.water_records
  FOR DELETE USING (auth.uid() = user_id);

-- exercise_records 테이블 정책
CREATE POLICY "Users can view own exercise records" ON public.exercise_records
  FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "Users can insert own exercise records" ON public.exercise_records
  FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "Users can update own exercise records" ON public.exercise_records
  FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "Users can delete own exercise records" ON public.exercise_records
  FOR DELETE USING (auth.uid() = user_id);

-- =============================================
-- 트리거 함수 (updated_at 자동 업데이트)
-- =============================================
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON public.users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_user_settings_updated_at
  BEFORE UPDATE ON public.user_settings
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bowel_records_updated_at
  BEFORE UPDATE ON public.bowel_records
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_meal_records_updated_at
  BEFORE UPDATE ON public.meal_records
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_water_records_updated_at
  BEFORE UPDATE ON public.water_records
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_exercise_records_updated_at
  BEFORE UPDATE ON public.exercise_records
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- =============================================
-- 신규 사용자 등록 시 자동 설정 생성 함수
-- =============================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.users (id, email)
  VALUES (NEW.id, NEW.email);

  INSERT INTO public.user_settings (user_id)
  VALUES (NEW.id);

  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

### 3.2 ERD 다이어그램 (텍스트 기반)

```
┌─────────────────────┐
│     auth.users      │
│  (Supabase Auth)    │
├─────────────────────┤
│ id (UUID) PK        │
│ email               │
│ ...                 │
└─────────┬───────────┘
          │
          │ 1:1
          ▼
┌─────────────────────┐
│       users         │
├─────────────────────┤
│ id (UUID) PK/FK     │◄─────────────────────────────────┐
│ email               │                                   │
│ display_name        │                                   │
│ created_at          │                                   │
│ updated_at          │                                   │
└─────────┬───────────┘                                   │
          │                                               │
          │ 1:1                                           │
          ▼                                               │
┌─────────────────────┐                                   │
│   user_settings     │                                   │
├─────────────────────┤                                   │
│ id (UUID) PK        │                                   │
│ user_id (UUID) FK   │───────────────────────────────────┤
│ water_goal_ml       │                                   │
│ bowel_goal_per_day  │                                   │
│ bowel_reminder      │                                   │
│ water_reminder      │                                   │
│ weekly_report       │                                   │
│ app_lock            │                                   │
│ hide_notification   │                                   │
│ cloud_backup        │                                   │
└─────────────────────┘                                   │
                                                          │
┌─────────────────────┐  ┌─────────────────────┐         │
│   bowel_records     │  │   meal_records      │         │
├─────────────────────┤  ├─────────────────────┤         │
│ id (UUID) PK        │  │ id (UUID) PK        │         │
│ user_id (UUID) FK   │──│ user_id (UUID) FK   │─────────┤
│ record_datetime     │  │ record_datetime     │         │
│ bristol_type (1-7)  │  │ meal_type (0-3)     │         │
│ feeling (0-3)       │  │ foods (TEXT[])      │         │
│ duration_minutes    │  │ fiber_level (0-2)   │         │
│ memo                │  └─────────────────────┘         │
└─────────────────────┘                                   │
                                                          │
┌─────────────────────┐  ┌─────────────────────┐         │
│   water_records     │  │  exercise_records   │         │
├─────────────────────┤  ├─────────────────────┤         │
│ id (UUID) PK        │  │ id (UUID) PK        │         │
│ user_id (UUID) FK   │──│ user_id (UUID) FK   │─────────┘
│ record_datetime     │  │ record_datetime     │
│ amount_ml           │  │ exercise_type (0-5) │
└─────────────────────┘  │ duration_minutes    │
                         │ intensity (0-2)     │
                         └─────────────────────┘
```

---

## 4. Supabase 통합 작업 목록

### Phase 1: Supabase 프로젝트 설정

#### 1.1 Supabase 프로젝트 생성
- [ ] Supabase 대시보드에서 새 프로젝트 생성
- [ ] 프로젝트 URL 및 anon key 확보
- [ ] 환경 변수 설정 파일 생성

#### 1.2 데이터베이스 스키마 생성
- [ ] 위 SQL 스크립트 실행하여 테이블 생성
- [ ] RLS 정책 활성화 및 테스트
- [ ] 인덱스 및 트리거 생성

#### 1.3 인증 설정
- [ ] Email/Password 인증 활성화
- [ ] (선택) 소셜 로그인 설정 (Google, Apple)
- [ ] 이메일 템플릿 커스터마이징

---

### Phase 2: Flutter 패키지 설정

#### 2.1 의존성 추가 (pubspec.yaml)
```yaml
dependencies:
  supabase_flutter: ^2.3.0
  flutter_secure_storage: ^9.0.0  # 토큰 안전 저장
  connectivity_plus: ^5.0.0       # 네트워크 상태 확인
```

#### 2.2 Supabase 초기화
- [ ] `lib/core/supabase/supabase_client.dart` 생성
- [ ] main.dart에서 Supabase 초기화

```dart
// lib/core/supabase/supabase_client.dart
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String url = 'YOUR_SUPABASE_URL';
  static const String anonKey = 'YOUR_SUPABASE_ANON_KEY';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
```

---

### Phase 3: 인증 기능 구현

#### 3.1 인증 Feature 구조 생성
```
lib/feature/auth/
├── data/
│   ├── datasource/
│   │   └── auth_remote_datasource.dart
│   └── repository/
│       └── auth_repository_impl.dart
├── domain/
│   ├── entity/
│   │   └── user_entity.dart
│   ├── repository/
│   │   └── auth_repository.dart
│   └── usecase/
│       ├── sign_in_usecase.dart
│       ├── sign_up_usecase.dart
│       ├── sign_out_usecase.dart
│       └── get_current_user_usecase.dart
├── presentation/
│   ├── page/
│   │   ├── login_page.dart
│   │   └── register_page.dart
│   ├── provider/
│   │   ├── auth_notifier.dart
│   │   └── auth_state.dart
│   └── widget/
└── di/
    └── auth_providers.dart
```

#### 3.2 구현 작업
- [ ] UserEntity 생성
- [ ] AuthRepository 인터페이스 정의
- [ ] AuthRemoteDataSource 구현
- [ ] AuthRepositoryImpl 구현
- [ ] 인증 UseCase 구현
- [ ] AuthNotifier 및 State 구현
- [ ] 로그인/회원가입 UI 구현

---

### Phase 4: Remote DataSource 구현

#### 4.1 배변 기록 (Bowel Records)
```
lib/feature/record/data/datasource/
├── record_local_datasource.dart  # 기존 (유지)
└── record_remote_datasource.dart # 신규
```

- [ ] `RecordRemoteDataSource` 클래스 생성
- [ ] Supabase CRUD 연산 구현
- [ ] Repository에서 Remote DataSource 연동

#### 4.2 식사 기록 Feature 생성
```
lib/feature/meal/
├── data/
│   ├── datasource/
│   │   └── meal_remote_datasource.dart
│   └── repository/
│       └── meal_repository_impl.dart
├── domain/
│   ├── entity/
│   │   └── meal_entity.dart
│   ├── repository/
│   │   └── meal_repository.dart
│   └── usecase/
│       ├── create_meal_record_usecase.dart
│       └── get_meal_records_usecase.dart
├── presentation/
│   ├── page/
│   │   └── meal_record_page.dart  # screens에서 이동
│   └── provider/
└── di/
    └── meal_providers.dart
```

#### 4.3 수분 기록 Feature 생성
```
lib/feature/water/
├── data/
│   ├── datasource/
│   │   └── water_remote_datasource.dart
│   └── repository/
│       └── water_repository_impl.dart
├── domain/
│   ├── entity/
│   │   └── water_entity.dart
│   ├── repository/
│   │   └── water_repository.dart
│   └── usecase/
│       ├── create_water_record_usecase.dart
│       └── get_water_records_usecase.dart
├── presentation/
│   ├── page/
│   │   └── water_record_page.dart  # screens에서 이동
│   └── provider/
└── di/
    └── water_providers.dart
```

#### 4.4 운동 기록 Feature 생성
```
lib/feature/exercise/
├── data/
│   ├── datasource/
│   │   └── exercise_remote_datasource.dart
│   └── repository/
│       └── exercise_repository_impl.dart
├── domain/
│   ├── entity/
│   │   └── exercise_entity.dart
│   ├── repository/
│   │   └── exercise_repository.dart
│   └── usecase/
│       ├── create_exercise_record_usecase.dart
│       └── get_exercise_records_usecase.dart
├── presentation/
│   ├── page/
│   │   └── exercise_record_page.dart  # screens에서 이동
│   └── provider/
└── di/
    └── exercise_providers.dart
```

---

### Phase 5: 설정 기능 Supabase 연동

#### 5.1 SettingsRemoteDataSource 구현
- [ ] `settings_remote_datasource.dart` 생성
- [ ] 설정 동기화 로직 구현
- [ ] 로컬-리모트 병합 전략 구현

---

### Phase 6: 오프라인 지원 및 동기화

#### 6.1 로컬 캐시 구현
- [ ] `hive` 또는 `sqflite` 패키지 추가
- [ ] 로컬 캐시 레이어 구현
- [ ] 오프라인 CRUD 지원

#### 6.2 동기화 로직
- [ ] 네트워크 상태 모니터링
- [ ] 백그라운드 동기화 구현
- [ ] 충돌 해결 전략 구현

---

### Phase 7: 기타 작업

#### 7.1 환경 설정
- [ ] 개발/스테이징/프로덕션 환경 분리
- [ ] 환경 변수 관리 (flutter_dotenv)

#### 7.2 에러 핸들링
- [ ] Supabase 에러 타입 정의
- [ ] 네트워크 에러 처리
- [ ] 사용자 친화적 에러 메시지

#### 7.3 테스트
- [ ] Unit 테스트 작성
- [ ] Integration 테스트 작성
- [ ] Mock Supabase 클라이언트 설정

---

## 5. 권장 패키지 목록

```yaml
# pubspec.yaml 추가 의존성
dependencies:
  # Supabase
  supabase_flutter: ^2.3.0

  # 로컬 저장소
  hive: ^2.2.3
  hive_flutter: ^1.1.0

  # 네트워크 상태
  connectivity_plus: ^5.0.0

  # 보안 저장소
  flutter_secure_storage: ^9.0.0

  # 환경 변수
  flutter_dotenv: ^5.1.0

  # 날짜 처리
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  # 코드 생성
  freezed: ^2.4.5
  json_serializable: ^6.7.1
  hive_generator: ^2.0.1
  build_runner: ^2.4.7

  # 테스트
  mocktail: ^1.0.1
```

---

## 6. 마이그레이션 체크리스트

### 단계별 마이그레이션

1. **Phase 1 완료 체크**
   - [ ] Supabase 프로젝트 생성 완료
   - [ ] 모든 테이블 생성 완료
   - [ ] RLS 정책 테스트 완료

2. **Phase 2 완료 체크**
   - [ ] 패키지 설치 완료
   - [ ] Supabase 초기화 테스트 완료

3. **Phase 3 완료 체크**
   - [ ] 회원가입 동작 확인
   - [ ] 로그인 동작 확인
   - [ ] 로그아웃 동작 확인

4. **Phase 4 완료 체크**
   - [ ] 배변 기록 CRUD 테스트
   - [ ] 식사 기록 CRUD 테스트
   - [ ] 수분 기록 CRUD 테스트
   - [ ] 운동 기록 CRUD 테스트

5. **Phase 5 완료 체크**
   - [ ] 설정 저장/불러오기 테스트

6. **Phase 6 완료 체크**
   - [ ] 오프라인 모드 테스트
   - [ ] 동기화 테스트

---

## 7. 주의사항

### 7.1 보안 고려사항
- anon key는 환경 변수로 관리
- RLS 정책 반드시 활성화
- 민감한 데이터 암호화 고려

### 7.2 성능 고려사항
- 인덱스 적절히 활용
- 페이지네이션 구현
- 불필요한 데이터 로딩 방지

### 7.3 사용자 경험
- 로딩 상태 표시
- 에러 상황 친절하게 안내
- 오프라인 상태 명확히 표시

---

## 8. 예상 작업 범위

| Phase | 작업 항목 수 | 복잡도 |
|-------|-------------|--------|
| Phase 1 | 8 | 낮음 |
| Phase 2 | 4 | 낮음 |
| Phase 3 | 12 | 중간 |
| Phase 4 | 20 | 높음 |
| Phase 5 | 4 | 중간 |
| Phase 6 | 6 | 높음 |
| Phase 7 | 8 | 중간 |

---

*이 문서는 Poozizic 앱의 Supabase 백엔드 통합을 위한 상세 가이드입니다.*
