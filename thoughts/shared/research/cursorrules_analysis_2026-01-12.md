# Gear Freak 커서룰(.cursorrules) 분석

**날짜**: 2026-01-12
**분석 대상**: gear_freak_flutter 프로젝트의 .cursorrules 파일
**목적**: Poozizic 프로젝트에 적용할 커서룰 스타일 연구

---

## 1. 프로젝트 개요

Gear Freak 프로젝트는 **Flutter 기반의 Clean Architecture**를 엄격하게 따르는 앱으로, 명확한 코드 스타일 가이드와 아키텍처 규칙을 정의하고 있습니다.

### 주요 특징
- Clean Architecture 3-Layer 구조 (Data, Domain, Presentation)
- Riverpod 상태 관리
- Serverpod 백엔드 통신
- 배럴 파일(Barrel File) 패턴 적극 활용
- 공통 위젯 시스템 (Gb prefix)

---

## 2. 디렉토리 구조 규칙

### 2.1 전체 프로젝트 구조

```
lib/
├── main.dart
├── core/                    # 전역 설정
│   ├── route/              # 라우팅
│   ├── util/               # 유틸리티
│   ├── di/                 # 의존성 주입
│   ├── constants/          # 상수
│   └── theme/              # 테마
│
├── shared/                  # 공통 모듈
│   ├── widget/             # 공통 위젯
│   ├── service/            # 공통 서비스
│   ├── domain/             # 공통 도메인
│   └── feature/            # 공통 기능 (예: s3)
│
└── feature/                # Feature별 모듈
    ├── auth/
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    │       ├── page/       # 라우팅 단위
    │       ├── view/       # 상태별 UI
    │       ├── widget/     # 재사용 위젯
    │       ├── provider/   # Provider/Notifier
    │       └── util/       # 유틸리티 함수
    │
    ├── product/
    └── ...
```

### 2.2 디렉토리 명명 규칙

**핵심 원칙: 모든 디렉토리는 단수형**

- ✅ `route/`, `util/`, `widget/`, `service/`, `domain/`, `feature/`, `page/`
- ❌ `routes/`, `utils/`, `widgets/`, `services/`, `domains/`, `features/`, `pages/`
- **예외**: `constants/` (일반적으로 복수형 사용)

---

## 3. Presentation Layer 구조

### 3.1 디렉토리 구성

```
presentation/
├── page/            # Page (라우팅 단위)
│   └── pages.dart   # 배럴 파일
├── view/            # View (상태별 UI)
│   └── view.dart    # 배럴 파일
├── widget/          # Widget (재사용 위젯)
│   └── widget.dart  # 배럴 파일
├── provider/        # Provider/Notifier
│   └── provider.dart # 배럴 파일
├── util/            # Util (유틸리티)
└── presentation.dart # 최상위 배럴 파일
```

### 3.2 구분 기준

- **Page**: 라우팅이 되는 화면 단위 (Route)
  - screen도 허용하지만 page 권장
- **View**: 네트워크 상태에 따른 인터페이스
  - LoadingView, DataView, ErrorView 등
- **Widget**: 재사용 가능한 위젯
  - 특정 화면에서만 사용하는 작은 단위
  - component와 widget 구분하지 않음

### 3.3 예시 코드

```dart
// Page: 라우팅 단위
class ProductDetailPage extends ConsumerStatefulWidget {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(productDetailNotifierProvider);
    return state.when(
      loading: () => ProductDetailLoadingView(),  // View
      data: (data) => ProductDetailView(model: data),  // View
      error: (error) => ProductDetailErrorView(...),  // View
    );
  }
}

// View: 상태별 UI
class ProductDetailLoadingView extends StatelessWidget { ... }
class ProductDetailView extends StatelessWidget { ... }
class ProductDetailErrorView extends StatelessWidget { ... }

// Widget: 재사용 가능한 위젯
class ProductCardWidget extends StatelessWidget { ... }
class ProductBasicInfoSectionWidget extends StatelessWidget { ... }
```

---

## 4. 배럴 파일(Barrel File) 패턴

### 4.1 개념

**모든 presentation 폴더는 배럴 파일을 적극 활용해야 합니다.**

### 4.2 구조

#### 하위 배럴 파일 (각 디렉토리별)

```dart
// presentation/page/pages.dart
export 'buyer_selection_page.dart';
export 'review_list_page.dart';
export 'write_review_page.dart';

// presentation/view/view.dart
export 'buyer_review_list_loaded_view.dart';
export 'seller_review_list_loaded_view.dart';

// presentation/widget/widget.dart
export 'review_item_widget.dart';
export 'review_list_view_widget.dart';

// presentation/provider/provider.dart
export 'review_notifier.dart';
export 'review_state.dart';
export 'review_list_notifier.dart';
export 'review_list_state.dart';
```

#### 최상위 배럴 파일

```dart
// presentation/presentation.dart
/// Gear Freak [Feature Name] Feature Presentation Layer
///
/// [Feature Name] feature의 모든 Presentation Layer 컴포넌트를 export합니다.
library;

export 'page/pages.dart';
export 'provider/provider.dart';
export 'view/view.dart';
export 'widget/widget.dart';
```

### 4.3 Import 규칙

**외부에서 사용할 때:**
```dart
// ✅ 올바른 사용
import 'package:gear_freak_flutter/feature/[feature]/presentation/presentation.dart';

// ❌ 잘못된 사용
import 'package:gear_freak_flutter/feature/[feature]/presentation/page/review_list_page.dart';
```

**Feature 내부에서 사용할 때:**
```dart
// ✅ 권장
import 'package:gear_freak_flutter/feature/[feature]/presentation/presentation.dart';

// ✅ 허용 (하위 배럴 파일 직접 사용)
import 'package:gear_freak_flutter/feature/[feature]/presentation/widget/widget.dart';

// ❌ 가능하면 피함
import 'package:gear_freak_flutter/feature/[feature]/presentation/widget/review_item_widget.dart';
```

### 4.4 배럴 파일 생성 가이드

- 새 파일 추가 시: 해당 디렉토리의 배럴 파일에 export 추가 **필수**
- 파일 삭제 시: 해당 디렉토리의 배럴 파일에서 export 제거 **필수**
- 배럴 파일 네이밍: `pages.dart`, `view.dart`, `widget.dart`, `provider.dart` (단수형)
- library 선언: 각 배럴 파일은 `library;` 선언으로 시작 (문서화 포함 권장)

---

## 5. 공통 위젯 시스템

### 5.1 Gb Prefix 규칙

프로젝트의 모든 공통 위젯은 **Gb(Gear Freak의 약자) prefix**를 사용합니다.

```
shared/widget/
├── gb_dialog.dart
├── gb_snackbar.dart
├── gb_text_form_field.dart
├── gb_error_view.dart
├── gb_empty_view.dart
└── gb_loading_view.dart
```

### 5.2 주요 공통 위젯

#### GbDialog
```dart
// ✅ 올바른 사용
final shouldDelete = await GbDialog.show(
  context: context,
  title: '상품 삭제',
  content: '정말로 이 상품을 삭제하시겠습니까?',
  confirmText: '삭제',
  cancelText: '취소',
  confirmColor: Colors.red,
);

// ❌ 잘못된 사용
showDialog(
  context: context,
  builder: (context) => AlertDialog(...),
);
```

#### GbSnackBar
```dart
// ✅ 올바른 사용 - 4가지 타입
GbSnackBar.showSuccess(context, '상품이 등록되었습니다');
GbSnackBar.showError(context, '상품 삭제에 실패했습니다');
GbSnackBar.showWarning(context, '최소 1장의 이미지를 추가해주세요');
GbSnackBar.showInfo(context, '이미지는 최대 10장까지 추가할 수 있습니다');

// ❌ 잘못된 사용
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('메시지')),
);
```

#### GbErrorView
```dart
// ✅ 올바른 사용
GbErrorView(
  message: '상품을 불러올 수 없습니다',
  onRetry: () {
    ref.read(productNotifierProvider.notifier).loadProducts();
  },
)

// ❌ 잘못된 사용
Center(
  child: Column(
    children: [
      Icon(Icons.error_outline),
      Text('에러 메시지'),
      ElevatedButton(...),
    ],
  ),
)
```

#### GbLoadingView
```dart
// ✅ 올바른 사용
const GbLoadingView()

// 메시지가 있는 경우
const GbLoadingView(message: '데이터를 불러오는 중...')

// ❌ 잘못된 사용
Center(child: CircularProgressIndicator())
```

#### GbEmptyView
```dart
// ✅ 올바른 사용
const GbEmptyView(
  icon: Icons.search,
  message: '상품을 검색해보세요',
)

// ❌ 잘못된 사용
Center(
  child: Column(
    children: [
      Icon(Icons.search),
      Text('상품을 검색해보세요'),
    ],
  ),
)
```

#### GbTextFormField
```dart
// ✅ 기본 스타일 (login, product)
GbTextFormField(
  controller: _emailController,
  labelText: '이메일',
  hintText: 'example@email.com',
  prefixIcon: const Icon(Icons.email_outlined),
  keyboardType: TextInputType.emailAddress,
  validator: (value) => value?.isEmpty ?? true ? '이메일을 입력해주세요' : null,
)

// ✅ Filled 스타일 (signup)
GbTextFormField(
  controller: _nameController,
  hintText: '사용할 닉네임을 입력하세요',
  filled: true, // filled 스타일 활성화
  validator: (value) => value?.isEmpty ?? true ? '닉네임을 입력해주세요' : null,
)

// ❌ 잘못된 사용
TextFormField(
  controller: _emailController,
  decoration: InputDecoration(...),
)
```

---

## 6. State 분기 처리 및 Build 패턴

### 6.1 불필요한 State 분기 처리 금지

같은 View를 사용하는 여러 상태는 `||` 패턴으로 통합해야 합니다.

```dart
// ✅ 올바른 사용 - || 패턴으로 통합
switch (state) {
  ProductPaginatedLoaded(:final products, :final pagination, :final sortBy) ||
  ProductPaginatedLoadingMore(:final products, :final pagination, :final sortBy) =>
    HomeLoadedView(
      products: products,
      pagination: pagination,
      sortBy: sortBy,
      isLoadingMore: state is ProductPaginatedLoadingMore,
    ),
}

// ✅ 올바른 사용 - 부모 클래스만 매칭 (하위 상태 자동 포함)
switch (state) {
  ProfileLoaded(:final user) =>  // ProfileImageUploading, ProfileUpdating 등 포함
    ProfileLoadedView(user: user),
  UpdateProductLoaded() =>  // UpdateProductUploading, UpdateProductUpdating 등 포함
    ProductEditorForm(...),
}

// ❌ 잘못된 사용 - 중복된 분기 처리
switch (state) {
  ProductPaginatedLoaded(...) => HomeLoadedView(...),
  ProductPaginatedLoadingMore(...) => HomeLoadedView(...),  // 중복!
}
```

### 6.2 Build 헬퍼 메서드 사용 금지

`_build` 헬퍼 메서드를 사용하지 말고, **위젯 클래스를 직접 사용**해야 합니다.

**핵심 차이점:**
- `_build` 헬퍼: 매번 새로운 인스턴스 생성, `const` 불가, Element 재사용 불가
- 위젯 직접 사용: `const` 생성자 가능, `key`로 최적화 가능, Element 재사용 가능

```dart
// ✅ 올바른 사용 - 위젯 클래스 직접 사용
switch (state) {
  ProfileLoaded(:final user) =>
    ProfileLoadedView(  // StatelessWidget 직접 사용
      key: const ValueKey('profile_loaded'),  // key로 최적화
      user: user,
      onLogout: _handleLogout,
      onEditProfile: _handleEditProfile,
    ),
}

// ❌ 잘못된 사용 - _build 헬퍼 메서드 사용
switch (state) {
  ProfileLoaded(:final user) => _buildProfileLoadedView(user),
}

Widget _buildProfileLoadedView(User user) {  // ❌ 매번 새 인스턴스 생성
  return ProfileLoadedView(
    user: user,
    onLogout: _handleLogout,
    onEditProfile: _handleEditProfile,
  );
}
```

### 6.3 Switch 문 직접 사용 권장

**Switch 문을 포함하는 헬퍼 메서드도 권장하지 않습니다.** body에서 직접 switch 사용.

```dart
// ✅ 올바른 사용 - body에서 직접 switch 사용 (권장)
@override
Widget build(BuildContext context) {
  final state = ref.watch(someNotifierProvider);

  return Scaffold(
    body: switch (state) {
      Loading() => const GbLoadingView(),
      Error(:final message) => GbErrorView(...),
      Loaded(:final data) => LoadedView(data: data),
    },
  );
}

// ❌ 권장하지 않음 - switch 문을 포함하는 헬퍼 메서드
@override
Widget build(BuildContext context) {
  final state = ref.watch(someNotifierProvider);

  return Scaffold(
    body: _buildBody(state),  // 헬퍼 메서드 사용
  );
}

Widget _buildBody(SomeState state) {
  return switch (state) {  // 허용되지만 권장하지 않음
    Loading() => const GbLoadingView(),
    Error(:final message) => GbErrorView(...),
    Loaded(:final data) => LoadedView(data: data),
  };
}
```

**이유:**
- 프로젝트 전반의 일관성 유지
- 코드 가독성 향상
- 불필요한 메서드 호출 제거

### 6.4 예외 사항

**작은 UI 조각 헬퍼는 허용되지만, StatelessWidget으로 분리 권장**

```dart
// ✅ 권장 - StatelessWidget으로 분리
class InfoItemWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const InfoItemWidget({
    required this.icon,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
    );
  }
}

// ⚠️ 허용되지만 권장하지 않음 - 작은 UI 조각 헬퍼
Widget _buildInfoItem(IconData icon, String label) {
  return ListTile(
    leading: Icon(icon),
    title: Text(label),
  );
}
```

---

## 7. Clean Architecture 패턴

### 7.1 레이어 구조

```
Presentation (Provider/Notifier)
    ↓
Domain (UseCase)
    ↓
Domain (Repository Interface)
    ↑
Data (Repository Implementation)
    ↓
Data (DataSource)
```

### 7.2 Data Layer

#### DataSource
```dart
// ✅ 올바른 DataSource
class ProductRemoteDataSource {
  pod.Client get _client => PodService.instance.client;

  Future<pod.Product> getProductDetail(int id) async {
    try {
      return await _client.product.getProduct(id);
    } catch (e) {
      throw Exception('상품 상세를 불러오는데 실패했습니다: $e');
    }
  }
}

// ❌ 잘못된 사용 - UseCase나 Repository를 DataSource에서 직접 호출
```

#### Repository Implementation
```dart
// ✅ 올바른 Repository Implementation
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  @override
  Future<pod.Product> getProductDetail(int id) async {
    return remoteDataSource.getProductDetail(id);
  }
}
```

### 7.3 Domain Layer

#### Repository Interface
```dart
// ✅ 올바른 Repository Interface
abstract class ProductRepository {
  Future<pod.Product> getProductDetail(int id);
  Future<void> deleteProduct(int productId);
}
```

#### UseCase
```dart
// ✅ 올바른 UseCase
class GetProductDetailUseCase
    implements UseCase<pod.Product, int, ProductRepository> {
  final ProductRepository repository;

  @override
  Future<Either<Failure, pod.Product>> call(int param) async {
    try {
      final result = await repository.getProductDetail(param);
      return Right(result);
    } on Exception catch (e) {
      return Left(GetProductDetailFailure('상품을 불러올 수 없습니다.', exception: e));
    }
  }
}

// ❌ 잘못된 사용 - DataSource를 직접 사용
class GetProductDetailUseCase {
  final ProductRemoteDataSource dataSource; // ❌
}
```

### 7.4 Presentation Layer

#### Notifier
```dart
// ✅ 올바른 Notifier
class ProductDetailNotifier extends StateNotifier<ProductDetailState> {
  final GetProductDetailUseCase getProductDetailUseCase;

  Future<void> loadProductDetail(int productId) async {
    final result = await getProductDetailUseCase(productId);
    result.fold(
      (failure) => state = ProductDetailError(failure.message),
      (product) => state = ProductDetailLoaded(product),
    );
  }
}

// ❌ 잘못된 사용 - Repository나 DataSource 직접 사용
class ProductDetailNotifier {
  final ProductRepository repository; // ❌
  final ProductRemoteDataSource dataSource; // ❌
}
```

### 7.5 의존성 규칙

1. **Presentation → Domain**: Presentation은 Domain(UseCase)만 의존
2. **Data → Domain**: Data는 Domain(Repository Interface)를 구현
3. **Domain → 외부 없음**: Domain은 외부 의존성이 없어야 함
4. **직접 호출 금지**:
   - ❌ Presentation에서 Repository나 DataSource 직접 사용 금지
   - ❌ UseCase에서 DataSource 직접 사용 금지
   - ❌ DataSource에서 다른 DataSource나 UseCase 사용 금지

### 7.6 Provider 설정

```dart
// ✅ 올바른 Provider 구조
final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>((ref) {
  return const ProductRemoteDataSource();
});

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  final remoteDataSource = ref.watch(productRemoteDataSourceProvider);
  return ProductRepositoryImpl(remoteDataSource);
});

final getProductDetailUseCaseProvider = Provider<GetProductDetailUseCase>((ref) {
  final repository = ref.watch(productRepositoryProvider);
  return GetProductDetailUseCase(repository);
});

final productDetailNotifierProvider = StateNotifierProvider<ProductDetailNotifier, ProductDetailState>((ref) {
  final getProductDetailUseCase = ref.watch(getProductDetailUseCaseProvider);
  return ProductDetailNotifier(getProductDetailUseCase);
});
```

---

## 8. Server Layer (Backend) 구조

### 8.1 Service 클래스 함수 순서

```dart
class ProductService {
  // ==================== Public Methods (Endpoint에서 직접 호출) ====================

  /// 상품 생성
  Future<Product> createProduct(...) { ... }

  /// 상품 수정
  Future<Product> updateProduct(...) { ... }

  /// 페이지네이션된 상품 목록 조회
  Future<PaginatedProductsResponseDto> getPaginatedProducts(...) { ... }

  // ==================== Private Helper Methods ====================

  /// 페이지네이션 응답 생성
  PaginatedProductsResponseDto _buildPaginationResponse(...) { ... }

  /// 판매완료 제외 필터링
  List<Product> _filterSoldProducts(...) { ... }
}
```

### 8.2 Notifier 클래스 함수 순서

```dart
class SearchNotifier extends StateNotifier<SearchState> {
  // 생성자, 필드 선언...

  // ==================== Public Methods (UseCase 호출) ====================

  /// 상품 검색 (첫 페이지)
  Future<void> searchProducts(String query, {pod.ProductSortBy? sortBy}) async {
    final result = await searchProductsUseCase(...);
    // ...
  }

  /// 검색 결과 더 불러오기
  Future<void> loadMoreProducts() async {
    final result = await searchProductsUseCase(...);
    // ...
  }

  // ==================== Public Methods (Service 호출) ====================

  /// 최근 검색어 가져오기
  Future<List<String>> getRecentSearches() async {
    return _recentSearchService.getRecentSearches();
  }

  /// 검색 초기화
  Future<void> clearSearch() async {
    await _loadRecentSearches();
  }

  // ==================== Private Helper Methods ====================

  /// 최근 검색어 로드
  Future<void> _loadRecentSearches() async {
    // ...
  }

  /// 목록에서 상품 제거
  void _removeProduct(int productId) {
    // ...
  }
}
```

**순서 규칙:**
1. Public Methods (UseCase 호출)
2. Public Methods (Service 호출)
3. Private Helper Methods

---

## 9. 트러블슈팅 & 개선사항 문서화

### 9.1 문서 위치
- **파일**: `gear_freak_flutter/docs/TROUBLESHOOTING_AND_IMPROVEMENTS.md`

### 9.2 문서화 대상
1. **트러블슈팅**: 버그 해결, 성능 이슈 해결, 메모리 누수 해결
2. **개선사항**: 코드 리팩토링, UI/UX 개선, 아키텍처 개선
3. **잘 짠 코드**: 재사용 가능한 패턴, 우아한 해결 방법
4. **난이도가 있는 작업**: 복잡한 로직 구현, 어려운 문제 해결

### 9.3 문서 작성 형식

```markdown
## N. [제목]

### 📌 개요
- 간단한 설명 (1-2문장)

### ❌ 문제 상황
- 문제가 발생한 배경
- 기존 코드 예시 (나쁜 예)
- 문제점 나열

### ✅ 해결 방법
- 해결 방법 설명
- 개선된 코드 예시 (좋은 예)

### 🔧 구현 세부사항
- 상세 구현 내용
- 코드 예시

### ✅ 장점
- 개선으로 인한 이점들

### ⚠️ 주의사항
- 주의해야 할 점들

### 📍 사용 사례
- 실제 적용된 곳
```

### 9.4 이모지 사용
- 📌 개요
- ❌ 문제 상황
- ✅ 해결 방법 / 장점
- 🔧 구현 세부사항
- ⚠️ 주의사항
- 📍 사용 사례
- 🐛 버그
- 🚀 성능
- 🎨 UI/UX
- 🔒 보안

---

## 10. 핵심 원칙 요약

### 디렉토리
- ✅ 모든 디렉토리는 단수형 (예외: `constants/`)
- ✅ Feature별 독립적인 모듈 구조

### Presentation Layer
- ✅ Page, View, Widget 명확히 구분
- ✅ 배럴 파일 패턴 적극 활용
- ✅ 최상위 `presentation.dart`로 통합 export

### 공통 위젯
- ✅ Gb prefix 사용
- ✅ AlertDialog 대신 GbDialog
- ✅ SnackBar 대신 GbSnackBar
- ✅ ErrorView는 GbErrorView
- ✅ LoadingView는 GbLoadingView
- ✅ EmptyView는 GbEmptyView
- ✅ TextFormField 대신 GbTextFormField

### State 분기
- ✅ `||` 패턴으로 통합
- ✅ 부모 클래스만 매칭 (하위 상태 자동 포함)
- ✅ 위젯 클래스 직접 사용 (const 가능)
- ✅ body에서 직접 switch 사용
- ❌ `_build` 헬퍼 메서드 사용 금지
- ❌ switch 헬퍼 메서드 권장하지 않음

### Clean Architecture
- ✅ Presentation → UseCase만 의존
- ✅ UseCase → Repository Interface만 의존
- ✅ Repository Impl → DataSource만 의존
- ❌ 레이어 건너뛰기 금지

### 함수 순서
- **Service**: Public → Private Helper
- **Notifier**: UseCase 호출 → Service 호출 → Private Helper

### 문서화
- ✅ 트러블슈팅, 개선사항은 반드시 문서화
- ✅ TROUBLESHOOTING_AND_IMPROVEMENTS.md 파일에 기록

---

## 11. Poozizic 프로젝트 적용 가이드

### 현재 Poozizic 구조 분석

Poozizic 프로젝트는 이미 Clean Architecture 구조를 가지고 있습니다:

```
lib/feature/record/
├── data/
│   ├── datasource/
│   │   └── record_local_datasource.dart
│   └── repository/
│       └── record_repository_impl.dart
├── domain/
│   ├── entity/
│   │   └── record_entity.dart
│   ├── failure/
│   │   └── record_failure.dart
│   ├── repository/
│   │   └── record_repository.dart
│   └── usecase/
│       ├── create_record_usecase.dart
│       ├── get_records_by_date_usecase.dart
│       └── get_records_usecase.dart
├── presentation/
│   ├── page/
│   │   └── record_page.dart
│   ├── provider/
│   │   ├── record_form_notifier.dart
│   │   └── record_form_state.dart
│   └── widget/
│       ├── bristol_scale_step.dart
│       ├── feeling_step.dart
│       └── time_step.dart
└── di/
    └── record_providers.dart
```

### 적용 필요 사항

#### 1. 배럴 파일 패턴 적용 (우선순위 높음)
```dart
// lib/feature/record/presentation/page/pages.dart
export 'record_page.dart';

// lib/feature/record/presentation/widget/widget.dart
export 'bristol_scale_step.dart';
export 'feeling_step.dart';
export 'time_step.dart';

// lib/feature/record/presentation/provider/provider.dart
export 'record_form_notifier.dart';
export 'record_form_state.dart';

// lib/feature/record/presentation/presentation.dart
/// Poozizic Record Feature Presentation Layer
library;

export 'page/pages.dart';
export 'provider/provider.dart';
export 'widget/widget.dart';
```

#### 2. 공통 위젯 시스템 구축 (우선순위 중간)
```
lib/shared/widget/
├── pz_dialog.dart
├── pz_snackbar.dart
├── pz_text_form_field.dart
├── pz_error_view.dart
├── pz_empty_view.dart
└── pz_loading_view.dart
```
- Gear Freak의 Gb prefix처럼 Pz(Poozizic) prefix 사용

#### 3. View 레이어 분리 (우선순위 낮음)
현재는 widget에 모두 있지만, 상태별 UI가 명확해지면 view/ 디렉토리 추가

#### 4. 문서화 시스템 구축 (우선순위 높음)
```
docs/TROUBLESHOOTING_AND_IMPROVEMENTS.md
```
트러블슈팅, 개선사항 기록 시작

#### 5. 디렉토리 명명 일관성 확인
- 현재 단수형 사용 중 (✅ 양호)
- `screens/` 디렉토리는 `screen/` 또는 `page/`로 변경 권장

---

## 12. 결론

Gear Freak의 커서룰은 **일관성, 재사용성, 유지보수성**을 최우선으로 하는 철학을 가지고 있습니다.

### 핵심 포인트
1. **배럴 파일 패턴**: Import 경로 통일, 모듈 캡슐화
2. **공통 위젯 시스템**: 코드 재사용, 일관된 UX
3. **Clean Architecture 엄격 준수**: 레이어 책임 명확, 테스트 용이
4. **State 분기 최적화**: 중복 제거, 성능 향상
5. **문서화 습관**: 지식 공유, 컨텍스트 유지

### 적용 우선순위 (Poozizic)
1. **배럴 파일 패턴** (즉시 적용 가능)
2. **문서화 시스템** (즉시 적용 가능)
3. **공통 위젯 시스템** (점진적 적용)
4. **View 레이어 분리** (필요 시 적용)

이 커서룰을 Poozizic 프로젝트에 적용하면 코드 품질과 팀 협업 효율성이 크게 향상될 것입니다.
