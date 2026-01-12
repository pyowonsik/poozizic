-- Poozizic Supabase Database Schema
-- Phase 4: 식사/수분/운동 기록 테이블

-- ============================================================================
-- 1. 식사 기록 테이블 (meal_records)
-- ============================================================================

CREATE TABLE IF NOT EXISTS meal_records (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  meal_type INTEGER NOT NULL CHECK (meal_type >= 0 AND meal_type <= 3),
  foods TEXT[] NOT NULL,
  fiber_level INTEGER NOT NULL CHECK (fiber_level >= 0 AND fiber_level <= 2),
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_meal_records_user_id ON meal_records(user_id);
CREATE INDEX IF NOT EXISTS idx_meal_records_datetime ON meal_records(record_datetime DESC);
CREATE INDEX IF NOT EXISTS idx_meal_records_user_datetime ON meal_records(user_id, record_datetime DESC);

-- Row Level Security 활성화
ALTER TABLE meal_records ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 사용자는 자신의 기록만 조회 가능
CREATE POLICY "Users can view own meal records"
  ON meal_records FOR SELECT
  USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 생성 가능
CREATE POLICY "Users can insert own meal records"
  ON meal_records FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 수정 가능
CREATE POLICY "Users can update own meal records"
  ON meal_records FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 삭제 가능
CREATE POLICY "Users can delete own meal records"
  ON meal_records FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- 2. 수분 기록 테이블 (water_records)
-- ============================================================================

CREATE TABLE IF NOT EXISTS water_records (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  amount_ml INTEGER NOT NULL CHECK (amount_ml > 0 AND amount_ml <= 10000),
  preset_type TEXT CHECK (preset_type IN ('cup', 'mug', 'can', 'bottle')),
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_water_records_user_id ON water_records(user_id);
CREATE INDEX IF NOT EXISTS idx_water_records_datetime ON water_records(record_datetime DESC);
CREATE INDEX IF NOT EXISTS idx_water_records_user_datetime ON water_records(user_id, record_datetime DESC);

-- Row Level Security 활성화
ALTER TABLE water_records ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 사용자는 자신의 기록만 조회 가능
CREATE POLICY "Users can view own water records"
  ON water_records FOR SELECT
  USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 생성 가능
CREATE POLICY "Users can insert own water records"
  ON water_records FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 수정 가능
CREATE POLICY "Users can update own water records"
  ON water_records FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 삭제 가능
CREATE POLICY "Users can delete own water records"
  ON water_records FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- 3. 운동 기록 테이블 (exercise_records)
-- ============================================================================

CREATE TABLE IF NOT EXISTS exercise_records (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  exercise_type INTEGER NOT NULL CHECK (exercise_type >= 0 AND exercise_type <= 5),
  duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0 AND duration_minutes <= 600),
  intensity INTEGER NOT NULL CHECK (intensity >= 0 AND intensity <= 2),
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_exercise_records_user_id ON exercise_records(user_id);
CREATE INDEX IF NOT EXISTS idx_exercise_records_datetime ON exercise_records(record_datetime DESC);
CREATE INDEX IF NOT EXISTS idx_exercise_records_user_datetime ON exercise_records(user_id, record_datetime DESC);

-- Row Level Security 활성화
ALTER TABLE exercise_records ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 사용자는 자신의 기록만 조회 가능
CREATE POLICY "Users can view own exercise records"
  ON exercise_records FOR SELECT
  USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 생성 가능
CREATE POLICY "Users can insert own exercise records"
  ON exercise_records FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 수정 가능
CREATE POLICY "Users can update own exercise records"
  ON exercise_records FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 삭제 가능
CREATE POLICY "Users can delete own exercise records"
  ON exercise_records FOR DELETE
  USING (auth.uid() = user_id);

-- ============================================================================
-- 테이블 설명 (선택 사항)
-- ============================================================================

COMMENT ON TABLE meal_records IS '식사 기록 테이블';
COMMENT ON COLUMN meal_records.meal_type IS '0: 아침, 1: 점심, 2: 저녁, 3: 간식';
COMMENT ON COLUMN meal_records.fiber_level IS '0: 많음, 1: 보통, 2: 적음';

COMMENT ON TABLE water_records IS '수분 섭취 기록 테이블';
COMMENT ON COLUMN water_records.preset_type IS 'cup: 컵, mug: 머그컵, can: 캔, bottle: 물병';

COMMENT ON TABLE exercise_records IS '운동 기록 테이블';
COMMENT ON COLUMN exercise_records.exercise_type IS '0: 달리기, 1: 걷기, 2: 자전거, 3: 수영, 4: 요가, 5: 웨이트';
COMMENT ON COLUMN exercise_records.intensity IS '0: 가볍게, 1: 보통, 2: 격하게';
