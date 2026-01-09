# Flutter Riverpod 완벽 가이드

> 리액트 개발자를 위한 Riverpod 상태관리 입문서

---

## 목차

1. [Riverpod이란?](#1-riverpod이란)
2. [설치 및 설정](#2-설치-및-설정)
3. [React와 Riverpod 비교](#3-react와-riverpod-비교)
4. [Provider 종류 완전 정복](#4-provider-종류-완전-정복)
5. [ref.watch vs ref.read vs ref.listen](#5-refwatch-vs-refread-vs-reflisten)
6. [ConsumerWidget vs Consumer](#6-consumerwidget-vs-consumer)
7. [AutoDispose 패턴](#7-autodispose-패턴)
8. [Family 패턴](#8-family-패턴)
9. [Provider 조합하기](#9-provider-조합하기)
10. [실전 패턴 모음](#10-실전-패턴-모음)
11. [자주 하는 실수](#11-자주-하는-실수)
12. [디버깅 팁](#12-디버깅-팁)

---

## 1. Riverpod이란?

Riverpod은 Flutter의 **상태 관리 + 의존성 주입** 라이브러리입니다.

### React로 비유하면

```
Riverpod = React Context API + Redux + React Query + 의존성 주입
```

### 왜 Riverpod인가?

| 장점 | 설명 |
|------|------|
| **컴파일 타임 안전성** | Provider를 잘못 사용하면 컴파일 에러 |
| **테스트 용이성** | Provider를 쉽게 mock 가능 |
| **자동 캐싱** | 같은 데이터 중복 요청 방지 |
| **자동 dispose** | 메모리 누수 방지 |
| **DevTools 지원** | 상태 변화 추적 가능 |

### Provider vs Riverpod

```
Provider (Google 공식)
├── 단순하고 배우기 쉬움
├── BuildContext 필요
└── 타입 안전성 부족

Riverpod (Provider 제작자가 만든 개선판)
├── BuildContext 불필요
├── 컴파일 타임 안전성
├── 더 강력한 기능 (Family, AutoDispose 등)
└── 테스트 용이
```

---

## 2. 설치 및 설정

### pubspec.yaml

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_riverpod: ^2.6.1
```

### main.dart 설정

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    // 앱 전체를 ProviderScope로 감싸기 (필수!)
    // React의 <Provider store={store}> 와 같은 역할
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
      home: HomeScreen(),
    );
  }
}
```

---

## 3. React와 Riverpod 비교

### 3.1 기본 상태 관리

**React (useState)**
```javascript
function Counter() {
  const [count, setCount] = useState(0);

  return (
    <div>
      <p>Count: {count}</p>
      <button onClick={() => setCount(count + 1)}>+1</button>
    </div>
  );
}
```

**Flutter (StateProvider)**
```dart
// Provider 정의 (파일 상단 또는 별도 파일)
final counterProvider = StateProvider<int>((ref) => 0);

// Widget에서 사용
class Counter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('Count: $count'),
        ElevatedButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: Text('+1'),
        ),
      ],
    );
  }
}
```

### 3.2 전역 상태 관리

**React (Redux)**
```javascript
// store.js
const userSlice = createSlice({
  name: 'user',
  initialState: { user: null, loading: false, error: null },
  reducers: {
    setLoading: (state) => { state.loading = true },
    setUser: (state, action) => {
      state.user = action.payload;
      state.loading = false;
    },
    setError: (state, action) => {
      state.error = action.payload;
      state.loading = false;
    },
  },
});

// Component.jsx
function UserProfile() {
  const { user, loading, error } = useSelector(state => state.user);
  const dispatch = useDispatch();

  useEffect(() => {
    dispatch(fetchUser());
  }, []);

  if (loading) return <Spinner />;
  if (error) return <Error message={error} />;
  return <div>{user.name}</div>;
}
```

**Flutter (StateNotifierProvider)**
```dart
// user_state.dart - 상태 정의
sealed class UserState {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final User user;
  UserLoaded(this.user);
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// user_notifier.dart - 상태 변경 로직
class UserNotifier extends StateNotifier<UserState> {
  UserNotifier() : super(UserInitial());

  Future<void> fetchUser() async {
    state = UserLoading();
    try {
      final user = await api.getUser();
      state = UserLoaded(user);
    } catch (e) {
      state = UserError(e.toString());
    }
  }
}

// providers.dart
final userNotifierProvider =
    StateNotifierProvider<UserNotifier, UserState>((ref) {
  return UserNotifier();
});

// user_profile.dart - Widget
class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userNotifierProvider);

    return switch (state) {
      UserInitial() => ElevatedButton(
          onPressed: () => ref.read(userNotifierProvider.notifier).fetchUser(),
          child: Text('Load User'),
        ),
      UserLoading() => CircularProgressIndicator(),
      UserLoaded(:final user) => Text(user.name),
      UserError(:final message) => Text('Error: $message'),
    };
  }
}
```

### 3.3 비동기 데이터 패칭

**React (React Query)**
```javascript
function UserList() {
  const { data, isLoading, error } = useQuery('users', fetchUsers);

  if (isLoading) return <Spinner />;
  if (error) return <Error />;
  return <List data={data} />;
}
```

**Flutter (FutureProvider)**
```dart
// Provider 정의
final usersProvider = FutureProvider<List<User>>((ref) async {
  return await api.fetchUsers();
});

// Widget
class UserList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersProvider);

    return usersAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (users) => ListView.builder(
        itemCount: users.length,
        itemBuilder: (ctx, i) => Text(users[i].name),
      ),
    );
  }
}
```

---

## 4. Provider 종류 완전 정복

### 4.1 Provider (읽기 전용)

**용도:** 변하지 않는 값, 설정, 인스턴스 제공

```dart
// API URL 같은 상수
final apiUrlProvider = Provider<String>((ref) {
  return 'https://api.example.com';
});

// Repository 인스턴스
final userRepositoryProvider = Provider<UserRepository>((ref) {
  final apiUrl = ref.watch(apiUrlProvider);
  return UserRepository(apiUrl);
});

// 사용
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiUrl = ref.watch(apiUrlProvider);
    return Text('API: $apiUrl');
  }
}
```

### 4.2 StateProvider (단순 상태)

**용도:** 단순한 상태 (숫자, 문자열, boolean 등)

```dart
// 카운터
final counterProvider = StateProvider<int>((ref) => 0);

// 검색어
final searchQueryProvider = StateProvider<String>((ref) => '');

// 다크모드 토글
final isDarkModeProvider = StateProvider<bool>((ref) => false);

// 선택된 탭
final selectedTabProvider = StateProvider<int>((ref) => 0);

// 사용
class CounterWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);

    return Column(
      children: [
        Text('$count'),
        Row(
          children: [
            // 값 증가
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state++,
              child: Text('+'),
            ),
            // 값 감소
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state--,
              child: Text('-'),
            ),
            // 값 설정
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state = 0,
              child: Text('Reset'),
            ),
            // update로 이전 값 기반 변경
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).update((state) => state * 2),
              child: Text('x2'),
            ),
          ],
        ),
      ],
    );
  }
}
```

### 4.3 StateNotifierProvider (복잡한 상태 + 로직)

**용도:** 복잡한 상태, 비즈니스 로직이 필요한 경우

```dart
// 상태 정의
class TodoState {
  final List<Todo> todos;
  final bool isLoading;
  final String? error;

  const TodoState({
    this.todos = const [],
    this.isLoading = false,
    this.error,
  });

  TodoState copyWith({
    List<Todo>? todos,
    bool? isLoading,
    String? error,
  }) {
    return TodoState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Notifier 정의
class TodoNotifier extends StateNotifier<TodoState> {
  final TodoRepository repository;

  TodoNotifier(this.repository) : super(const TodoState());

  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final todos = await repository.getAll();
      state = state.copyWith(todos: todos, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> addTodo(String title) async {
    final newTodo = Todo(id: DateTime.now().toString(), title: title);
    state = state.copyWith(todos: [...state.todos, newTodo]);

    try {
      await repository.create(newTodo);
    } catch (e) {
      // 롤백
      state = state.copyWith(
        todos: state.todos.where((t) => t.id != newTodo.id).toList(),
        error: e.toString(),
      );
    }
  }

  void toggleTodo(String id) {
    state = state.copyWith(
      todos: state.todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(completed: !todo.completed);
        }
        return todo;
      }).toList(),
    );
  }

  void removeTodo(String id) {
    state = state.copyWith(
      todos: state.todos.where((t) => t.id != id).toList(),
    );
  }
}

// Provider 정의
final todoNotifierProvider =
    StateNotifierProvider<TodoNotifier, TodoState>((ref) {
  final repository = ref.watch(todoRepositoryProvider);
  return TodoNotifier(repository);
});

// Widget에서 사용
class TodoList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoState = ref.watch(todoNotifierProvider);

    if (todoState.isLoading) {
      return CircularProgressIndicator();
    }

    if (todoState.error != null) {
      return Text('Error: ${todoState.error}');
    }

    return ListView.builder(
      itemCount: todoState.todos.length,
      itemBuilder: (context, index) {
        final todo = todoState.todos[index];
        return ListTile(
          title: Text(todo.title),
          leading: Checkbox(
            value: todo.completed,
            onChanged: (_) {
              ref.read(todoNotifierProvider.notifier).toggleTodo(todo.id);
            },
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              ref.read(todoNotifierProvider.notifier).removeTodo(todo.id);
            },
          ),
        );
      },
    );
  }
}
```

### 4.4 FutureProvider (비동기 데이터)

**용도:** 한 번 불러오는 비동기 데이터

```dart
// 단순 Future
final userProvider = FutureProvider<User>((ref) async {
  return await api.fetchCurrentUser();
});

// 다른 Provider 의존
final userPostsProvider = FutureProvider<List<Post>>((ref) async {
  final user = await ref.watch(userProvider.future);
  return await api.fetchPostsByUser(user.id);
});

// Widget에서 사용 - when 패턴
class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (error, stackTrace) => Column(
        children: [
          Text('Error: $error'),
          ElevatedButton(
            onPressed: () => ref.invalidate(userProvider), // 재시도
            child: Text('Retry'),
          ),
        ],
      ),
      data: (user) => Column(
        children: [
          Text(user.name),
          Text(user.email),
        ],
      ),
    );
  }
}

// AsyncValue 직접 처리
class UserProfile2 extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    // isLoading, hasError, hasValue 등으로 체크 가능
    if (userAsync.isLoading) {
      return CircularProgressIndicator();
    }

    if (userAsync.hasError) {
      return Text('Error: ${userAsync.error}');
    }

    final user = userAsync.value!;
    return Text(user.name);
  }
}
```

### 4.5 StreamProvider (실시간 데이터)

**용도:** WebSocket, Firebase Realtime DB 등 실시간 데이터

```dart
// Stream Provider
final messagesProvider = StreamProvider<List<Message>>((ref) {
  return chatRepository.messagesStream();
});

// Firebase 예시
final userDocProvider = StreamProvider<User>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .snapshots()
      .map((doc) => User.fromJson(doc.data()!));
});

// Widget에서 사용
class ChatScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messagesAsync = ref.watch(messagesProvider);

    return messagesAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (messages) => ListView.builder(
        itemCount: messages.length,
        itemBuilder: (ctx, i) => MessageBubble(messages[i]),
      ),
    );
  }
}
```

### 4.6 NotifierProvider (Riverpod 2.0 신규)

**용도:** StateNotifier의 개선 버전 (권장)

```dart
// Notifier 정의 (더 간결한 문법)
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;  // 초기값

  void increment() => state++;
  void decrement() => state--;
  void reset() => state = 0;
}

// Provider 정의
final counterNotifierProvider = NotifierProvider<CounterNotifier, int>(() {
  return CounterNotifier();
});

// 사용
class Counter extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterNotifierProvider);

    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () => ref.read(counterNotifierProvider.notifier).increment(),
          child: Text('+'),
        ),
      ],
    );
  }
}
```

### 4.7 AsyncNotifierProvider (비동기 Notifier)

**용도:** 비동기 초기화 + 상태 변경 로직

```dart
// AsyncNotifier 정의
class UserNotifier extends AsyncNotifier<User> {
  @override
  Future<User> build() async {
    // 초기 데이터 로드
    return await ref.watch(userRepositoryProvider).getCurrentUser();
  }

  Future<void> updateProfile(String name) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return await ref.read(userRepositoryProvider).updateProfile(name);
    });
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

// Provider
final userNotifierProvider = AsyncNotifierProvider<UserNotifier, User>(() {
  return UserNotifier();
});

// Widget
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userNotifierProvider);

    return userAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (user) => Column(
        children: [
          Text(user.name),
          ElevatedButton(
            onPressed: () {
              ref.read(userNotifierProvider.notifier).updateProfile('New Name');
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}
```

### Provider 선택 가이드

```
어떤 Provider를 써야 할까요?

Q: 값이 변하나요?
├── No → Provider
└── Yes ↓

Q: 단순한 값인가요? (int, String, bool 등)
├── Yes → StateProvider
└── No ↓

Q: 비동기 데이터인가요?
├── Yes ↓
│   Q: 한 번만 불러오나요?
│   ├── Yes → FutureProvider
│   └── No (실시간) → StreamProvider
└── No ↓

Q: 복잡한 로직이 필요한가요?
├── Yes → StateNotifierProvider 또는 NotifierProvider
└── No → StateProvider로 충분
```

---

## 5. ref.watch vs ref.read vs ref.listen

### 5.1 ref.watch - 구독 (상태 변경시 rebuild)

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // watch: 이 Provider의 상태가 바뀌면 Widget이 rebuild됨
    final count = ref.watch(counterProvider);

    return Text('$count');
  }
}
```

**React 비유:** `useSelector`

### 5.2 ref.read - 한 번만 읽기 (액션 실행용)

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // read: 현재 값만 읽고, 구독하지 않음
        // 콜백 (onPressed, onTap 등)에서 사용
        ref.read(counterProvider.notifier).state++;
      },
      child: Text('Increment'),
    );
  }
}
```

**React 비유:** `dispatch` 또는 `store.getState()`

### 5.3 ref.listen - 변경 감지 (사이드 이펙트)

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // listen: 상태 변경 시 콜백 실행 (rebuild 없음)
    // 스낵바, 네비게이션 등 사이드 이펙트에 사용
    ref.listen(authStateProvider, (previous, next) {
      if (next is AuthUnauthenticated) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });

    ref.listen(errorProvider, (prev, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next)),
        );
      }
    });

    return Container();
  }
}
```

**React 비유:** `useEffect`로 상태 변화 감지

### 핵심 규칙

```
build() 안에서:
├── UI 렌더링에 필요한 값 → ref.watch()
├── 콜백 함수 안에서 → ref.read()
└── 사이드 이펙트 (스낵바, 네비게이션) → ref.listen()

절대 하면 안 되는 것:
├── build() 안에서 ref.read() 후 UI 렌더링 (상태 변경 감지 못함)
└── onPressed 안에서 ref.watch() (매번 새 구독 생성)
```

---

## 6. ConsumerWidget vs Consumer

### 6.1 ConsumerWidget - Widget 전체가 Provider 사용

```dart
// 전체 Widget이 ref를 사용할 수 있음
class MyScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    final user = ref.watch(userProvider);

    return Column(
      children: [
        Text('Count: $count'),
        Text('User: ${user.name}'),
      ],
    );
  }
}
```

### 6.2 Consumer - 부분만 Provider 사용 (성능 최적화)

```dart
// 큰 Widget 중 일부만 rebuild 하고 싶을 때
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 이 부분은 rebuild 안됨
        ExpensiveWidget(),

        // 이 부분만 count 변경시 rebuild
        Consumer(
          builder: (context, ref, child) {
            final count = ref.watch(counterProvider);
            return Text('Count: $count');
          },
        ),

        // 이 부분도 rebuild 안됨
        AnotherExpensiveWidget(),
      ],
    );
  }
}
```

### 6.3 ConsumerStatefulWidget - StatefulWidget + Riverpod

```dart
class MyScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends ConsumerState<MyScreen> {
  @override
  void initState() {
    super.initState();
    // initState에서도 ref 사용 가능
    ref.read(counterProvider.notifier).state = 0;
  }

  @override
  Widget build(BuildContext context) {
    final count = ref.watch(counterProvider);
    return Text('$count');
  }
}
```

---

## 7. AutoDispose 패턴

### 7.1 AutoDispose란?

Provider를 더 이상 사용하지 않으면 자동으로 상태를 정리합니다.

```dart
// autoDispose 추가
final searchResultProvider = FutureProvider.autoDispose<List<Item>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  return await api.search(query);
});

// StateNotifier도 가능
final productNotifierProvider = StateNotifierProvider.autoDispose<
    ProductNotifier, ProductState>((ref) {
  return ProductNotifier();
});
```

### 7.2 언제 사용하나요?

```
AutoDispose 사용 권장:
├── 특정 화면에서만 사용하는 상태
├── 검색 결과 등 일시적인 데이터
├── 폼 입력 상태
└── 메모리 관리가 중요한 경우

AutoDispose 사용하지 않음:
├── 앱 전체에서 공유하는 상태 (로그인 정보 등)
├── 캐시하고 싶은 데이터
└── 백그라운드에서도 유지해야 하는 상태
```

### 7.3 keepAlive로 유지하기

```dart
final dataProvider = FutureProvider.autoDispose<Data>((ref) async {
  // 일정 시간 동안 살려두기
  final link = ref.keepAlive();

  // 5분 후 dispose 허용
  Timer(Duration(minutes: 5), () {
    link.close();
  });

  return await fetchData();
});
```

### 7.4 onDispose로 정리 작업

```dart
final socketProvider = Provider.autoDispose<WebSocket>((ref) {
  final socket = WebSocket.connect('ws://example.com');

  // Provider가 dispose될 때 실행
  ref.onDispose(() {
    socket.close();
  });

  return socket;
});
```

---

## 8. Family 패턴

### 8.1 Family란?

파라미터를 받는 Provider를 만들 수 있습니다.

```dart
// 특정 ID의 유저 정보 가져오기
final userByIdProvider = FutureProvider.family<User, int>((ref, userId) async {
  return await api.getUser(userId);
});

// 사용
class UserDetail extends ConsumerWidget {
  final int userId;

  const UserDetail({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // userId를 파라미터로 전달
    final userAsync = ref.watch(userByIdProvider(userId));

    return userAsync.when(
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
      data: (user) => Text(user.name),
    );
  }
}
```

### 8.2 Family + AutoDispose

```dart
// 조합 가능
final postsByUserProvider = FutureProvider.autoDispose
    .family<List<Post>, int>((ref, userId) async {
  return await api.getPostsByUser(userId);
});
```

### 8.3 여러 파라미터가 필요할 때

```dart
// Record 클래스 정의 (파라미터 묶음)
class SearchParams {
  final String query;
  final int page;
  final String category;

  const SearchParams({
    required this.query,
    required this.page,
    required this.category,
  });

  // == 와 hashCode 구현 필수!
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchParams &&
          query == other.query &&
          page == other.page &&
          category == other.category;

  @override
  int get hashCode => Object.hash(query, page, category);
}

// Provider
final searchProvider = FutureProvider.family<SearchResult, SearchParams>(
  (ref, params) async {
    return await api.search(
      query: params.query,
      page: params.page,
      category: params.category,
    );
  },
);

// 사용
ref.watch(searchProvider(SearchParams(
  query: 'flutter',
  page: 1,
  category: 'tech',
)));
```

---

## 9. Provider 조합하기

### 9.1 다른 Provider 의존하기

```dart
// 기본 Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>(...);

// authState에 의존하는 Provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);

  return switch (authState) {
    AuthAuthenticated(:final user) => user,
    _ => null,
  };
});

// currentUser에 의존하는 Provider
final userPostsProvider = FutureProvider<List<Post>>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return [];

  return await api.getPostsByUser(user.id);
});
```

### 9.2 select로 특정 값만 구독

```dart
// 전체 상태 대신 특정 필드만 구독 (성능 최적화)
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 전체 TodoState가 아닌 todos.length만 구독
    // length가 변경될 때만 rebuild
    final todoCount = ref.watch(
      todoNotifierProvider.select((state) => state.todos.length),
    );

    return Text('할 일: $todoCount개');
  }
}
```

### 9.3 여러 Provider 조합

```dart
// 여러 데이터를 조합
final dashboardProvider = Provider<DashboardData>((ref) {
  final user = ref.watch(currentUserProvider);
  final todos = ref.watch(todoNotifierProvider);
  final notifications = ref.watch(notificationCountProvider);

  return DashboardData(
    userName: user?.name ?? 'Guest',
    todoCount: todos.todos.length,
    notificationCount: notifications,
  );
});
```

---

## 10. 실전 패턴 모음

### 10.1 페이지네이션

```dart
class PaginatedListNotifier extends StateNotifier<PaginatedState<Item>> {
  final ItemRepository repository;

  PaginatedListNotifier(this.repository) : super(PaginatedState.initial());

  Future<void> loadMore() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true);

    try {
      final items = await repository.getItems(
        page: state.currentPage + 1,
        limit: 20,
      );

      state = state.copyWith(
        items: [...state.items, ...items],
        currentPage: state.currentPage + 1,
        hasMore: items.length == 20,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> refresh() async {
    state = PaginatedState.initial().copyWith(isLoading: true);

    try {
      final items = await repository.getItems(page: 1, limit: 20);
      state = state.copyWith(
        items: items,
        currentPage: 1,
        hasMore: items.length == 20,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
```

### 10.2 폼 상태 관리

```dart
// 폼 상태
class RecordFormState {
  final DateTime dateTime;
  final int bristolType;
  final int feeling;
  final String memo;
  final bool isSubmitting;
  final String? error;

  const RecordFormState({
    required this.dateTime,
    this.bristolType = 4,
    this.feeling = 3,
    this.memo = '',
    this.isSubmitting = false,
    this.error,
  });

  RecordFormState copyWith({
    DateTime? dateTime,
    int? bristolType,
    int? feeling,
    String? memo,
    bool? isSubmitting,
    String? error,
  }) {
    return RecordFormState(
      dateTime: dateTime ?? this.dateTime,
      bristolType: bristolType ?? this.bristolType,
      feeling: feeling ?? this.feeling,
      memo: memo ?? this.memo,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }

  bool get isValid => bristolType >= 1 && bristolType <= 7;
}

// 폼 Notifier
class RecordFormNotifier extends StateNotifier<RecordFormState> {
  final CreateRecordUseCase createRecordUseCase;

  RecordFormNotifier(this.createRecordUseCase)
      : super(RecordFormState(dateTime: DateTime.now()));

  void setDateTime(DateTime value) {
    state = state.copyWith(dateTime: value);
  }

  void setBristolType(int value) {
    state = state.copyWith(bristolType: value);
  }

  void setFeeling(int value) {
    state = state.copyWith(feeling: value);
  }

  void setMemo(String value) {
    state = state.copyWith(memo: value);
  }

  Future<bool> submit() async {
    if (!state.isValid) {
      state = state.copyWith(error: '올바른 값을 입력해주세요.');
      return false;
    }

    state = state.copyWith(isSubmitting: true, error: null);

    final result = await createRecordUseCase(CreateRecordParams(
      dateTime: state.dateTime,
      bristolType: state.bristolType,
      feeling: state.feeling,
      memo: state.memo.isEmpty ? null : state.memo,
    ));

    return result.fold(
      (failure) {
        state = state.copyWith(isSubmitting: false, error: failure.message);
        return false;
      },
      (record) {
        state = state.copyWith(isSubmitting: false);
        return true;
      },
    );
  }

  void reset() {
    state = RecordFormState(dateTime: DateTime.now());
  }
}

// Provider (autoDispose로 화면 나가면 초기화)
final recordFormProvider = StateNotifierProvider.autoDispose<
    RecordFormNotifier, RecordFormState>((ref) {
  final createRecordUseCase = ref.watch(createRecordUseCaseProvider);
  return RecordFormNotifier(createRecordUseCase);
});
```

### 10.3 인증 상태 전역 관리

```dart
// 인증 상태
sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState {}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

// 인증 Notifier (앱 전체에서 사용하므로 autoDispose 없음)
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

// 로그인 여부만 간단히 확인하는 Provider
final isLoggedInProvider = Provider<bool>((ref) {
  final authState = ref.watch(authNotifierProvider);
  return authState is AuthAuthenticated;
});

// 현재 유저 Provider (null 가능)
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authNotifierProvider);
  if (authState is AuthAuthenticated) {
    return authState.user;
  }
  return null;
});
```

### 10.4 에러 처리 + 스낵바

```dart
// 전역 에러 Provider
final globalErrorProvider = StateProvider<String?>((ref) => null);

// Widget에서 에러 감지 후 스낵바 표시
class AppShell extends ConsumerWidget {
  final Widget child;

  const AppShell({required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 에러 발생시 스낵바 표시
    ref.listen(globalErrorProvider, (prev, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: '닫기',
              textColor: Colors.white,
              onPressed: () {
                ref.read(globalErrorProvider.notifier).state = null;
              },
            ),
          ),
        );
        // 표시 후 초기화
        Future.delayed(Duration(seconds: 3), () {
          ref.read(globalErrorProvider.notifier).state = null;
        });
      }
    });

    return child;
  }
}

// 어디서든 에러 발생시
ref.read(globalErrorProvider.notifier).state = '네트워크 오류가 발생했습니다.';
```

---

## 11. 자주 하는 실수

### 11.1 build() 안에서 ref.read() 사용

```dart
// 잘못된 예
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 이렇게 하면 상태 변경을 감지 못함!
    final count = ref.read(counterProvider);
    return Text('$count');
  }
}

// 올바른 예
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);  // watch 사용!
    return Text('$count');
  }
}
```

### 11.2 onPressed 안에서 ref.watch() 사용

```dart
// 잘못된 예
ElevatedButton(
  onPressed: () {
    // 콜백 안에서 watch 하면 안됨!
    final count = ref.watch(counterProvider);
    print(count);
  },
  child: Text('Click'),
)

// 올바른 예
ElevatedButton(
  onPressed: () {
    final count = ref.read(counterProvider);  // read 사용!
    print(count);
  },
  child: Text('Click'),
)
```

### 11.3 Provider 안에서 상태 변경

```dart
// 잘못된 예
final badProvider = Provider<int>((ref) {
  // Provider 안에서 다른 Provider 상태를 변경하면 안됨!
  ref.read(counterProvider.notifier).state++;
  return 0;
});

// 올바른 예: 초기화가 필요하면 별도 로직으로
```

### 11.4 Family에서 == 와 hashCode 미구현

```dart
// 잘못된 예: 매번 새 객체로 인식되어 캐싱 안됨
class Params {
  final int id;
  final String name;
  Params(this.id, this.name);
  // == 와 hashCode 없음!
}

// 올바른 예
class Params {
  final int id;
  final String name;
  const Params(this.id, this.name);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Params && id == other.id && name == other.name;

  @override
  int get hashCode => Object.hash(id, name);
}
```

### 11.5 비동기 작업 중 상태 업데이트

```dart
// 잘못된 예: dispose 후 상태 업데이트 시도
class MyNotifier extends StateNotifier<MyState> {
  Future<void> loadData() async {
    final data = await api.fetchData();
    state = MyState(data);  // Widget이 이미 dispose 됐으면 에러!
  }
}

// 올바른 예
class MyNotifier extends StateNotifier<MyState> {
  Future<void> loadData() async {
    final data = await api.fetchData();
    if (mounted) {  // mounted 체크!
      state = MyState(data);
    }
  }
}
```

---

## 12. 디버깅 팁

### 12.1 ProviderObserver로 모든 변경 로깅

```dart
class MyObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    print('''
Provider: ${provider.name ?? provider.runtimeType}
Previous: $previousValue
New: $newValue
''');
  }

  @override
  void didAddProvider(
    ProviderBase provider,
    Object? value,
    ProviderContainer container,
  ) {
    print('Provider added: ${provider.name ?? provider.runtimeType}');
  }

  @override
  void didDisposeProvider(
    ProviderBase provider,
    ProviderContainer container,
  ) {
    print('Provider disposed: ${provider.name ?? provider.runtimeType}');
  }
}

// main.dart에서 사용
void main() {
  runApp(
    ProviderScope(
      observers: [MyObserver()],  // 옵저버 추가
      child: MyApp(),
    ),
  );
}
```

### 12.2 Provider에 이름 붙이기

```dart
final counterProvider = StateProvider<int>(
  (ref) => 0,
  name: 'counterProvider',  // 디버깅 시 이름으로 식별
);
```

### 12.3 ref.invalidate()로 강제 새로고침

```dart
// Provider 강제 새로고침
ElevatedButton(
  onPressed: () {
    ref.invalidate(userProvider);  // 데이터 다시 로드
  },
  child: Text('Refresh'),
)
```

### 12.4 ref.refresh()로 새 값 즉시 받기

```dart
// invalidate + 새 값 반환
ElevatedButton(
  onPressed: () async {
    final newUser = await ref.refresh(userProvider.future);
    print('New user: ${newUser.name}');
  },
  child: Text('Refresh'),
)
```

---

## 요약 치트시트

```
Provider 선택:
├── 읽기 전용 → Provider
├── 단순 상태 → StateProvider
├── 복잡한 상태 → StateNotifierProvider / NotifierProvider
├── 비동기 1회 → FutureProvider
└── 실시간 → StreamProvider

ref 메서드:
├── ref.watch() → build 안에서 구독
├── ref.read() → 콜백에서 한 번 읽기
└── ref.listen() → 사이드 이펙트

수식어:
├── .autoDispose → 자동 정리
├── .family → 파라미터 받기
└── .select() → 특정 값만 구독

Widget:
├── ConsumerWidget → 전체가 Provider 사용
├── Consumer → 부분만 Provider 사용
└── ConsumerStatefulWidget → StatefulWidget + Provider
```

---

## 추가 학습 자료

- [Riverpod 공식 문서](https://riverpod.dev)
- [Riverpod GitHub](https://github.com/rrousselGit/riverpod)

궁금한 점이 있으면 언제든 물어보세요!
