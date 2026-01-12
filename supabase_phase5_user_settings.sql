-- Poozizic Supabase Database Schema
-- Phase 5: 사용자 설정 테이블

-- ============================================================================
-- 사용자 설정 테이블 (user_settings)
-- ============================================================================

CREATE TABLE IF NOT EXISTS user_settings (
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,

  -- 목표 설정
  water_goal INTEGER NOT NULL DEFAULT 2000 CHECK (water_goal >= 0 AND water_goal <= 10000),
  bowel_goal INTEGER NOT NULL DEFAULT 1 CHECK (bowel_goal >= 0 AND bowel_goal <= 10),

  -- 알림 설정
  bowel_reminder BOOLEAN NOT NULL DEFAULT true,
  water_reminder BOOLEAN NOT NULL DEFAULT true,
  weekly_report BOOLEAN NOT NULL DEFAULT true,

  -- 프라이버시 설정
  app_lock BOOLEAN NOT NULL DEFAULT false,
  hide_notification_content BOOLEAN NOT NULL DEFAULT false,
  cloud_backup BOOLEAN NOT NULL DEFAULT false,

  -- 메타 데이터
  created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
  updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

-- 인덱스 생성
CREATE INDEX IF NOT EXISTS idx_user_settings_user_id ON user_settings(user_id);

-- Row Level Security 활성화
ALTER TABLE user_settings ENABLE ROW LEVEL SECURITY;

-- RLS 정책: 사용자는 자신의 설정만 조회 가능
CREATE POLICY "Users can view own settings"
  ON user_settings FOR SELECT
  USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 설정만 생성 가능
CREATE POLICY "Users can insert own settings"
  ON user_settings FOR INSERT
  WITH CHECK (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 설정만 수정 가능
CREATE POLICY "Users can update own settings"
  ON user_settings FOR UPDATE
  USING (auth.uid() = user_id);

-- RLS 정책: 사용자는 자신의 설정만 삭제 가능
CREATE POLICY "Users can delete own settings"
  ON user_settings FOR DELETE
  USING (auth.uid() = user_id);

-- updated_at 자동 업데이트 트리거
CREATE OR REPLACE FUNCTION update_user_settings_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER user_settings_updated_at
  BEFORE UPDATE ON user_settings
  FOR EACH ROW
  EXECUTE FUNCTION update_user_settings_updated_at();

-- 테이블 설명
COMMENT ON TABLE user_settings IS '사용자 설정 테이블 (user당 1개의 레코드)';
COMMENT ON COLUMN user_settings.water_goal IS '일일 수분 섭취 목표 (ml)';
COMMENT ON COLUMN user_settings.bowel_goal IS '일일 배변 목표 (회)';
