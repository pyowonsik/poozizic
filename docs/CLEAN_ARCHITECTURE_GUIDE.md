# Flutter 클린 아키텍처 & Riverpod 가이드

> 리액트 개발자를 위한 Flutter 클린 아키텍처 입문 가이드

---

## 목차

1. [리액트 vs Flutter 비교](#1-리액트-vs-flutter-비교)
2. [클린 아키텍처란?](#2-클린-아키텍처란)
3. [폴더 구조](#3-폴더-구조)
4. [Domain Layer](#4-domain-layer-비즈니스-로직)
5. [Data Layer](#5-data-layer-데이터-처리)
6. [Presentation Layer](#6-presentation-layer-ui--상태관리)
7. [Riverpod 핵심 개념](#7-riverpod-핵심-개념)
8. [Either 패턴 (에러 처리)](#8-either-패턴-에러-처리)
9. [실전 예제: Record Feature](#9-실전-예제-record-feature-전체-구현)
10. [자주 묻는 질문](#10-자주-묻는-질문-faq)

---

## 1. 리액트 vs Flutter 비교

리액트에서 익숙한 개념들이 Flutter에서는 어떻게 매핑되는지 먼저 살펴보겠습니다.

### 기본 개념 비교표

| React | Flutter | 설명 |
|-------|---------|------|
| `Component` | `Widget` | UI 구성 단위 |
| `useState` | `StatefulWidget` / `StateNotifier` | 로컬 상태 관리 |
| `useEffect` | `initState()` / `didChangeDependencies()` | 생명주기 훅 |
| `Context API` | `Riverpod Provider` | 전역 상태 공유 |
| `Redux` | `Riverpod StateNotifierProvider` | 복잡한 상태 관리 |
| `fetch` / `axios` | `Repository` + `DataSource` | API 호출 |
| `Custom Hook` | `UseCase` | 재사용 가능한 로직 |
| `props` | `constructor parameter` | 부모 → 자식 데이터 전달 |

### 상태 관리 비교

**React (Redux)**
```javascript
// store.js
const userSlice = createSlice({
  name: 'user',
  initialState: { user: null, loading: false },
  reducers: {
    setUser: (state, action) => { state.user = action.payload },
    setLoading: (state, action) => { state.loading = action.payload },
  },
});

// Component.jsx
const user = useSelector(state => state.user);
const dispatch = useDispatch();
dispatch(setUser(userData));
```

**Flutter (Riverpod)**
```dart
// user_state.dart
sealed class UserState {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}

// user_notifier.dart
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserInitial());

  void setUser(User user) {
    state = UserLoaded(user);
  }
}

// Widget에서 사용
final userState = ref.watch(userNotifierProvider);
ref.read(userNotifierProvider.notifier).setUser(userData);
```

---

## 2. 클린 아키텍처란?

클린 아키텍처는 코드를 **3개의 계층**으로 분리하여 관리하는 설계 패턴입니다.

### 왜 사용하나요?

1. **테스트 용이성**: 각 계층을 독립적으로 테스트 가능
2. **유지보수**: 한 부분 수정이 다른 부분에 영향 최소화
3. **확장성**: 새 기능 추가가 기존 코드에 영향 없음
4. **협업**: 여러 개발자가 다른 계층을 동시에 작업 가능

### 3계층 구조 다이어그램

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                        │
│    (UI, State Management - Widget, Notifier, Provider)       │
│                                                              │
│   ┌──────────────────────────────────────────────────────┐  │
│   │                    Domain Layer                       │  │
│   │     (Business Logic - UseCase, Entity, Repository    │  │
│   │                      Interface)                       │  │
│   │                                                       │  │
│   │   ┌──────────────────────────────────────────────┐   │  │
│   │   │              Data Layer                       │   │  │
│   │   │  (API, Database - DataSource, Repository     │   │  │
│   │   │              Implementation)                  │   │  │
│   │   └──────────────────────────────────────────────┘   │  │
│   └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘

의존성 방향: 바깥쪽 → 안쪽 (Presentation → Domain ← Data)
```

### 각 계층의 역할

| 계층 | 역할 | 포함 요소 | React 비유 |
|------|------|----------|-----------|
| **Presentation** | UI 표시, 사용자 입력 처리 | Widget, Page, Notifier, State | Component, Hook |
| **Domain** | 비즈니스 로직 | UseCase, Entity, Repository Interface | Custom Hook, TypeScript Interface |
| **Data** | 외부 데이터 처리 | DataSource, Repository Implementation | API 함수, fetch 로직 |

### 핵심 규칙

```
1. Presentation은 Domain만 알 수 있음 (Data 직접 참조 X)
2. Domain은 아무것도 모름 (순수 비즈니스 로직만)
3. Data는 Domain의 인터페이스를 구현

이 규칙 덕분에 나중에 API를 바꾸거나 DB를 변경해도
Domain과 Presentation은 수정할 필요 없음!
```

---

## 3. 폴더 구조

### 권장 폴더 구조

```
lib/
├── main.dart                      # 앱 진입점
│
├── core/                          # 전역 설정
│   ├── di/                        # Dependency Injection (의존성 주입)
│   │   └── providers.dart         # 전역 Provider 정의
│   ├── route/                     # 라우팅 설정
│   ├── theme/                     # 테마 설정
│   └── util/                      # 유틸리티 함수
│
├── feature/                       # 기능별 모듈 (Feature-based)
│   │
│   ├── record/                    # 배변 기록 기능
│   │   ├── data/
│   │   │   ├── datasource/
│   │   │   │   └── record_remote_datasource.dart
│   │   │   ├── repository/
│   │   │   │   └── record_repository_impl.dart
│   │   │   └── data.dart          # 배럴 파일 (re-export)
│   │   │
│   │   ├── domain/
│   │   │   ├── entity/
│   │   │   │   └── record_entity.dart
│   │   │   ├── repository/
│   │   │   │   └── record_repository.dart  # 추상 인터페이스
│   │   │   ├── usecase/
│   │   │   │   ├── create_record_usecase.dart
│   │   │   │   └── get_records_usecase.dart
│   │   │   ├── failure/
│   │   │   │   └── record_failure.dart
│   │   │   └── domain.dart
│   │   │
│   │   ├── presentation/
│   │   │   ├── page/
│   │   │   │   └── record_page.dart
│   │   │   ├── provider/
│   │   │   │   ├── record_notifier.dart
│   │   │   │   ├── record_state.dart
│   │   │   │   └── record_providers.dart
│   │   │   ├── widget/
│   │   │   │   └── bristol_scale_selector.dart
│   │   │   └── presentation.dart
│   │   │
│   │   └── di/
│   │       └── record_providers.dart  # Record 관련 Provider 정의
│   │
│   ├── calendar/                  # 캘린더 기능
│   │   └── ... (동일 구조)
│   │
│   └── analytics/                 # 분석 기능
│       └── ... (동일 구조)
│
└── shared/                        # 여러 Feature에서 공유하는 코드
    ├── widget/                    # 공용 위젯
    ├── domain/
    │   ├── usecase/
    │   │   └── usecase.dart       # UseCase 추상 클래스
    │   └── failure/
    │       └── failure.dart       # Failure 기본 클래스
    └── util/
```

### 배럴 파일이란? (barrel file)

여러 파일을 하나로 묶어서 import를 간단하게 만드는 파일입니다.

```dart
// feature/record/domain/domain.dart (배럴 파일)
export 'entity/record_entity.dart';
export 'repository/record_repository.dart';
export 'usecase/create_record_usecase.dart';
export 'usecase/get_records_usecase.dart';
export 'failure/record_failure.dart';

// 사용할 때
import 'package:poozizic/feature/record/domain/domain.dart';
// 이 한 줄로 domain 폴더의 모든 파일 import 가능!
```

---

## 4. Domain Layer (비즈니스 로직)

Domain Layer는 앱의 **핵심 비즈니스 로직**을 담당합니다.
외부 의존성이 없는 **순수한 Dart 코드**로만 구성됩니다.

### 4.1 Entity (엔티티)

비즈니스 객체를 정의합니다. React의 TypeScript 타입/인터페이스와 비슷합니다.

```dart
// feature/record/domain/entity/record_entity.dart

/// 배변 기록 엔티티
/// Domain Layer: 순수 Dart 클래스, 비즈니스 로직 포함 가능
class RecordEntity {
  final int? id;
  final DateTime dateTime;
  final int bristolType;      // Bristol Scale 1-7
  final int feeling;          // 기분 1-5
  final String? memo;
  final DateTime createdAt;

  const RecordEntity({
    this.id,
    required this.dateTime,
    required this.bristolType,
    required this.feeling,
    this.memo,
    required this.createdAt,
  });

  /// 비즈니스 로직: 건강한 변인지 확인
  /// Bristol Scale 3-4가 정상
  bool get isHealthy => bristolType >= 3 && bristolType <= 4;

  /// 비즈니스 로직: 오늘 기록인지 확인
  bool get isToday {
    final now = DateTime.now();
    return dateTime.year == now.year &&
           dateTime.month == now.month &&
           dateTime.day == now.day;
  }

  /// 불변성을 위한 copyWith 메서드
  RecordEntity copyWith({
    int? id,
    DateTime? dateTime,
    int? bristolType,
    int? feeling,
    String? memo,
    DateTime? createdAt,
  }) {
    return RecordEntity(
      id: id ?? this.id,
      dateTime: dateTime ?? this.dateTime,
      bristolType: bristolType ?? this.bristolType,
      feeling: feeling ?? this.feeling,
      memo: memo ?? this.memo,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
```

### 4.2 Repository Interface (추상 인터페이스)

Repository는 데이터 접근 방법을 정의하는 **계약(Contract)**입니다.
React의 TypeScript 인터페이스와 비슷합니다.

```dart
// feature/record/domain/repository/record_repository.dart

import '../entity/record_entity.dart';

/// Repository 추상 인터페이스
/// Domain Layer는 이 인터페이스만 알고, 실제 구현은 Data Layer에서 함
abstract class RecordRepository {
  /// 배변 기록 생성
  Future<RecordEntity> createRecord(RecordEntity record);

  /// 모든 기록 조회
  Future<List<RecordEntity>> getAllRecords();

  /// 특정 날짜 기록 조회
  Future<List<RecordEntity>> getRecordsByDate(DateTime date);

  /// 기록 삭제
  Future<void> deleteRecord(int id);

  /// 기록 수정
  Future<RecordEntity> updateRecord(RecordEntity record);
}
```

**왜 인터페이스를 따로 만드나요?**

```
실제 구현을 나중에 바꿀 수 있습니다!

예를 들어:
- 처음에는 로컬 SQLite DB 사용 → RecordRepositoryLocalImpl
- 나중에 서버 API 추가 → RecordRepositoryRemoteImpl
- Domain Layer 코드는 전혀 수정 없이 구현체만 교체하면 됨!
```

### 4.3 UseCase (유스케이스)

하나의 비즈니스 작업을 캡슐화합니다.
React의 Custom Hook과 비슷한 역할입니다.

```dart
// shared/domain/usecase/usecase.dart

import 'package:dartz/dartz.dart';
import '../failure/failure.dart';

/// UseCase 추상 클래스
/// T: 반환 타입, Params: 입력 파라미터 타입
abstract class UseCase<T, Params> {
  /// UseCase 실행
  /// 성공 시 Right(T), 실패 시 Left(Failure) 반환
  Future<Either<Failure, T>> call(Params params);
}

/// 파라미터가 없을 때 사용
class NoParams {
  const NoParams();
}
```

```dart
// feature/record/domain/usecase/create_record_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../entity/record_entity.dart';
import '../repository/record_repository.dart';
import '../failure/record_failure.dart';

/// 배변 기록 생성 UseCase
class CreateRecordUseCase implements UseCase<RecordEntity, CreateRecordParams> {
  final RecordRepository repository;

  CreateRecordUseCase(this.repository);

  @override
  Future<Either<Failure, RecordEntity>> call(CreateRecordParams params) async {
    try {
      // 유효성 검사 (비즈니스 로직)
      if (params.bristolType < 1 || params.bristolType > 7) {
        return Left(RecordValidationFailure('Bristol Scale은 1-7 사이여야 합니다.'));
      }

      if (params.feeling < 1 || params.feeling > 5) {
        return Left(RecordValidationFailure('기분 점수는 1-5 사이여야 합니다.'));
      }

      // Entity 생성
      final record = RecordEntity(
        dateTime: params.dateTime,
        bristolType: params.bristolType,
        feeling: params.feeling,
        memo: params.memo,
        createdAt: DateTime.now(),
      );

      // Repository 호출
      final result = await repository.createRecord(record);
      return Right(result);

    } on Exception catch (e) {
      return Left(RecordCreateFailure('기록 저장에 실패했습니다.', exception: e));
    }
  }
}

/// UseCase 파라미터
class CreateRecordParams {
  final DateTime dateTime;
  final int bristolType;
  final int feeling;
  final String? memo;

  const CreateRecordParams({
    required this.dateTime,
    required this.bristolType,
    required this.feeling,
    this.memo,
  });
}
```

```dart
// feature/record/domain/usecase/get_records_usecase.dart

import 'package:dartz/dartz.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import '../../../../shared/domain/failure/failure.dart';
import '../entity/record_entity.dart';
import '../repository/record_repository.dart';
import '../failure/record_failure.dart';

/// 모든 기록 조회 UseCase
class GetRecordsUseCase implements UseCase<List<RecordEntity>, NoParams> {
  final RecordRepository repository;

  GetRecordsUseCase(this.repository);

  @override
  Future<Either<Failure, List<RecordEntity>>> call(NoParams params) async {
    try {
      final records = await repository.getAllRecords();
      return Right(records);
    } on Exception catch (e) {
      return Left(RecordLoadFailure('기록을 불러오는데 실패했습니다.', exception: e));
    }
  }
}
```

### 4.4 Failure (실패 처리)

에러를 타입으로 구분하여 처리합니다.

```dart
// shared/domain/failure/failure.dart

/// Failure 기본 클래스
abstract class Failure {
  final String message;
  final Exception? exception;

  const Failure(this.message, {this.exception});

  @override
  String toString() => message;
}

/// 네트워크 에러
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, {super.exception});
}

/// 서버 에러
class ServerFailure extends Failure {
  const ServerFailure(super.message, {super.exception});
}

/// 예상치 못한 에러
class UnexpectedFailure extends Failure {
  const UnexpectedFailure(super.message, {super.exception});
}
```

```dart
// feature/record/domain/failure/record_failure.dart

import '../../../../shared/domain/failure/failure.dart';

/// Record 관련 Failure들
abstract class RecordFailure extends Failure {
  const RecordFailure(super.message, {super.exception});
}

class RecordCreateFailure extends RecordFailure {
  const RecordCreateFailure(super.message, {super.exception});
}

class RecordLoadFailure extends RecordFailure {
  const RecordLoadFailure(super.message, {super.exception});
}

class RecordValidationFailure extends RecordFailure {
  const RecordValidationFailure(super.message, {super.exception});
}

class RecordNotFoundFailure extends RecordFailure {
  const RecordNotFoundFailure(super.message, {super.exception});
}
```

---

## 5. Data Layer (데이터 처리)

Data Layer는 **실제 데이터 처리**를 담당합니다.
API 호출, DB 접근 등 외부 의존성이 있는 코드가 여기에 위치합니다.

### 5.1 DataSource (데이터 소스)

실제 API 호출이나 DB 접근을 담당합니다.
React의 API 함수들과 비슷합니다.

```dart
// feature/record/data/datasource/record_remote_datasource.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entity/record_entity.dart';

/// Remote DataSource - API 호출 담당
class RecordRemoteDataSource {
  final http.Client client;
  final String baseUrl;

  RecordRemoteDataSource({
    required this.client,
    required this.baseUrl,
  });

  /// 기록 생성 API 호출
  Future<RecordEntity> createRecord(RecordEntity record) async {
    final response = await client.post(
      Uri.parse('$baseUrl/records'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'dateTime': record.dateTime.toIso8601String(),
        'bristolType': record.bristolType,
        'feeling': record.feeling,
        'memo': record.memo,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return _mapToEntity(data);
    } else {
      throw Exception('Failed to create record: ${response.statusCode}');
    }
  }

  /// 모든 기록 조회 API 호출
  Future<List<RecordEntity>> getAllRecords() async {
    final response = await client.get(
      Uri.parse('$baseUrl/records'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => _mapToEntity(json)).toList();
    } else {
      throw Exception('Failed to load records: ${response.statusCode}');
    }
  }

  /// 특정 날짜 기록 조회
  Future<List<RecordEntity>> getRecordsByDate(DateTime date) async {
    final dateStr = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final response = await client.get(
      Uri.parse('$baseUrl/records?date=$dateStr'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => _mapToEntity(json)).toList();
    } else {
      throw Exception('Failed to load records: ${response.statusCode}');
    }
  }

  /// 기록 삭제
  Future<void> deleteRecord(int id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/records/$id'),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Failed to delete record: ${response.statusCode}');
    }
  }

  /// 기록 수정
  Future<RecordEntity> updateRecord(RecordEntity record) async {
    final response = await client.put(
      Uri.parse('$baseUrl/records/${record.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'dateTime': record.dateTime.toIso8601String(),
        'bristolType': record.bristolType,
        'feeling': record.feeling,
        'memo': record.memo,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return _mapToEntity(data);
    } else {
      throw Exception('Failed to update record: ${response.statusCode}');
    }
  }

  /// JSON → Entity 변환
  RecordEntity _mapToEntity(Map<String, dynamic> json) {
    return RecordEntity(
      id: json['id'],
      dateTime: DateTime.parse(json['dateTime']),
      bristolType: json['bristolType'],
      feeling: json['feeling'],
      memo: json['memo'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
```

### 5.2 Repository Implementation (구현체)

Domain Layer의 Repository 인터페이스를 구현합니다.

```dart
// feature/record/data/repository/record_repository_impl.dart

import '../../domain/entity/record_entity.dart';
import '../../domain/repository/record_repository.dart';
import '../datasource/record_remote_datasource.dart';

/// Repository 구현체
/// Domain의 인터페이스를 구현하고, DataSource를 호출
class RecordRepositoryImpl implements RecordRepository {
  final RecordRemoteDataSource remoteDataSource;

  RecordRepositoryImpl(this.remoteDataSource);

  @override
  Future<RecordEntity> createRecord(RecordEntity record) {
    return remoteDataSource.createRecord(record);
  }

  @override
  Future<List<RecordEntity>> getAllRecords() {
    return remoteDataSource.getAllRecords();
  }

  @override
  Future<List<RecordEntity>> getRecordsByDate(DateTime date) {
    return remoteDataSource.getRecordsByDate(date);
  }

  @override
  Future<void> deleteRecord(int id) {
    return remoteDataSource.deleteRecord(id);
  }

  @override
  Future<RecordEntity> updateRecord(RecordEntity record) {
    return remoteDataSource.updateRecord(record);
  }
}
```

**로컬 저장소를 사용하고 싶다면?**

```dart
// feature/record/data/datasource/record_local_datasource.dart

import 'package:sqflite/sqflite.dart';
import '../../domain/entity/record_entity.dart';

/// Local DataSource - SQLite DB 담당
class RecordLocalDataSource {
  final Database database;

  RecordLocalDataSource(this.database);

  Future<RecordEntity> createRecord(RecordEntity record) async {
    final id = await database.insert('records', {
      'dateTime': record.dateTime.toIso8601String(),
      'bristolType': record.bristolType,
      'feeling': record.feeling,
      'memo': record.memo,
      'createdAt': record.createdAt.toIso8601String(),
    });
    return record.copyWith(id: id);
  }

  // ... 다른 메서드들
}
```

---

## 6. Presentation Layer (UI + 상태관리)

Presentation Layer는 **UI와 상태 관리**를 담당합니다.
사용자와 직접 상호작용하는 계층입니다.

### 6.1 State (상태 정의)

Sealed Class를 사용하여 가능한 모든 상태를 정의합니다.
React의 상태 타입 정의와 비슷하지만, 더 엄격합니다.

```dart
// feature/record/presentation/provider/record_state.dart

import '../../domain/entity/record_entity.dart';

/// Record 상태 - Sealed Class로 모든 가능한 상태 정의
/// Dart 3.0+ 의 sealed class는 모든 자식을 알고 있어서
/// switch문에서 모든 케이스 처리를 강제함
sealed class RecordState {
  const RecordState();
}

/// 초기 상태
class RecordInitial extends RecordState {
  const RecordInitial();
}

/// 로딩 중
class RecordLoading extends RecordState {
  const RecordLoading();
}

/// 기록 목록 로드 완료
class RecordLoaded extends RecordState {
  final List<RecordEntity> records;
  const RecordLoaded(this.records);
}

/// 기록 생성 성공
class RecordCreated extends RecordState {
  final RecordEntity record;
  const RecordCreated(this.record);
}

/// 에러 발생
class RecordError extends RecordState {
  final String message;
  const RecordError(this.message);
}
```

**왜 Sealed Class를 쓰나요?**

```dart
// Sealed Class 장점: 모든 상태를 처리하지 않으면 컴파일 에러!
Widget build(BuildContext context) {
  return switch (state) {
    RecordInitial() => const Text('시작'),
    RecordLoading() => const CircularProgressIndicator(),
    RecordLoaded(:final records) => ListView(...),
    RecordCreated(:final record) => Text('생성됨: ${record.id}'),
    RecordError(:final message) => Text('에러: $message'),
    // 하나라도 빠뜨리면 컴파일 에러!
  };
}
```

### 6.2 Notifier (상태 변경 로직)

StateNotifier는 상태를 변경하는 로직을 담당합니다.
React의 useReducer + dispatch와 비슷합니다.

```dart
// feature/record/presentation/provider/record_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecase/create_record_usecase.dart';
import '../../domain/usecase/get_records_usecase.dart';
import '../../../../shared/domain/usecase/usecase.dart';
import 'record_state.dart';

/// Record 상태를 관리하는 Notifier
class RecordNotifier extends StateNotifier<RecordState> {
  final CreateRecordUseCase createRecordUseCase;
  final GetRecordsUseCase getRecordsUseCase;

  RecordNotifier({
    required this.createRecordUseCase,
    required this.getRecordsUseCase,
  }) : super(const RecordInitial());

  /// 모든 기록 로드
  Future<void> loadRecords() async {
    // 로딩 상태로 변경
    state = const RecordLoading();

    // UseCase 실행
    final result = await getRecordsUseCase(const NoParams());

    // Either fold로 성공/실패 처리
    result.fold(
      (failure) {
        state = RecordError(failure.message);
      },
      (records) {
        state = RecordLoaded(records);
      },
    );
  }

  /// 기록 생성
  Future<void> createRecord({
    required DateTime dateTime,
    required int bristolType,
    required int feeling,
    String? memo,
  }) async {
    state = const RecordLoading();

    final params = CreateRecordParams(
      dateTime: dateTime,
      bristolType: bristolType,
      feeling: feeling,
      memo: memo,
    );

    final result = await createRecordUseCase(params);

    result.fold(
      (failure) {
        state = RecordError(failure.message);
      },
      (record) {
        state = RecordCreated(record);
        // 성공 후 목록 다시 로드
        loadRecords();
      },
    );
  }

  /// 상태 초기화
  void reset() {
    state = const RecordInitial();
  }
}
```

### 6.3 Provider 정의

Riverpod Provider들을 정의합니다.
이것이 의존성 주입(DI)의 핵심입니다.

```dart
// feature/record/di/record_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../data/datasource/record_remote_datasource.dart';
import '../data/repository/record_repository_impl.dart';
import '../domain/repository/record_repository.dart';
import '../domain/usecase/create_record_usecase.dart';
import '../domain/usecase/get_records_usecase.dart';
import '../presentation/provider/record_notifier.dart';
import '../presentation/provider/record_state.dart';

/// HTTP Client Provider
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

/// Remote DataSource Provider
final recordRemoteDataSourceProvider = Provider<RecordRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  return RecordRemoteDataSource(
    client: client,
    baseUrl: 'https://api.example.com', // 실제 API URL로 변경
  );
});

/// Repository Provider
final recordRepositoryProvider = Provider<RecordRepository>((ref) {
  final remoteDataSource = ref.watch(recordRemoteDataSourceProvider);
  return RecordRepositoryImpl(remoteDataSource);
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

/// Notifier Provider - 메인!
final recordNotifierProvider =
    StateNotifierProvider<RecordNotifier, RecordState>((ref) {
  final createRecordUseCase = ref.watch(createRecordUseCaseProvider);
  final getRecordsUseCase = ref.watch(getRecordsUseCaseProvider);

  return RecordNotifier(
    createRecordUseCase: createRecordUseCase,
    getRecordsUseCase: getRecordsUseCase,
  );
});
```

### 6.4 Page (UI)

실제 화면 UI를 구현합니다.

```dart
// feature/record/presentation/page/record_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../di/record_providers.dart';
import '../provider/record_state.dart';

/// 기록 화면 - ConsumerWidget 사용
/// ConsumerWidget = StatelessWidget + Riverpod
class RecordPage extends ConsumerWidget {
  const RecordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch: 상태 변경을 구독 (상태 바뀌면 rebuild)
    final state = ref.watch(recordNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('배변 기록')),
      body: _buildBody(context, ref, state),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, RecordState state) {
    // Dart 3.0+ Pattern Matching으로 상태별 UI
    return switch (state) {
      RecordInitial() => _buildInitial(ref),
      RecordLoading() => const Center(child: CircularProgressIndicator()),
      RecordLoaded(:final records) => _buildList(records),
      RecordCreated() => const Center(child: Text('기록됨!')),
      RecordError(:final message) => _buildError(message, ref),
    };
  }

  Widget _buildInitial(WidgetRef ref) {
    // 초기 상태에서 자동으로 데이터 로드
    Future.microtask(() {
      // ref.read: 한 번만 읽기 (액션 실행용)
      ref.read(recordNotifierProvider.notifier).loadRecords();
    });
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<dynamic> records) {
    if (records.isEmpty) {
      return const Center(child: Text('기록이 없습니다.'));
    }

    return ListView.builder(
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return ListTile(
          title: Text('Bristol Type: ${record.bristolType}'),
          subtitle: Text(record.dateTime.toString()),
          trailing: record.isHealthy
              ? const Icon(Icons.check_circle, color: Colors.green)
              : const Icon(Icons.warning, color: Colors.orange),
        );
      },
    );
  }

  Widget _buildError(String message, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('오류: $message'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              ref.read(recordNotifierProvider.notifier).loadRecords();
            },
            child: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    int bristolType = 4;
    int feeling = 3;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('새 기록'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bristol Type 선택
            DropdownButtonFormField<int>(
              value: bristolType,
              items: List.generate(7, (i) => i + 1)
                  .map((e) => DropdownMenuItem(value: e, child: Text('Type $e')))
                  .toList(),
              onChanged: (v) => bristolType = v ?? 4,
              decoration: const InputDecoration(labelText: 'Bristol Type'),
            ),
            // 기분 선택
            DropdownButtonFormField<int>(
              value: feeling,
              items: List.generate(5, (i) => i + 1)
                  .map((e) => DropdownMenuItem(value: e, child: Text('기분 $e')))
                  .toList(),
              onChanged: (v) => feeling = v ?? 3,
              decoration: const InputDecoration(labelText: '기분'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              // ref.read로 액션 실행
              ref.read(recordNotifierProvider.notifier).createRecord(
                dateTime: DateTime.now(),
                bristolType: bristolType,
                feeling: feeling,
              );
              Navigator.pop(context);
            },
            child: const Text('저장'),
          ),
        ],
      ),
    );
  }
}
```

---

## 7. Riverpod 핵심 개념

### 7.1 Provider 종류

```dart
// 1. Provider - 읽기 전용 값
final apiUrlProvider = Provider<String>((ref) {
  return 'https://api.example.com';
});

// 2. StateProvider - 단순 상태 (setState 대체)
final counterProvider = StateProvider<int>((ref) => 0);

// 3. StateNotifierProvider - 복잡한 상태 + 로직
final recordNotifierProvider =
    StateNotifierProvider<RecordNotifier, RecordState>((ref) {
  return RecordNotifier(...);
});

// 4. FutureProvider - 비동기 데이터
final userProvider = FutureProvider<User>((ref) async {
  return await fetchUser();
});

// 5. StreamProvider - 실시간 데이터
final messagesProvider = StreamProvider<List<Message>>((ref) {
  return messagesStream();
});
```

### 7.2 ref.watch vs ref.read

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch: 상태를 "구독"
    // 상태가 바뀌면 이 Widget이 자동으로 rebuild됨
    final state = ref.watch(recordNotifierProvider);

    return ElevatedButton(
      onPressed: () {
        // ref.read: 상태를 "한 번만 읽기"
        // 액션 실행할 때 사용 (onPressed, onTap 등)
        ref.read(recordNotifierProvider.notifier).createRecord(...);
      },
      child: Text('저장'),
    );
  }
}
```

**비유로 이해하기:**
- `ref.watch` = React의 `useSelector` (구독)
- `ref.read` = React의 `store.dispatch` (액션 실행)

### 7.3 AutoDispose 패턴

```dart
// 화면을 벗어나면 자동으로 상태 정리
final productNotifierProvider = StateNotifierProvider.autoDispose<
    ProductNotifier, ProductState>((ref) {
  // ref.onDispose: 정리 작업 등록
  ref.onDispose(() {
    print('Provider disposed!');
  });

  return ProductNotifier(...);
});
```

### 7.4 Family 패턴

파라미터를 받는 Provider를 만들 때 사용합니다.

```dart
// Family Provider 정의
final recordByIdProvider = FutureProvider.family<RecordEntity, int>(
  (ref, recordId) async {
    final repository = ref.watch(recordRepositoryProvider);
    return repository.getRecordById(recordId);
  },
);

// 사용
Widget build(BuildContext context, WidgetRef ref) {
  final recordAsync = ref.watch(recordByIdProvider(123));

  return recordAsync.when(
    data: (record) => Text(record.memo ?? ''),
    loading: () => CircularProgressIndicator(),
    error: (err, stack) => Text('Error: $err'),
  );
}
```

---

## 8. Either 패턴 (에러 처리)

### 8.1 Either란?

`Either<Left, Right>`는 두 가지 가능한 결과 중 하나를 표현합니다.
- `Left`: 실패 (보통 에러)
- `Right`: 성공 (보통 데이터)

```dart
// dartz 패키지 사용
import 'package:dartz/dartz.dart';

// 성공하면 User, 실패하면 Failure
Either<Failure, User> result;

// Left (실패)
result = Left(NetworkFailure('인터넷 연결을 확인해주세요.'));

// Right (성공)
result = Right(User(name: '홍길동'));
```

### 8.2 fold() 사용법

```dart
Future<void> login() async {
  final result = await loginUseCase(LoginParams(email: email, password: password));

  // fold: 두 경우를 모두 처리
  result.fold(
    // Left 처리 (실패)
    (failure) {
      showSnackBar(failure.message);
      state = AuthError(failure.message);
    },
    // Right 처리 (성공)
    (user) {
      state = AuthAuthenticated(user);
      navigateToHome();
    },
  );
}
```

### 8.3 왜 Either를 쓰나요?

**기존 try-catch 방식:**
```dart
// 문제점: 어떤 에러가 발생할 수 있는지 알기 어려움
try {
  final user = await login(email, password);
  // 성공 처리
} catch (e) {
  // 어떤 종류의 에러인지 구분하기 어려움
}
```

**Either 방식:**
```dart
// 장점: 성공/실패가 타입으로 명확하게 표현됨
final result = await loginUseCase(params);

result.fold(
  (failure) {
    // failure의 타입을 보고 세부 처리 가능
    if (failure is NetworkFailure) {
      showNetworkError();
    } else if (failure is InvalidCredentialsFailure) {
      showInvalidCredentialsError();
    }
  },
  (user) {
    // 성공 처리
  },
);
```

---

## 9. 실전 예제: Record Feature 전체 구현

poozizic 프로젝트에 바로 적용할 수 있는 전체 예제입니다.

### 필요한 의존성 추가

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
  dartz: ^0.10.1
  http: ^1.2.0
  # 로컬 DB 사용 시
  # sqflite: ^2.3.0
  # path: ^1.8.3
```

### 파일 구조

```
lib/
├── main.dart
├── shared/
│   └── domain/
│       ├── failure/
│       │   └── failure.dart
│       └── usecase/
│           └── usecase.dart
└── feature/
    └── record/
        ├── data/
        │   ├── datasource/
        │   │   └── record_remote_datasource.dart
        │   └── repository/
        │       └── record_repository_impl.dart
        ├── domain/
        │   ├── entity/
        │   │   └── record_entity.dart
        │   ├── repository/
        │   │   └── record_repository.dart
        │   ├── usecase/
        │   │   ├── create_record_usecase.dart
        │   │   └── get_records_usecase.dart
        │   └── failure/
        │       └── record_failure.dart
        ├── presentation/
        │   ├── page/
        │   │   └── record_page.dart
        │   └── provider/
        │       ├── record_state.dart
        │       └── record_notifier.dart
        └── di/
            └── record_providers.dart
```

### main.dart 설정

```dart
// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // Riverpod 사용을 위해 ProviderScope로 감싸기
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Poozizic',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
```

---

## 10. 자주 묻는 질문 (FAQ)

### Q1. "왜 파일이 이렇게 많아요?"

**A:** 처음에는 많아 보이지만, 각 파일이 하나의 역할만 담당합니다.

- **장점:**
  - 파일이 작아서 이해하기 쉬움
  - 테스트하기 쉬움
  - 여러 명이 동시에 작업 가능
  - 나중에 수정할 때 영향 범위가 적음

- **비유:**
  - 레고 블록처럼 작은 조각들을 조립하는 것
  - 하나가 망가져도 그것만 교체하면 됨

### Q2. "UseCase가 꼭 필요한가요?"

**A:** 작은 프로젝트에서는 선택적입니다.

- **UseCase 장점:**
  - 비즈니스 로직이 한 곳에 모임
  - 테스트하기 쉬움
  - 여러 화면에서 재사용 가능

- **UseCase 없이 간단하게:**
  - Repository를 Notifier에서 직접 호출해도 됨
  - 프로젝트가 커지면 나중에 UseCase 추가 가능

```dart
// UseCase 없이 간단한 버전
class RecordNotifier extends StateNotifier<RecordState> {
  final RecordRepository repository;  // Repository 직접 사용

  Future<void> loadRecords() async {
    state = const RecordLoading();
    try {
      final records = await repository.getAllRecords();
      state = RecordLoaded(records);
    } catch (e) {
      state = RecordError(e.toString());
    }
  }
}
```

### Q3. "React의 Custom Hook이랑 뭐가 달라요?"

**A:** 개념적으로 비슷하지만 구조가 다릅니다.

| React Custom Hook | Flutter UseCase |
|-------------------|-----------------|
| UI 로직 + 비즈니스 로직 혼합 가능 | 순수 비즈니스 로직만 |
| 컴포넌트 내부에서 직접 호출 | Provider를 통해 주입 |
| 테스트 시 mock 어려움 | DI로 쉽게 mock 가능 |

### Q4. "Riverpod vs Provider vs BLoC 뭐가 좋아요?"

**A:** 각각 장단점이 있습니다.

| | Provider | Riverpod | BLoC |
|--|----------|----------|------|
| 학습 곡선 | 낮음 | 중간 | 높음 |
| 보일러플레이트 | 적음 | 중간 | 많음 |
| 타입 안전성 | 보통 | 높음 | 높음 |
| 테스트 용이성 | 보통 | 높음 | 높음 |
| Google 공식 | Yes | No | No |

**추천:**
- 작은 프로젝트: Provider
- 중간~큰 프로젝트: Riverpod (권장)
- 대규모/엔터프라이즈: BLoC

### Q5. "sealed class가 뭔가요?"

**A:** Dart 3.0에서 추가된 기능으로, 모든 자식 클래스를 같은 파일에 정의해야 합니다.

```dart
// sealed class 장점: 컴파일러가 모든 케이스 처리를 강제함
sealed class RecordState {}
class RecordInitial extends RecordState {}
class RecordLoading extends RecordState {}
class RecordLoaded extends RecordState {}
class RecordError extends RecordState {}

// switch에서 하나라도 빠뜨리면 컴파일 에러!
Widget build() {
  return switch (state) {
    RecordInitial() => ...,
    RecordLoading() => ...,
    RecordLoaded() => ...,
    RecordError() => ...,
    // 빠뜨리면 에러!
  };
}
```

### Q6. "데이터 흐름을 다시 정리해주세요"

```
사용자가 버튼 클릭
    ↓
Widget에서 ref.read(notifier).createRecord() 호출
    ↓
Notifier에서 UseCase.call() 실행
    ↓
UseCase에서 Repository.createRecord() 호출
    ↓
RepositoryImpl에서 DataSource.createRecord() 호출
    ↓
DataSource에서 실제 API 호출 / DB 저장
    ↓
결과가 역방향으로 전달
    ↓
Notifier에서 state 업데이트
    ↓
ref.watch 하고 있던 Widget이 자동 rebuild
    ↓
UI 업데이트!
```

---

## 마무리

클린 아키텍처는 처음에는 복잡해 보이지만, 프로젝트가 커질수록 그 진가를 발휘합니다.

**핵심 포인트:**
1. 계층을 분리하여 각 역할을 명확히
2. 의존성은 항상 안쪽으로 (Presentation → Domain ← Data)
3. Riverpod으로 의존성 주입
4. Either 패턴으로 에러 처리
5. Sealed Class로 상태 관리

궁금한 점이 있으면 언제든 물어보세요!
