# Poozizic Record Features 구조 분석

**날짜**: 2026-01-10
**분석 대상**: lib/feature 내 record 관련 모듈

---

## 1. 현재 구조 분석

### 1.1 Record 관련 Feature 목록

현재 4개의 분리된 record feature가 존재:

| Feature | 위치 | 역할 |
|---------|------|------|
| record | lib/feature/record/ | 배변 기록 |
| water_record | lib/feature/water_record/ | 수분 섭취 기록 |
| meal_record | lib/feature/meal_record/ | 식사 기록 |
| exercise_record | lib/feature/exercise_record/ | 운동 기록 |

### 1.2 각 Feature의 Entity 비교

```dart
// RecordEntity (배변)
- id, dateTime, bristolType, feeling, durationMinutes, memo, createdAt

// WaterRecordEntity (수분)
- id, dateTime, amountMl, presetType, createdAt

// MealRecordEntity (식사)
- id, dateTime, mealType, foods, fiberLevel, createdAt

// ExerciseRecordEntity (운동)
- id, dateTime, exerciseType, durationMinutes, intensity, createdAt
```

**공통 필드**: `id`, `dateTime`, `createdAt`
**고유 필드**: 각 도메인마다 전혀 다른 비즈니스 필드 존재

### 1.3 파일 수 비교

| Feature | 파일 수 |
|---------|--------|
| record | ~12개 |
| water_record | ~11개 |
| meal_record | ~11개 |
| exercise_record | ~11개 |
| **총합** | **~45개** |

---

## 2. 합치기 vs 분리 분석

### 2.1 합치는 경우 (하나의 record feature)

#### 장점
- **파일 수 감소**: 중복된 failure, repository 인터페이스 등 공유 가능
- **탐색 용이**: 모든 record 관련 코드가 한 곳에
- **공통 로직 재사용**: datasource, repository impl 등에서 패턴 공유

#### 단점
- **God Object 위험**: 하나의 RecordEntity에 모든 필드를 담으면 복잡해짐
- **결합도 증가**: 수분 기록을 수정할 때 배변 기록 코드에 영향 가능
- **테스트 복잡성**: 하나의 feature 테스트가 커짐
- **협업 충돌**: 여러 개발자가 같은 폴더에서 작업 시 충돌 발생 가능

### 2.2 분리하는 경우 (현재 구조)

#### 장점
- **단일 책임 원칙(SRP)**: 각 feature는 하나의 도메인만 담당
- **독립적 개발**: 운동 기록 기능을 추가/수정해도 다른 record에 영향 없음
- **명확한 경계**: 도메인 경계가 폴더로 명확히 구분됨
- **테스트 용이**: 각 feature를 독립적으로 테스트 가능
- **확장성**: 새로운 record 타입 추가 시 기존 코드 수정 불필요
- **Clean Architecture 원칙 준수**: Feature-first 구조의 표준 패턴

#### 단점
- **코드 중복**: 비슷한 구조의 파일들이 반복됨
- **파일 수 증가**: 전체 프로젝트 파일 수가 많아짐
- **보일러플레이트**: UseCase, Repository 등 반복 코드

---

## 3. 결론 및 권장사항

### 3.1 현재 분리 구조 유지 권장

**이유:**

1. **도메인 특수성**
   - 각 entity의 필드가 완전히 다름
   - `bristolType`(배변)과 `amountMl`(수분)은 전혀 다른 비즈니스 로직
   - 합치면 `RecordType` enum으로 분기해야 하고, 이는 더 복잡한 코드를 만듦

2. **Clean Architecture 관점**
   - Feature-based 구조에서 각 feature는 독립적 모듈
   - 도메인이 다르면 분리하는 것이 원칙

3. **실제 사용 패턴**
   - 각 record 화면은 완전히 다른 UI를 가짐
   - 사용자 플로우도 독립적 (배변 기록 ≠ 수분 기록)

4. **확장성**
   - 향후 수면 기록, 약 복용 기록 등 추가 시 새 feature로 쉽게 확장
   - 합쳐둔 구조면 거대한 switch문이 생김

### 3.2 중복 코드 개선 방안 (분리 유지하면서)

현재 분리 구조를 유지하면서 중복을 줄이는 방법:

#### 방안 1: shared 레이어 활용
```
lib/
├── shared/
│   ├── domain/
│   │   └── base_record_entity.dart  # 공통 필드만 가진 추상 클래스
│   └── data/
│       └── base_local_datasource.dart  # 공통 CRUD 로직
├── feature/
│   ├── record/  # 배변 (extends BaseRecordEntity)
│   ├── water_record/  # 수분
│   └── ...
```

#### 방안 2: Mixin 활용
```dart
mixin RecordTimestamps {
  int? get id;
  DateTime get dateTime;
  DateTime get createdAt;
}
```

#### 방안 3: 코드 생성 (build_runner)
- freezed로 entity 생성
- 반복적인 copyWith, toJson, fromJson 자동 생성

---

## 4. 최종 권고

| 항목 | 권고 |
|------|------|
| 현재 구조 | **유지** (분리) |
| 추가 개선 | shared에 공통 base class 추출 고려 |
| 코드 중복 해결 | freezed 도입으로 boilerplate 감소 |

**핵심**: 4개의 record는 이름만 비슷할 뿐 **완전히 다른 도메인**입니다.
합치는 것은 "관련 없는 것을 억지로 묶는 것"이 되어 오히려 유지보수를 어렵게 만듭니다.

---

## 5. 참고: 합쳐야 하는 경우는?

다음 조건이 모두 충족될 때만 합치는 것이 좋음:
- [ ] Entity 필드가 80% 이상 동일
- [ ] 비즈니스 로직이 거의 동일
- [ ] 하나의 화면에서 함께 표시/관리됨
- [ ] 데이터베이스 테이블도 하나로 관리

현재 record들은 위 조건을 하나도 충족하지 않습니다.
