# Poozizic 프로젝트 커서룰 스타일 적용 구현 계획

**날짜**: 2026-01-12
**작성자**: Claude
**관련 연구 문서**: `thoughts/shared/research/cursorrules_analysis_2026-01-12.md`

---

## 1. 요구사항

### 기능 개요
Gear Freak 프로젝트의 커서룰(.cursorrules) 스타일을 Poozizic 프로젝트에 적용하여, 코드 품질, 일관성, 유지보수성을 향상시킵니다.

### 목표
- 배럴 파일 패턴 도입으로 Import 경로 통일
- 공통 위젯 시스템 구축 (Pz prefix)
- 디렉토리 구조 일관성 확보
- 문서화 시스템 구축
- Clean Architecture 패턴 엄격 준수

### 성공 기준
- [ ] 모든 feature의 presentation 레이어에 배럴 파일 적용
- [ ] 6개의 공통 위젯(Pz prefix) 구현 완료
- [ ] `screens/` 디렉토리를 feature 구조로 마이그레이션
- [ ] 문서화 시스템 구축 (TROUBLESHOOTING_AND_IMPROVEMENTS.md)
- [ ] .cursorrules 파일 생성
- [ ] 빌드 및 테스트 성공

---

## 2. 기술적 접근

### 아키텍처 선택
- **기존**: Clean Architecture (유지)
- **개선**: Gear Freak 스타일의 엄격한 레이어 분리 및 배럴 파일 패턴

### 사용할 패키지
- 기존 패키지 유지 (flutter_riverpod, dartz, intl, table_calendar, fl_chart)
- 추가 패키지 없음

### 주요 변경 사항

#### 1. 배럴 파일 패턴
```
lib/feature/[feature]/presentation/
├── page/
│   ├── [feature]_page.dart
│   └── pages.dart          # 배럴 파일 (새로 생성)
├── view/                   # 필요시 생성
│   └── view.dart           # 배럴 파일
├── widget/
│   ├── [widgets].dart
│   └── widget.dart         # 배럴 파일 (새로 생성)
├── provider/
│   ├── [notifiers].dart
│   └── provider.dart       # 배럴 파일 (새로 생성)
└── presentation.dart       # 최상위 배럴 파일 (새로 생성)
```

#### 2. 공통 위젯 시스템 (Pz prefix)
```
lib/shared/widget/
├── pz_dialog.dart         # 새로 생성
├── pz_snackbar.dart       # 새로 생성
├── pz_error_view.dart     # 새로 생성
├── pz_loading_view.dart   # 새로 생성
├── pz_empty_view.dart     # 새로 생성
└── pz_text_form_field.dart # 새로 생성
```

#### 3. 디렉토리 구조 개선
```
lib/
├── main.dart
├── core/                   # 새로 생성 (screens/ 마이그레이션)
│   ├── route/
│   ├── theme/
│   └── constants/
├── shared/
│   ├── widget/            # 공통 위젯 추가
│   └── domain/            # 기존 유지
└── feature/               # 기존 유지 + 개선
    ├── record/
    ├── calendar/
    ├── settings/
    ├── home/              # screens/home_screen.dart 마이그레이션
    ├── analytics/         # screens/analytics_screen.dart 마이그레이션
    ├── meal/              # screens/meal_record_screen.dart 마이그레이션
    ├── water/             # screens/water_record_screen.dart 마이그레이션
    └── exercise/          # screens/exercise_record_screen.dart 마이그레이션
```

---

## 3. 구현 단계

### Phase 1: 기반 작업 및 공통 위젯 시스템 구축
**목표**: 공통 위젯 시스템 구축 및 문서화 준비

**작업 목록**:
- [ ] `lib/shared/widget/` 디렉토리 생성
- [ ] `pz_dialog.dart` 구현 (GbDialog 참고)
- [ ] `pz_snackbar.dart` 구현 (GbSnackBar 참고)
- [ ] `pz_error_view.dart` 구현 (GbErrorView 참고)
- [ ] `pz_loading_view.dart` 구현 (GbLoadingView 참고)
- [ ] `pz_empty_view.dart` 구현 (GbEmptyView 참고)
- [ ] `pz_text_form_field.dart` 구현 (GbTextFormField 참고)
- [ ] `docs/` 디렉토리 생성
- [ ] `docs/TROUBLESHOOTING_AND_IMPROVEMENTS.md` 생성

**예상 영향**:
- 영향 받는 파일: 없음 (신규 생성)
- 의존성: 없음

**검증 방법**:
- [ ] 각 공통 위젯 단독 빌드 성공
- [ ] Hot reload 정상 동작
- [ ] 위젯 UI 렌더링 확인

**Phase 1 체크리스트**:
- [ ] `lib/shared/widget/` 디렉토리 생성 완료
- [ ] 6개 공통 위젯 파일 생성 완료
- [ ] 각 위젯 클래스 정의 완료
- [ ] PzDialog.show() 정상 동작 (다이얼로그 표시, 버튼 동작)
- [ ] PzSnackBar 4가지 타입 모두 정상 동작
- [ ] PzErrorView 렌더링 및 버튼 동작 확인
- [ ] PzLoadingView 렌더링 확인
- [ ] PzEmptyView 아이콘 및 메시지 표시 확인
- [ ] PzTextFormField 입력 및 유효성 검사 동작 확인
- [ ] `docs/` 디렉토리 및 `TROUBLESHOOTING_AND_IMPROVEMENTS.md` 생성 완료
- [ ] 빌드 오류 없음
- [ ] Hot reload 정상

**상세 작업**:

1. **PzDialog 구현**
   ```dart
   // lib/shared/widget/pz_dialog.dart
   class PzDialog {
     static Future<bool?> show({
       required BuildContext context,
       required String title,
       required String content,
       String confirmText = '확인',
       String cancelText = '취소',
       Color? confirmColor,
     }) async {
       return showDialog<bool>(
         context: context,
         builder: (context) => AlertDialog(
           title: Text(title),
           content: Text(content),
           actions: [
             TextButton(
               onPressed: () => Navigator.pop(context, false),
               child: Text(cancelText),
             ),
             TextButton(
               onPressed: () => Navigator.pop(context, true),
               style: TextButton.styleFrom(
                 foregroundColor: confirmColor,
               ),
               child: Text(confirmText),
             ),
           ],
         ),
       );
     }
   }
   ```

2. **PzSnackBar 구현**
   ```dart
   // lib/shared/widget/pz_snackbar.dart
   enum PzSnackBarType { success, error, warning, info }

   class PzSnackBar {
     static void show(
       BuildContext context,
       String message, {
       PzSnackBarType type = PzSnackBarType.info,
       Duration duration = const Duration(seconds: 2),
     }) {
       // 구현
     }

     static void showSuccess(BuildContext context, String message) =>
         show(context, message, type: PzSnackBarType.success);

     static void showError(BuildContext context, String message) =>
         show(context, message, type: PzSnackBarType.error, duration: const Duration(seconds: 3));

     static void showWarning(BuildContext context, String message) =>
         show(context, message, type: PzSnackBarType.warning);

     static void showInfo(BuildContext context, String message) =>
         show(context, message, type: PzSnackBarType.info);
   }
   ```

3. **PzErrorView 구현**
   ```dart
   // lib/shared/widget/pz_error_view.dart
   class PzErrorView extends StatelessWidget {
     final String message;
     final VoidCallback onRetry;
     final String? title;
     final bool showBackButton;
     final VoidCallback? onBack;

     const PzErrorView({
       required this.message,
       required this.onRetry,
       this.title,
       this.showBackButton = false,
       this.onBack,
       super.key,
     });

     @override
     Widget build(BuildContext context) {
       return Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             if (title != null) ...[
               Text(title!, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
               const SizedBox(height: 8),
             ],
             Icon(Icons.error_outline, size: 64, color: Colors.red),
             const SizedBox(height: 16),
             Text(message, style: TextStyle(fontSize: 16, color: Colors.red)),
             const SizedBox(height: 24),
             ElevatedButton(
               onPressed: onRetry,
               child: Text('다시 시도'),
             ),
             if (showBackButton && onBack != null) ...[
               const SizedBox(height: 12),
               TextButton(
                 onPressed: onBack,
                 child: Text('뒤로 가기'),
               ),
             ],
           ],
         ),
       );
     }
   }
   ```

4. **PzLoadingView 구현**
   ```dart
   // lib/shared/widget/pz_loading_view.dart
   class PzLoadingView extends StatelessWidget {
     final String? message;

     const PzLoadingView({this.message, super.key});

     @override
     Widget build(BuildContext context) {
       return Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             CircularProgressIndicator(),
             if (message != null) ...[
               const SizedBox(height: 16),
               Text(message!),
             ],
           ],
         ),
       );
     }
   }
   ```

5. **PzEmptyView 구현**
   ```dart
   // lib/shared/widget/pz_empty_view.dart
   class PzEmptyView extends StatelessWidget {
     final String message;
     final IconData? icon;
     final double iconSize;
     final Color iconColor;

     const PzEmptyView({
       required this.message,
       this.icon,
       this.iconSize = 64,
       this.iconColor = const Color(0xFFE0E0E0),
       super.key,
     });

     @override
     Widget build(BuildContext context) {
       return Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             if (icon != null) ...[
               Icon(icon, size: iconSize, color: iconColor),
               const SizedBox(height: 16),
             ],
             Text(
               message,
               style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
             ),
           ],
         ),
       );
     }
   }
   ```

6. **PzTextFormField 구현**
   ```dart
   // lib/shared/widget/pz_text_form_field.dart
   class PzTextFormField extends StatelessWidget {
     final TextEditingController? controller;
     final String? labelText;
     final String? hintText;
     final Widget? prefixIcon;
     final Widget? suffixIcon;
     final TextInputType? keyboardType;
     final bool obscureText;
     final int maxLines;
     final String? Function(String?)? validator;
     final bool filled;

     const PzTextFormField({
       this.controller,
       this.labelText,
       this.hintText,
       this.prefixIcon,
       this.suffixIcon,
       this.keyboardType,
       this.obscureText = false,
       this.maxLines = 1,
       this.validator,
       this.filled = false,
       super.key,
     });

     @override
     Widget build(BuildContext context) {
       return TextFormField(
         controller: controller,
         keyboardType: keyboardType,
         obscureText: obscureText,
         maxLines: maxLines,
         validator: validator,
         decoration: InputDecoration(
           labelText: labelText,
           hintText: hintText,
           prefixIcon: prefixIcon,
           suffixIcon: suffixIcon,
           filled: filled,
           fillColor: filled ? Colors.grey[100] : null,
           border: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
           ),
           enabledBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide(color: Colors.grey[300]!),
           ),
           focusedBorder: OutlineInputBorder(
             borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide(color: Theme.of(context).primaryColor),
           ),
         ),
       );
     }
   }
   ```

---

### Phase 2: 기존 Feature에 배럴 파일 패턴 적용
**목표**: record, calendar, settings feature에 배럴 파일 적용

**작업 목록**:

#### 2.1 Record Feature
- [ ] `lib/feature/record/presentation/page/pages.dart` 생성
  ```dart
  /// Poozizic Record Feature Pages
  library;

  export 'record_page.dart';
  ```

- [ ] `lib/feature/record/presentation/widget/widget.dart` 생성
  ```dart
  /// Poozizic Record Feature Widgets
  library;

  export 'bristol_scale_step.dart';
  export 'feeling_step.dart';
  export 'time_step.dart';
  ```

- [ ] `lib/feature/record/presentation/provider/provider.dart` 생성
  ```dart
  /// Poozizic Record Feature Providers
  library;

  export 'record_form_notifier.dart';
  export 'record_form_state.dart';
  ```

- [ ] `lib/feature/record/presentation/presentation.dart` 생성 (최상위 배럴 파일)
  ```dart
  /// Poozizic Record Feature Presentation Layer
  ///
  /// Record feature의 모든 Presentation Layer 컴포넌트를 export합니다.
  library;

  export 'page/pages.dart';
  export 'provider/provider.dart';
  export 'widget/widget.dart';
  ```

#### 2.2 Calendar Feature
- [ ] `lib/feature/calendar/presentation/page/pages.dart` 생성
- [ ] `lib/feature/calendar/presentation/widget/widget.dart` 생성
- [ ] `lib/feature/calendar/presentation/provider/provider.dart` 생성
- [ ] `lib/feature/calendar/presentation/presentation.dart` 생성

#### 2.3 Settings Feature
- [ ] `lib/feature/settings/presentation/page/pages.dart` 생성
- [ ] `lib/feature/settings/presentation/widget/widget.dart` 생성
- [ ] `lib/feature/settings/presentation/provider/provider.dart` 생성
- [ ] `lib/feature/settings/presentation/presentation.dart` 생성

#### 2.4 Import 경로 리팩토링
- [ ] `main.dart`의 import 문을 배럴 파일로 변경
  ```dart
  // Before
  import 'feature/calendar/presentation/page/calendar_page.dart';
  import 'feature/record/presentation/page/record_page.dart';
  import 'feature/settings/presentation/page/settings_page.dart';

  // After
  import 'feature/calendar/presentation/presentation.dart';
  import 'feature/record/presentation/presentation.dart';
  import 'feature/settings/presentation/presentation.dart';
  ```

**예상 영향**:
- 영향 받는 파일: `main.dart`, feature 내부 import 문
- 의존성: Phase 1 완료 필요 (공통 위젯 사용 가능)

**검증 방법**:
- [ ] 빌드 성공
- [ ] Hot reload 정상 동작
- [ ] 모든 화면 정상 렌더링
- [ ] Import 에러 없음

**Phase 2 체크리스트**:
- [ ] Record feature 배럴 파일 4개 생성 (pages.dart, widget.dart, provider.dart, presentation.dart)
- [ ] Calendar feature 배럴 파일 4개 생성
- [ ] Settings feature 배럴 파일 4개 생성
- [ ] 각 배럴 파일에 library 선언 및 export 문 작성
- [ ] main.dart import 경로 변경 완료
- [ ] Feature 내부 import 경로 점검
- [ ] 빌드 오류 없음
- [ ] 모든 페이지 정상 렌더링 (홈, 캘린더, 레코드, 설정)
- [ ] 네비게이션 정상 동작

---

### Phase 3: screens/ 디렉토리 마이그레이션
**목표**: screens/ 디렉토리의 파일들을 feature 구조로 마이그레이션

**작업 목록**:

#### 3.1 Home Feature 생성
- [ ] `lib/feature/home/` 디렉토리 생성
- [ ] `lib/feature/home/presentation/page/` 디렉토리 생성
- [ ] `screens/home_screen.dart` → `feature/home/presentation/page/home_page.dart` 이동
- [ ] `feature/home/presentation/page/pages.dart` 배럴 파일 생성
- [ ] `feature/home/presentation/presentation.dart` 최상위 배럴 파일 생성

#### 3.2 Analytics Feature 생성
- [ ] `lib/feature/analytics/` 디렉토리 생성
- [ ] `screens/analytics_screen.dart` → `feature/analytics/presentation/page/analytics_page.dart` 이동
- [ ] 배럴 파일 생성

#### 3.3 Meal Feature 생성
- [ ] `lib/feature/meal/` 디렉토리 생성
- [ ] `screens/meal_record_screen.dart` → `feature/meal/presentation/page/meal_record_page.dart` 이동
- [ ] 배럴 파일 생성

#### 3.4 Water Feature 생성
- [ ] `lib/feature/water/` 디렉토리 생성
- [ ] `screens/water_record_screen.dart` → `feature/water/presentation/page/water_record_page.dart` 이동
- [ ] 배럴 파일 생성

#### 3.5 Exercise Feature 생성
- [ ] `lib/feature/exercise/` 디렉토리 생성
- [ ] `screens/exercise_record_screen.dart` → `feature/exercise/presentation/page/exercise_record_page.dart` 이동
- [ ] 배럴 파일 생성

#### 3.6 main.dart 리팩토링
- [ ] 새로운 feature import 경로로 변경
- [ ] `screens/` 디렉토리 제거

**예상 영향**:
- 영향 받는 파일: `main.dart`, 모든 마이그레이션된 파일
- 의존성: Phase 2 완료 필요

**검증 방법**:
- [ ] 빌드 성공
- [ ] 모든 화면 정상 동작
- [ ] 네비게이션 정상 동작
- [ ] Hot reload 정상 동작

**주의사항**:
- 기존 `screens/` 파일들은 단순 UI만 있으므로, data/domain 레이어는 생성하지 않음
- 향후 필요시 Clean Architecture 구조 추가 가능

---

### Phase 4: 공통 위젯 적용 및 코드 개선
**목표**: 기존 코드에 공통 위젯 적용 및 커서룰 스타일 반영

**작업 목록**:

#### 4.1 공통 위젯 적용
- [ ] 프로젝트 전체에서 `showDialog` → `PzDialog.show` 변경
- [ ] 프로젝트 전체에서 `ScaffoldMessenger.showSnackBar` → `PzSnackBar` 변경
- [ ] 프로젝트 전체에서 `Center(child: CircularProgressIndicator())` → `PzLoadingView` 변경
- [ ] 프로젝트 전체에서 `TextFormField` → `PzTextFormField` 변경 (필요시)
- [ ] 에러 상태 표시를 `PzErrorView`로 변경
- [ ] 빈 상태 표시를 `PzEmptyView`로 변경

#### 4.2 Notifier 함수 순서 정리
- [ ] `record_form_notifier.dart` 함수 순서 정리
  - Public Methods (UseCase 호출)
  - Private Helper Methods
- [ ] `calendar_notifier.dart` 함수 순서 정리
- [ ] `settings_notifier.dart` 함수 순서 정리

#### 4.3 State 분기 최적화
- [ ] `record_page.dart`에서 switch 문 직접 사용 확인
- [ ] `calendar_page.dart`에서 switch 문 직접 사용 확인
- [ ] `settings_page.dart`에서 switch 문 직접 사용 확인
- [ ] `_build` 헬퍼 메서드 사용 여부 확인 및 제거

**예상 영향**:
- 영향 받는 파일: 모든 feature의 presentation 레이어
- 의존성: Phase 1, 2, 3 완료 필요

**검증 방법**:
- [ ] 빌드 성공
- [ ] UI/UX 변경 없음 확인
- [ ] 공통 위젯이 올바르게 동작
- [ ] Hot reload 정상 동작

---

### Phase 5: 문서화 및 .cursorrules 파일 생성
**목표**: 프로젝트 문서화 및 커서룰 파일 생성

**작업 목록**:

#### 5.1 .cursorrules 파일 생성
- [ ] `.cursorrules` 파일 생성 (Gear Freak 스타일 기반, Poozizic 맞춤)
  ```
  # Poozizic 프로젝트 Cursor Rules

  ## 프로젝트 전체 구조 규칙
  [Gear Freak의 규칙을 Poozizic에 맞게 조정]

  ## Presentation Layer 구조 규칙
  [배럴 파일 패턴, Page/View/Widget 구분]

  ## 공통 위젯 사용 규칙
  [Pz prefix 위젯 사용]

  ## State 분기 처리 규칙
  [|| 패턴, _build 헬퍼 금지]

  ## Clean Architecture 패턴
  [레이어 분리, 의존성 규칙]

  ## 문서화 규칙
  [TROUBLESHOOTING_AND_IMPROVEMENTS.md 사용]
  ```

#### 5.2 문서화
- [ ] `docs/TROUBLESHOOTING_AND_IMPROVEMENTS.md`에 Phase 1-4 작업 내용 기록
  - 공통 위젯 시스템 구축
  - 배럴 파일 패턴 적용
  - screens/ 마이그레이션
  - 주요 개선사항

- [ ] `README.md` 업데이트 (선택 사항)
  - 프로젝트 구조 설명
  - 커서룰 적용 내용
  - 개발 가이드

#### 5.3 최종 검증
- [ ] 전체 빌드 성공
- [ ] 모든 화면 정상 동작
- [ ] Hot reload 정상 동작
- [ ] Import 경로 일관성 확인
- [ ] 공통 위젯 적용 확인

**Phase 5 체크리스트**:
- [ ] `.cursorrules` 파일 생성 완료
- [ ] .cursorrules 내용 작성 (디렉토리 구조, 배럴 파일, 공통 위젯, State 분기, Clean Architecture, 문서화)
- [ ] `docs/TROUBLESHOOTING_AND_IMPROVEMENTS.md`에 Phase 1-4 작업 기록
- [ ] 전체 프로젝트 빌드 성공
- [ ] 모든 화면 정상 동작 (홈, 캘린더, 레코드, 설정, 분석, 식사, 수분, 운동)
- [ ] Hot reload 정상
- [ ] 공통 위젯 정상 동작 확인
- [ ] Import 경로 일관성 확인 (모두 배럴 파일 사용)
- [ ] Git commit 준비 완료

**예상 영향**:
- 영향 받는 파일: 프로젝트 루트 (`.cursorrules`), `docs/`
- 의존성: Phase 1-4 완료 필요

**검증 방법**:
- [ ] 문서 작성 완료
- [ ] .cursorrules 파일 문법 오류 없음
- [ ] 팀원들이 규칙 이해 가능

---

## 4. 리스크 및 대응

### 리스크 1: Import 경로 변경으로 인한 빌드 오류
- **확률**: Medium
- **영향도**: High
- **완화 방안**:
  - Phase별로 점진적 적용
  - 각 Phase 완료 후 빌드 검증
  - IDE의 Find & Replace 기능 적극 활용
  - 배럴 파일 생성 후 기존 import는 유지하고 점진적 교체

### 리스크 2: 공통 위젯 스타일이 기존 UI와 불일치
- **확률**: Low
- **영향도**: Medium
- **완화 방안**:
  - Phase 1에서 공통 위젯 구현 시 기존 디자인 시스템 참고
  - Poozizic 프로젝트의 테마 색상 적용
  - 각 위젯 구현 후 즉시 테스트

### 리스크 3: screens/ 마이그레이션 시 네비게이션 오류
- **확률**: Low
- **영향도**: Medium
- **완화 방안**:
  - Phase 3에서 한 번에 하나씩 마이그레이션
  - 각 파일 이동 후 main.dart에서 import 즉시 수정
  - MaterialPageRoute의 builder 함수 정상 동작 확인

### 리스크 4: 작업량이 많아 중간에 중단
- **확률**: Medium
- **영향도**: High
- **완화 방안**:
  - 각 Phase는 독립적으로 완료 가능하도록 설계
  - Phase 1, 2만 완료해도 일부 효과 있음
  - 우선순위: Phase 1 > Phase 2 > Phase 5 > Phase 4 > Phase 3
  - **롤백 전략**:
    - Phase 1: 공통 위젯 파일 삭제, import 제거
    - Phase 2: 배럴 파일 삭제, import 원상복구
    - Phase 3: 마이그레이션된 파일을 screens/로 복구
    - Phase 4: git revert 또는 백업에서 복구
    - Phase 5: 문서 및 .cursorrules 파일 삭제

### 리스크 5: const 생성자 적용 시 런타임 오류
- **확률**: Low
- **영향도**: Medium
- **완화 방안**:
  - 공통 위젯 구현 시 const 생성자 신중히 적용
  - 동적 값을 받는 경우 const 제거
  - Hot reload로 즉시 확인

---

## 5. 전체 검증 계획

### 자동 테스트
현재 Poozizic 프로젝트에는 테스트가 없으므로, 이번 작업에서는 수동 테스트로 진행.

향후 테스트 추가 권장:
- [ ] 단위 테스트 (UseCase, Repository)
- [ ] 위젯 테스트 (공통 위젯)
- [ ] 통합 테스트

### 수동 테스트

#### 시나리오 1: 배변 기록 생성
1. 앱 실행
2. 중앙 FAB 클릭
3. "배변 기록" 선택
4. Bristol Type 선택
5. Feeling 선택
6. Duration 설정
7. 제출
8. 홈 화면에서 기록 확인
9. 캘린더 화면에서 기록 확인

**검증 항목**:
- [ ] 화면 전환 정상
- [ ] 데이터 저장 정상
- [ ] PzLoadingView 표시 (제출 중)
- [ ] PzSnackBar 표시 (성공 메시지)

#### 시나리오 2: 캘린더에서 통계 확인
1. 캘린더 탭 클릭
2. 월별 기록 확인
3. 날짜 클릭 시 해당 날짜 기록 표시
4. 통계 카드 확인

**검증 항목**:
- [ ] 캘린더 렌더링 정상
- [ ] 기록 데이터 표시 정상
- [ ] 통계 계산 정확

#### 시나리오 3: 설정 변경
1. 설정 탭 클릭
2. 목표 설정 변경
3. 알림 설정 변경
4. 저장
5. 앱 재시작 후 설정 유지 확인

**검증 항목**:
- [ ] 설정 UI 정상
- [ ] 데이터 저장 정상
- [ ] 설정 로드 정상

#### 시나리오 4: 에러 처리
1. 네트워크 오프 상태에서 데이터 로드 (현재는 로컬 데이터만 사용하므로 해당 없음)
2. 유효하지 않은 입력 제출

**검증 항목**:
- [ ] PzErrorView 표시
- [ ] PzSnackBar.showError 표시
- [ ] 사용자 친화적 에러 메시지

### 성능 체크
- [ ] 빌드 시간: 기존 대비 큰 차이 없음 (배럴 파일은 컴파일 시간에 영향 없음)
- [ ] 앱 실행 속도: 변화 없음
- [ ] Hot reload 속도: 변화 없음
- [ ] 메모리 사용량: 변화 없음 (공통 위젯은 싱글톤 패턴 또는 const 생성자 사용)

---

## 6. 참고 사항

### 주의할 점

1. **배럴 파일 순환 참조 방지**
   - 배럴 파일끼리 import하지 않도록 주의
   - 각 배럴 파일은 자신의 디렉토리 내부 파일만 export

2. **점진적 적용**
   - 한 번에 모든 것을 변경하지 말고 Phase별로 진행
   - 각 Phase 완료 후 반드시 빌드 및 테스트

3. **기존 코드 보존**
   - 기존 로직은 최대한 유지
   - UI 변경 최소화 (공통 위젯 스타일만 적용)

4. **Pz prefix 일관성**
   - 모든 공통 위젯은 Pz prefix 사용
   - 네이밍: `PzDialog`, `PzSnackBar` (PascalCase)

5. **문서화 습관**
   - 각 Phase 완료 시 TROUBLESHOOTING_AND_IMPROVEMENTS.md에 기록
   - 특이사항, 개선사항, 트러블슈팅 내용 상세 기록

### 참고 문서
- `thoughts/shared/research/cursorrules_analysis_2026-01-12.md`: Gear Freak 커서룰 분석
- `/Users/pyowonsik/Downloads/workspace/gear_freak/gear_freak_flutter/.cursorrules`: 원본 커서룰 파일

### 향후 개선 사항 (이번 작업 범위 외)
- View 레이어 분리 (LoadingView, ErrorView, DataView)
- 테스트 코드 작성
- CI/CD 파이프라인 구축
- 코드 린팅 규칙 강화 (analysis_options.yaml)
- 성능 프로파일링 및 최적화

---

## 7. 타임라인 및 우선순위

### 우선순위
1. **Phase 1** (공통 위젯): 즉시 적용 가능, 가장 높은 재사용성
2. **Phase 2** (배럴 파일): 즉시 적용 가능, 코드 일관성 향상
3. **Phase 5** (문서화): 즉시 적용 가능, 지식 공유
4. **Phase 4** (공통 위젯 적용): Phase 1 의존, 코드 품질 향상
5. **Phase 3** (screens 마이그레이션): 선택 사항, 구조 개선

### 예상 작업 시간 (참고용)
- **Phase 1**: 2-3시간 (공통 위젯 6개 구현 + 테스트)
- **Phase 2**: 1-2시간 (배럴 파일 생성 및 import 변경 + 검증)
- **Phase 3**: 2-3시간 (5개 feature 마이그레이션 + 테스트)
- **Phase 4**: 2-3시간 (전체 코드 리팩토링 + 검증)
- **Phase 5**: 1시간 (문서화 및 .cursorrules 작성)

**총 예상 시간**: 8-12시간

**권장 진행 방식**:
- **1일차 (3-4시간)**: Phase 1 완료, Phase 2 착수
- **2일차 (3-4시간)**: Phase 2 완료, Phase 5 착수 및 완료
- **3일차 (2-3시간)**: Phase 4 착수 (선택)
- **4일차 (2-3시간)**: Phase 3 착수 (선택)

**최소 완료 기준**: Phase 1 + Phase 2 + Phase 5 (5-7시간)

---

## 8. 성공 지표

### 정량적 지표
- [ ] 배럴 파일 생성 개수: 최소 15개 (3 features × 4 layers + 1 top-level = 15개)
- [ ] 공통 위젯 생성 개수: 6개
- [ ] screens/ 디렉토리 파일 마이그레이션: 5개
- [ ] Import 경로 변경: 모든 feature import가 배럴 파일 사용
- [ ] 빌드 성공률: 100%

### 정성적 지표
- [ ] 코드 일관성 향상
- [ ] 모듈 캡슐화 개선
- [ ] 신규 개발자 온보딩 용이성 향상
- [ ] 유지보수성 향상
- [ ] 문서화 수준 향상

---

## 9. 결론

이 계획은 Gear Freak 프로젝트의 커서룰 스타일을 Poozizic 프로젝트에 적용하여, 코드 품질과 팀 협업 효율성을 크게 향상시킬 것입니다.

**핵심 포인트**:
1. **배럴 파일 패턴**: Import 경로 통일, 모듈 캡슐화
2. **공통 위젯 시스템**: 코드 재사용, 일관된 UX
3. **디렉토리 구조 개선**: Feature별 독립성 강화
4. **문서화 습관**: 지식 공유, 컨텍스트 유지

각 Phase는 독립적으로 완료 가능하며, 우선순위에 따라 점진적으로 적용할 수 있습니다.
