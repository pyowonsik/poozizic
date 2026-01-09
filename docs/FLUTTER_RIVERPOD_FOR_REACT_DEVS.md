# Flutter + Riverpod + Clean Architecture 가이드
> React (Zustand) 개발자를 위한 쉬운 설명

## 1. Zustand vs Riverpod 개념 비교

| Zustand (React) | Riverpod (Flutter) | 설명 |
|-----------------|-------------------|------|
| `create((set) => ...)` | `StateNotifierProvider` | store 생성 |
| `useStore()` | `ref.watch()` | 상태 구독 (자동 리렌더링) |
| `useStore.getState()` | `ref.read()` | 상태 읽기만 (구독 안함) |
| `set({ ... })` | `state = NewState()` | 상태 업데이트 |
| `store.actions.xxx()` | `ref.read(provider.notifier).xxx()` | 액션 호출 |
| `Component` | `Widget` | UI 컴포넌트 |
| `props` | `constructor 파라미터` | 데이터 전달 |

---

## 2. 프로젝트 구조 (Clean Architecture)

```
lib/feature/record/
├── domain/          ← 비즈니스 로직 (순수 Dart, 외부 의존성 없음)
│   ├── entity/      ← 데이터 모델 (TypeScript interface 같은 것)
│   ├── repository/  ← 인터페이스 정의
│   ├── usecase/     ← 비즈니스 로직 함수들
│   └── failure/     ← 에러 타입 정의
│
├── data/            ← 실제 데이터 처리
│   ├── datasource/  ← API 호출, 로컬 DB (fetch, axios 같은 것)
│   └── repository/  ← domain의 repository 구현체
│
├── presentation/    ← UI 관련
│   ├── page/        ← 화면 (React의 Page 컴포넌트)
│   ├── widget/      ← 작은 컴포넌트들
│   └── provider/    ← 상태 관리 (Redux store 같은 것)
│
└── di/              ← 의존성 주입 (Provider 연결)
    └── providers.dart
```

### React로 비유하면?

```
src/features/record/
├── types/           ← domain/entity (TypeScript types)
├── api/             ← data/datasource (API 호출)
├── hooks/           ← presentation/provider (커스텀 훅, Redux)
├── components/      ← presentation/widget
└── pages/           ← presentation/page
```

---

## 3. 데이터 흐름 (핵심!)

```
[UI 화면] → [Provider/Notifier] → [UseCase] → [Repository] → [DataSource]
    ↑              ↓
    └──── 상태 업데이트 ────┘
```

### Zustand로 비유

```
[Component] → [useStore / actions] → [서비스 함수] → [API 모듈] → [fetch/axios]
     ↑              ↓
     └──── set() ────┘
```

### 1:1 매핑

| Flutter (Riverpod) | React (Zustand) |
|-------------------|-----------------|
| `StateNotifierProvider` | `create((set) => ({ ... }))` |
| `StateNotifier` 클래스 | store 안의 actions |
| `state = NewState()` | `set({ ... })` |
| `ref.watch(provider)` | `useStore()` |
| `ref.read(provider.notifier).action()` | `useStore.getState().action()` |

---

## 4. 실제 코드로 보는 사용법

### 4.1 Entity (데이터 모델)

```dart
// lib/feature/record/domain/entity/record_entity.dart

/// React의 TypeScript interface와 같음
/// interface RecordEntity { id?: number; dateTime: Date; ... }
class RecordEntity {
  final int? id;
  final DateTime dateTime;
  final int bristolType;  // 1-7
  final int feeling;      // 0: 시원함, 1: 보통, 2: 불편함, 3: 잔변감

  const RecordEntity({
    this.id,
    required this.dateTime,
    required this.bristolType,
    required this.feeling,
  });
}
```

### 4.2 State (상태 정의)

```dart
// lib/feature/record/presentation/provider/record_form_state.dart

/// Zustand store의 state 타입과 비슷
/// type State = { status: 'idle' | 'loading' | 'success' | 'error', data?: T }

sealed class RecordFormState {}

class RecordFormInitial extends RecordFormState {}      // 초기 상태
class RecordFormLoading extends RecordFormState {}      // 로딩 중
class RecordFormSuccess extends RecordFormState {       // 성공
  final RecordEntity record;
  RecordFormSuccess(this.record);
}
class RecordFormError extends RecordFormState {         // 에러
  final String message;
  RecordFormError(this.message);
}
```

### 4.3 Notifier (상태 변경 로직)

```dart
// lib/feature/record/presentation/provider/record_form_notifier.dart

/// Zustand의 create() 안에 정의하는 actions와 같음!

class RecordFormNotifier extends StateNotifier<RecordFormState> {
  RecordFormNotifier(this._createRecordUseCase)
      : super(RecordFormInitial());  // 초기 상태 설정

  final CreateRecordUseCase _createRecordUseCase;

  // Zustand: selectBristolType: (type) => set({ bristolType: type })
  void selectBristolType(int type) {
    // state = 새로운 상태 (Zustand의 set()과 같음)
    state = RecordFormInProgress(bristolType: type);
  }

  // Zustand: submit: async () => { set({ status: 'loading' }); ... }
  Future<void> submit() async {
    state = RecordFormLoading();  // set({ status: 'loading' })

    final result = await _createRecordUseCase(params);

    // Either는 성공/실패를 한번에 처리 (try-catch 대신)
    result.fold(
      (failure) => state = RecordFormError(failure.message),  // 실패
      (record) => state = RecordFormSuccess(record),          // 성공
    );
  }
}
```

### 4.4 Provider 정의 (의존성 주입)

```dart
// lib/feature/record/di/record_providers.dart

/// Zustand의 create()로 store 만드는 것과 비슷
/// 전역에서 접근 가능한 상태/서비스 정의

// 1. DataSource (API 클라이언트)
final recordDataSourceProvider = Provider((ref) {
  return RecordLocalDataSource();  // axios instance 같은 것
});

// 2. Repository
final recordRepositoryProvider = Provider((ref) {
  final dataSource = ref.watch(recordDataSourceProvider);
  return RecordRepositoryImpl(dataSource);
});

// 3. UseCase
final createRecordUseCaseProvider = Provider((ref) {
  final repo = ref.watch(recordRepositoryProvider);
  return CreateRecordUseCase(repo);
});

// 4. 상태 관리 (★ 가장 중요!)
final recordFormNotifierProvider = StateNotifierProvider.autoDispose<
    RecordFormNotifier, RecordFormState>((ref) {
  final useCase = ref.watch(createRecordUseCaseProvider);
  return RecordFormNotifier(useCase);
});

// autoDispose: 화면 나가면 상태 초기화 (React의 컴포넌트 언마운트와 같음)
```

### 4.5 UI에서 사용하기 (★ 가장 중요!)

```dart
// lib/feature/record/presentation/page/record_page.dart

/// Zustand 사용하는 React 컴포넌트와 비교

// ❌ 일반 StatelessWidget (상태 접근 불가)
// ✅ ConsumerWidget 사용 (ref로 상태 접근 가능)

class RecordPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // ★ ref.watch = Zustand의 useStore()
    // 상태가 바뀌면 자동으로 리렌더링됨!
    final state = ref.watch(recordFormNotifierProvider);

    // 상태에 따라 다른 UI 렌더링 (조건부 렌더링)
    return switch (state) {
      RecordFormInitial() => Text('시작하세요'),
      RecordFormLoading() => CircularProgressIndicator(),
      RecordFormSuccess(:final record) => Text('성공! ID: ${record.id}'),
      RecordFormError(:final message) => Text('에러: $message'),
    };
  }
}
```

---

## 5. ref.watch vs ref.read (중요!)

### ref.watch() - 구독 (자동 리렌더링)

```dart
// Zustand: const { status, data } = useStore()
// 상태 바뀌면 자동으로 build() 다시 실행됨

Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(recordFormNotifierProvider);  // ✅ build 안에서
  return Text(state.toString());
}
```

### ref.read() - 일회성 읽기 (구독 안함)

```dart
// Zustand: useStore.getState().submit() 또는 이벤트 핸들러에서
// 버튼 클릭 등 이벤트에서 사용

void _onSubmitPressed() {
  // ✅ 이벤트 핸들러에서 read 사용
  ref.read(recordFormNotifierProvider.notifier).submit();
}
```

### 규칙 요약

| 상황 | 사용 | Zustand 비유 |
|-----|------|-------------|
| UI 렌더링에 필요 | `ref.watch()` | `useStore()` |
| 버튼 클릭 핸들러 | `ref.read()` | `useStore.getState()` |
| `build()` 안에서 | `ref.watch()` | 컴포넌트 본문 |
| 함수/콜백 안에서 | `ref.read()` | onClick 핸들러 |

---

## 6. 실전 예제: 버튼 클릭 → API 호출 → UI 업데이트

### Zustand 버전 (React)

```jsx
// store 정의
const useRecordStore = create((set) => ({
  status: 'idle',
  data: null,
  error: null,

  submit: async (bristolType) => {
    set({ status: 'loading' });
    try {
      const data = await api.createRecord({ bristolType });
      set({ status: 'success', data });
    } catch (e) {
      set({ status: 'error', error: e.message });
    }
  }
}));

// 컴포넌트에서 사용
function RecordPage() {
  const { status, data, error, submit } = useRecordStore();

  if (status === 'loading') return <Spinner />;
  if (status === 'error') return <div>Error: {error}</div>;
  if (status === 'success') return <div>Success! ID: {data.id}</div>;

  return <button onClick={() => submit(4)}>기록하기</button>;
}
```

### Flutter Riverpod 버전

```dart
class RecordPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Zustand: const { status, data } = useRecordStore()
    final state = ref.watch(recordFormNotifierProvider);

    // 버튼 클릭 핸들러
    void handleSubmit() {
      // Zustand: submit(4) 호출하는 것과 같음
      ref.read(recordFormNotifierProvider.notifier).submit();
    }

    // 조건부 렌더링
    return switch (state) {
      RecordFormLoading() => CircularProgressIndicator(),
      RecordFormError(:final message) => Text('Error: $message'),
      RecordFormSuccess(:final record) => Text('Success! ID: ${record.id}'),
      _ => ElevatedButton(
        onPressed: handleSubmit,
        child: Text('기록하기'),
      ),
    };
  }
}
```

---

## 7. 새 기능 추가할 때 순서

### Step 1: Entity 만들기
```dart
// lib/feature/새기능/domain/entity/xxx_entity.dart
class XxxEntity {
  final int id;
  final String name;
  // ...
}
```

### Step 2: Repository 인터페이스 만들기
```dart
// lib/feature/새기능/domain/repository/xxx_repository.dart
abstract class XxxRepository {
  Future<Either<Failure, List<XxxEntity>>> getAll();
  Future<Either<Failure, XxxEntity>> create(XxxEntity entity);
}
```

### Step 3: DataSource 만들기 (API 호출)
```dart
// lib/feature/새기능/data/datasource/xxx_datasource.dart
class XxxLocalDataSource {
  Future<List<XxxEntity>> getAll() async {
    // API 호출 또는 로컬 DB 조회
  }
}
```

### Step 4: Repository 구현
```dart
// lib/feature/새기능/data/repository/xxx_repository_impl.dart
class XxxRepositoryImpl implements XxxRepository {
  final XxxLocalDataSource _dataSource;

  @override
  Future<Either<Failure, List<XxxEntity>>> getAll() async {
    try {
      final data = await _dataSource.getAll();
      return Right(data);  // 성공
    } catch (e) {
      return Left(XxxFailure('에러 발생'));  // 실패
    }
  }
}
```

### Step 5: State + Notifier 만들기
```dart
// lib/feature/새기능/presentation/provider/xxx_state.dart
sealed class XxxState {}
class XxxInitial extends XxxState {}
class XxxLoading extends XxxState {}
class XxxLoaded extends XxxState {
  final List<XxxEntity> items;
  XxxLoaded(this.items);
}
class XxxError extends XxxState {
  final String message;
  XxxError(this.message);
}

// lib/feature/새기능/presentation/provider/xxx_notifier.dart
class XxxNotifier extends StateNotifier<XxxState> {
  XxxNotifier(this._repository) : super(XxxInitial());

  final XxxRepository _repository;

  Future<void> load() async {
    state = XxxLoading();
    final result = await _repository.getAll();
    result.fold(
      (failure) => state = XxxError(failure.message),
      (items) => state = XxxLoaded(items),
    );
  }
}
```

### Step 6: Provider 등록
```dart
// lib/feature/새기능/di/xxx_providers.dart
final xxxDataSourceProvider = Provider((ref) => XxxLocalDataSource());

final xxxRepositoryProvider = Provider((ref) {
  return XxxRepositoryImpl(ref.watch(xxxDataSourceProvider));
});

final xxxNotifierProvider = StateNotifierProvider<XxxNotifier, XxxState>((ref) {
  return XxxNotifier(ref.watch(xxxRepositoryProvider));
});
```

### Step 7: UI에서 사용
```dart
class XxxPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(xxxNotifierProvider);

    return switch (state) {
      XxxLoading() => CircularProgressIndicator(),
      XxxLoaded(:final items) => ListView.builder(...),
      XxxError(:final message) => Text(message),
      _ => ElevatedButton(
        onPressed: () => ref.read(xxxNotifierProvider.notifier).load(),
        child: Text('로드'),
      ),
    };
  }
}
```

---

## 8. 자주 쓰는 코드 스니펫

### ConsumerWidget (상태 사용하는 위젯)

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(myProvider);
    return Container();
  }
}
```

### ConsumerStatefulWidget (상태 + 생명주기)

```dart
class MyPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyPage> createState() => _MyPageState();
}

class _MyPageState extends ConsumerState<MyPage> {
  @override
  void initState() {
    super.initState();
    // 페이지 진입 시 데이터 로드
    Future.microtask(() {
      ref.read(myProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myProvider);
    return Container();
  }
}
```

### 상태 초기화 (리프레시)

```dart
// 특정 Provider 상태 초기화
ref.invalidate(myProvider);

// 또는 강제 새로고침
ref.refresh(myProvider);
```

---

## 9. 트러블슈팅

### Q: 상태가 안 바뀌어요!

```dart
// ❌ 잘못된 방법 - 직접 수정
state.items.add(newItem);  // 이러면 UI 안 바뀜!

// ✅ 올바른 방법 - 새 객체 할당
state = XxxLoaded([...state.items, newItem]);
```

### Q: build에서 에러가 나요!

```dart
// ❌ build 안에서 상태 변경하면 에러
Widget build(context, ref) {
  ref.read(provider.notifier).load();  // 에러!
}

// ✅ initState나 버튼 핸들러에서 호출
void initState() {
  Future.microtask(() => ref.read(provider.notifier).load());
}
```

### Q: 화면 나갔다 오면 상태가 초기화돼요!

```dart
// autoDispose 때문 - 필요하면 제거
final myProvider = StateNotifierProvider<...>((ref) {  // autoDispose 없음
  return MyNotifier();
});
```

---

## 10. 현재 프로젝트 구조

```
lib/
├── feature/
│   ├── record/      ← 배변 기록 (완성)
│   ├── calendar/    ← 캘린더 (완성)
│   └── settings/    ← 설정 (완성)
│
├── screens/         ← 아직 마이그레이션 안된 화면들
│   ├── home_screen.dart
│   ├── analytics_screen.dart
│   └── ...
│
├── shared/
│   └── domain/
│       ├── failure/failure.dart   ← 공통 에러 클래스
│       └── usecase/usecase.dart   ← 공통 UseCase 인터페이스
│
└── main.dart        ← 앱 진입점 (ProviderScope 설정됨)
```

---

## 요약 치트시트

| 하고 싶은 것 | Zustand (React) | Riverpod (Flutter) |
|-------------|-----------------|-------------------|
| store 생성 | `create((set) => {...})` | `StateNotifierProvider` |
| 상태 구독 | `useStore()` | `ref.watch(provider)` |
| 상태 읽기만 | `useStore.getState()` | `ref.read(provider)` |
| 액션 호출 | `submit()` | `ref.read(provider.notifier).submit()` |
| 상태 업데이트 | `set({ status: 'loading' })` | `state = Loading()` |
| 상태 초기화 | `useStore.setState(initialState)` | `ref.invalidate(provider)` |

---

*문서 작성: 2026-01-09*
*문의: 기존 feature/record, feature/calendar, feature/settings 코드 참고*
