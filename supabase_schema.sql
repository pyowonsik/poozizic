-- Poozizic Supabase Database Schema
-- Phase 3: 배변 기록 테이블

-- 배변 기록 테이블
CREATE TABLE IF NOT EXISTS bowel_records (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  record_datetime TIMESTAMPTZ NOT NULL,
  bristol_type INTEGER NOT NULL CHECK (bristol_type >= 1 AND bristol_type <= 7),
  feeling INTEGER NOT NULL CHECK (feeling >= 0 AND feeling <= 3),
  duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
  memo TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 인덱스 생성 (성능 향상)
CREATE INDEX IF NOT EXISTS idx_bowel_records_user_id ON bowel_records(user_id);
CREATE INDEX IF NOT EXISTS idx_bowel_records_datetime ON bowel_records(record_datetime DESC);
CREATE INDEX IF NOT EXISTS idx_bowel_records_user_datetime ON bowel_records(user_id, record_datetime DESC);

-- Row Level Security (RLS) 활성화
ALTER TABLE bowel_records ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 사용자는 자신의 기록만 조회 가능
CREATE POLICY "Users can view own bowel records"
  ON bowel_records FOR SELECT
  USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 생성 가능
CREATE POLICY "Users can insert own bowel records"
  ON bowel_records FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 수정 가능
CREATE POLICY "Users can update own bowel records"
  ON bowel_records FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 기록만 삭제 가능
CREATE POLICY "Users can delete own bowel records"
  ON bowel_records FOR DELETE
  USING (auth.uid() = user_id);
