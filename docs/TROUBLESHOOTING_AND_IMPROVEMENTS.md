# Poozizic 프로젝트 트러블슈팅 & 개선사항

이 문서는 Poozizic 프로젝트에서 발생한 트러블슈팅, 개선사항, 잘 짠 코드를 기록합니다.

---

## 1. 공통 위젯 시스템 구축 (2026-01-12)

### 📌 개요
프로젝트 전반에서 일관된 UI/UX를 제공하기 위해 Pz prefix를 사용하는 공통 위젯 시스템을 구축했습니다.

### ✅ 구현 내용

#### 구축된 공통 위젯
1. **PzDialog** (`lib/shared/widget/pz_dialog.dart`)
   - AlertDialog를 대체하는 공통 다이얼로그
   - 확인/취소 버튼 커스터마이징 가능
   - 일관된 스타일 제공

2. **PzSnackBar** (`lib/shared/widget/pz_snackbar.dart`)
   - 4가지 타입: success, error, warning, info
   - 자동 아이콘 및 색상 적용
   - Floating 스타일로 현대적인 디자인

3. **PzErrorView** (`lib/shared/widget/pz_error_view.dart`)
   - 에러 상태 표시용 전체 화면 위젯
   - 다시 시도 버튼 및 뒤로 가기 버튼 지원
   - 커스텀 아이콘 및 색상 지원

4. **PzLoadingView** (`lib/shared/widget/pz_loading_view.dart`)
   - 로딩 상태 표시용 전체 화면 위젯
   - 선택적 메시지 표시 가능
   - 간단하고 명확한 UX

5. **PzEmptyView** (`lib/shared/widget/pz_empty_view.dart`)
   - 빈 상태 표시용 위젯
   - 선택적 아이콘 및 메시지
   - 깔끔한 디자인

6. **PzTextFormField** (`lib/shared/widget/pz_text_form_field.dart`)
   - TextFormField를 대체하는 공통 입력 필드
   - 기본 스타일과 Filled 스타일 지원
   - 일관된 border radius 및 색상

### 🔧 구현 세부사항

**파일 위치**: `lib/shared/widget/`

**네이밍 규칙**:
- 모든 공통 위젯은 `Pz` prefix 사용 (Poozizic의 약자)
- PascalCase로 클래스명 정의
- 파일명은 snake_case

**스타일 가이드**:
- Material Design 3 기반
- border radius: 12px (일관성)
- 색상: Theme.of(context) 활용
- 텍스트 크기: 14-20px 범위

### ✅ 장점

1. **코드 재사용성**: 동일한 UI 컴포넌트를 여러 곳에서 재사용
2. **일관성**: 프로젝트 전반에 걸쳐 일관된 디자인
3. **유지보수성**: 한 곳에서 스타일 변경 시 전체 반영
4. **개발 속도 향상**: 반복 코드 작성 불필요

### ⚠️ 주의사항

1. **네이티브 위젯 사용 금지**:
   - ❌ `showDialog` → ✅ `PzDialog.show`
   - ❌ `ScaffoldMessenger.showSnackBar` → ✅ `PzSnackBar.show`
   - ❌ `TextFormField` → ✅ `PzTextFormField`

2. **const 생성자**:
   - 동적 값을 받는 위젯은 const 사용 불가
   - 가능한 경우 const 생성자 사용 권장

3. **커스터마이징**:
   - 기본 스타일로 충분하지 않은 경우 파라미터로 커스터마이징
   - 공통 위젯 직접 수정은 신중히 결정

### 📍 사용 사례

```dart
// PzDialog 사용 예시
final result = await PzDialog.show(
  context: context,
  title: '기록 삭제',
  content: '정말로 이 기록을 삭제하시겠습니까?',
  confirmText: '삭제',
  cancelText: '취소',
  confirmColor: Colors.red,
);

// PzSnackBar 사용 예시
PzSnackBar.showSuccess(context, '기록이 저장되었습니다');
PzSnackBar.showError(context, '기록 저장에 실패했습니다');

// PzErrorView 사용 예시
return PzErrorView(
  message: '데이터를 불러올 수 없습니다',
  onRetry: () => ref.read(recordNotifierProvider.notifier).loadRecords(),
);
```

---

## 2. 배럴 파일 패턴 적용 (2026-01-12)

### 📌 개요
Clean Architecture의 Presentation Layer에 배럴 파일 패턴을 적용하여 Import 경로를 통일하고 모듈 캡슐화를 강화했습니다.

### ❌ 문제 상황

**개별 파일 직접 import로 인한 문제점:**
```dart
// 여러 파일을 개별적으로 import
import 'package:poozizic/feature/record/presentation/page/record_page.dart';
import 'package:poozizic/feature/record/presentation/widget/bristol_scale_step.dart';
import 'package:poozizic/feature/record/presentation/widget/feeling_step.dart';
import 'package:poozizic/feature/record/presentation/provider/record_form_notifier.dart';
```

- Import 경로가 길고 복잡함
- 파일 구조 변경 시 모든 import 수정 필요
- 내부 구현이 외부에 노출됨
- 모듈 경계가 명확하지 않음

### ✅ 해결 방법

**배럴 파일 패턴 도입:**
```dart
// 하나의 배럴 파일만 import
import 'package:poozizic/feature/record/presentation/presentation.dart';
```

### 🔧 구현 세부사항

#### 디렉토리 구조
```
presentation/
├── page/
│   ├── record_page.dart
│   └── pages.dart           # 배럴 파일
├── widget/
│   ├── bristol_scale_step.dart
│   ├── feeling_step.dart
│   ├── time_step.dart
│   └── widget.dart          # 배럴 파일
├── provider/
│   ├── record_form_notifier.dart
│   ├── record_form_state.dart
│   └── provider.dart        # 배럴 파일
└── presentation.dart        # 최상위 배럴 파일
```

#### 배럴 파일 예시

**하위 배럴 파일** (`page/pages.dart`):
```dart
/// Poozizic Record Feature Pages
library;

export 'record_page.dart';
```

**최상위 배럴 파일** (`presentation.dart`):
```dart
/// Poozizic Record Feature Presentation Layer
///
/// Record feature의 모든 Presentation Layer 컴포넌트를 export합니다.
library;

export 'page/pages.dart';
export 'provider/provider.dart';
export 'widget/widget.dart';
```

#### 적용된 Feature
1. Record Feature (배변 기록)
2. Calendar Feature (캘린더)
3. Settings Feature (설정)

### ✅ 장점

1. **Import 경로 단순화**: 하나의 파일만 import
2. **모듈 캡슐화**: 내부 구조 변경 시 외부 코드 영향 없음
3. **유지보수성 향상**: 파일 이동/이름 변경 시 배럴 파일만 수정
4. **명확한 모듈 경계**: Feature별 독립성 강화
5. **일관된 Import 스타일**: 프로젝트 전반에 걸쳐 일관성 유지

### ⚠️ 주의사항

1. **배럴 파일 관리**:
   - 새 파일 추가 시: 해당 디렉토리의 배럴 파일에 export 추가 필수
   - 파일 삭제 시: 해당 디렉토리의 배럴 파일에서 export 제거 필수

2. **순환 참조 방지**:
   - 배럴 파일끼리 import하지 않도록 주의
   - 각 배럴 파일은 자신의 디렉토리 내부 파일만 export

3. **library 선언**:
   - 각 배럴 파일은 `library;` 선언으로 시작
   - 문서화 주석 포함 권장

### 📍 사용 사례

```dart
// main.dart에서 사용
import 'package:poozizic/feature/record/presentation/presentation.dart';
import 'package:poozizic/feature/calendar/presentation/presentation.dart';
import 'package:poozizic/feature/settings/presentation/presentation.dart';

// Feature 내부에서 사용 (하위 배럴 파일 직접 사용 가능)
import 'package:poozizic/feature/record/presentation/widget/widget.dart';
```

---

## 3. 공통 위젯 적용 및 코드 개선 (2026-01-12)

### 📌 개요
프로젝트 전반에 걸쳐 공통 위젯을 적용하고, Notifier 함수 순서를 정리하여 코드 일관성과 가독성을 향상시켰습니다.

### ❌ 문제 상황

**기존 코드의 문제점:**

1. **네이티브 위젯 직접 사용**:
```dart
// showDialog 직접 사용
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    shape: RoundedRectangleBorder(...),
    title: Text(...),
    content: Text(...),
    actions: [...],
  ),
);

// ScaffoldMessenger 직접 사용
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('메시지'),
    backgroundColor: Color(0xFF4CAF50),
    behavior: SnackBarBehavior.floating,
    margin: EdgeInsets.only(...),
  ),
);
```

2. **함수 순서 불일치**:
```dart
class CalendarNotifier extends StateNotifier<CalendarState> {
  // Private Helper가 먼저 정의됨
  DateTime _normalizeDate(DateTime date) { ... }
  Future<void> _init() async { ... }

  // Public Methods가 나중에 정의됨
  Future<void> loadMonth(DateTime month) async { ... }
}
```

### ✅ 해결 방법

**1. 공통 위젯으로 교체:**
```dart
// PzDialog 사용
final result = await PzDialog.show(
  context: context,
  title: '데이터 내보내기',
  content: '모든 기록을 CSV 파일로 내보내시겠습니까?',
  confirmText: '확인',
  cancelText: '취소',
);

// PzSnackBar 사용
PzSnackBar.showSuccess(context, '기록이 저장되었습니다');
PzSnackBar.showError(context, '기록 저장에 실패했습니다');

// PzLoadingView 사용
return switch (state) {
  SettingsInitial() => const PzLoadingView(),
  SettingsLoading() => const PzLoadingView(),
  // ...
};

// PzErrorView 사용
return switch (state) {
  SettingsError(:final message) => PzErrorView(
      message: message,
      onRetry: () => notifier.loadSettings(),
    ),
  // ...
};
```

**2. Notifier 함수 순서 정리:**
```dart
class CalendarNotifier extends StateNotifier<CalendarState> {
  final CalendarRepository _repository;

  // ==================== Public Methods (UseCase 호출) ====================

  Future<void> loadMonth(DateTime month) async { ... }
  Future<void> selectDay(DateTime day) async { ... }
  Future<void> changeMonth(DateTime newMonth) async { ... }
  Future<void> refresh() async { ... }

  // ==================== Private Helper Methods ====================

  Future<void> _init() async { ... }
  DateTime _normalizeDate(DateTime date) { ... }
}
```

### 🔧 구현 세부사항

#### 수정된 파일 목록
1. `lib/feature/settings/presentation/page/settings_page.dart`
   - showDialog → PzDialog.show
   - ScaffoldMessenger → PzSnackBar
   - CircularProgressIndicator → PzLoadingView
   - 에러 화면 → PzErrorView
   - BuildContext async 문제 수정

2. `lib/feature/record/presentation/page/record_page.dart`
   - ScaffoldMessenger → PzSnackBar
   - CircularProgressIndicator → PzLoadingView

3. `lib/feature/calendar/presentation/page/calendar_page.dart`
   - CircularProgressIndicator → PzLoadingView
   - 에러 화면 → PzErrorView

4. `lib/feature/water/presentation/page/water_record_page.dart`
   - ScaffoldMessenger → PzSnackBar

5. `lib/feature/meal/presentation/page/meal_record_page.dart`
   - ScaffoldMessenger → PzSnackBar

6. `lib/feature/exercise/presentation/page/exercise_record_page.dart`
   - ScaffoldMessenger → PzSnackBar

7. `lib/feature/calendar/presentation/provider/calendar_notifier.dart`
   - 함수 순서 정리 (Public Methods → Private Helper Methods)

8. `lib/feature/settings/presentation/provider/settings_notifier.dart`
   - 함수 순서 정리 (Public Methods → Private Helper Methods)

#### BuildContext 사용 문제 해결
```dart
// ❌ 잘못된 사용
void _showConfirmDialog(...) async {
  final result = await PzDialog.show(...);
  if (result == true && context.mounted) {  // ⚠️ context 사용 경고
    PzSnackBar.showSuccess(context, '완료');
  }
}

// ✅ 올바른 사용
Future<void> _showConfirmDialog(...) async {
  if (!mounted) return;  // 먼저 체크

  final result = await PzDialog.show(...);

  if (mounted && result == true) {  // mounted 체크
    PzSnackBar.showSuccess(context, '완료');
  }
}
```

### ✅ 장점

1. **코드 일관성**: 모든 페이지에서 동일한 UI 컴포넌트 사용
2. **코드 간결성**: 반복 코드 제거, 가독성 향상
3. **유지보수성**: 한 곳에서 스타일 변경 시 전체 반영
4. **버그 방지**: BuildContext async 문제 해결
5. **가독성 향상**: Notifier 함수 순서 일관성

### ⚠️ 주의사항

1. **mounted 체크**:
   - async 함수에서 BuildContext 사용 전 반드시 `mounted` 체크
   - `if (!mounted) return;` 패턴 사용

2. **일관성 유지**:
   - 새로운 페이지 작성 시 공통 위젯 사용 필수
   - Notifier 작성 시 함수 순서 규칙 준수

3. **예외 처리**:
   - 버튼 내부의 작은 CircularProgressIndicator는 그대로 유지 (UX 고려)

### 📍 사용 사례

**프로젝트 전반에 적용됨:**
- Settings 페이지: 다이얼로그, 스낵바, 로딩/에러 뷰
- Calendar 페이지: 로딩/에러 뷰
- Record 페이지: 스낵바, 로딩 뷰
- Water/Meal/Exercise 페이지: 스낵바

---

## 4. .cursorrules 파일 생성 및 문서화 완료 (2026-01-12)

### 📌 개요
프로젝트 전반의 코딩 규칙과 아키텍처 패턴을 정의한 `.cursorrules` 파일을 생성하고, 모든 개선사항을 문서화했습니다.

### ✅ 구현 내용

#### .cursorrules 파일 구성
1. **프로젝트 개요**: Poozizic 앱의 목적과 기술 스택
2. **디렉토리 구조 규칙**: 전체 구조 및 Feature 내부 구조
3. **Presentation Layer 구조 규칙**: Page/View/Widget 구분, 배럴 파일 패턴
4. **공통 위젯 사용 규칙**: Pz prefix 위젯 사용법
5. **State 분기 처리 규칙**: || 패턴, Build 헬퍼 금지
6. **Clean Architecture 패턴**: 레이어 구조 및 의존성 규칙
7. **Notifier 함수 순서 규칙**: Public Methods → Private Helper Methods
8. **문서화 규칙**: TROUBLESHOOTING_AND_IMPROVEMENTS.md 작성법
9. **핵심 원칙 요약**: 빠른 참조용 체크리스트
10. **프로젝트 특화 규칙**: 건강 기록 데이터, UI/UX, 성능 최적화

### 🔧 구현 세부사항

**파일 위치**: 프로젝트 루트 `.cursorrules`

**주요 내용:**

1. **디렉토리 명명 규칙**:
   - ✅ 모든 디렉토리는 단수형
   - Feature별 독립적인 모듈 구조

2. **배럴 파일 패턴**:
   - presentation.dart (최상위)
   - pages.dart, widget.dart, provider.dart (하위)
   - library 선언 및 문서화

3. **공통 위젯 Pz Prefix**:
   - PzDialog, PzSnackBar, PzErrorView, PzLoadingView, PzEmptyView, PzTextFormField

4. **State 분기**:
   - || 패턴으로 통합
   - 위젯 클래스 직접 사용
   - _build 헬퍼 메서드 금지

5. **Clean Architecture**:
   - Presentation → UseCase만 의존
   - 레이어 건너뛰기 금지

6. **프로젝트 특화**:
   - 건강 기록 데이터 처리 규칙
   - UI/UX 색상 팔레트
   - 성능 최적화 가이드

### ✅ 장점

1. **팀 협업 향상**: 명확한 코딩 규칙으로 일관성 유지
2. **신규 개발자 온보딩**: 빠른 프로젝트 구조 이해
3. **코드 리뷰 효율**: 규칙 기반 리뷰 가능
4. **유지보수성**: 장기적인 코드 품질 유지
5. **지식 공유**: 프로젝트 노하우 문서화

### ⚠️ 주의사항

1. **규칙 업데이트**:
   - 새로운 패턴 도입 시 .cursorrules 업데이트 필수
   - 팀원들과 합의 후 변경

2. **문서 동기화**:
   - .cursorrules와 TROUBLESHOOTING_AND_IMPROVEMENTS.md 일관성 유지
   - 중요한 개선사항은 양쪽 모두 기록

3. **점진적 적용**:
   - 기존 코드는 점진적으로 규칙 적용
   - 새로운 코드부터 엄격히 준수

### 📍 사용 사례

**개발자 참조 시나리오:**
1. 새 Feature 추가 시: 디렉토리 구조 규칙 참조
2. 공통 위젯 사용 시: 사용법 및 예제 코드 참조
3. Notifier 작성 시: 함수 순서 규칙 참조
4. 코드 리뷰 시: 규칙 준수 여부 체크
5. 트러블슈팅 시: 문서화 형식 참조

---

## 향후 추가 예정

이후 트러블슈팅, 개선사항, 잘 짠 코드는 이 문서에 계속 추가됩니다.

**작성 형식**:
- 📌 개요
- ❌ 문제 상황 (해당하는 경우)
- ✅ 해결 방법 또는 구현 내용
- 🔧 구현 세부사항
- ✅ 장점
- ⚠️ 주의사항
- 📍 사용 사례
