-- 알림 로그 테이블 생성
CREATE TABLE IF NOT EXISTS notification_logs (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id),
  user_ids UUID[] DEFAULT '{}',
  topic TEXT,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  data JSONB DEFAULT '{}',
  fcm_response JSONB,
  success_count INTEGER DEFAULT 0,
  failure_count INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- 인덱스 생성
CREATE INDEX idx_notification_logs_user_id ON notification_logs(user_id);
CREATE INDEX idx_notification_logs_created_at ON notification_logs(created_at DESC);

-- RLS 활성화
ALTER TABLE notification_logs ENABLE ROW LEVEL SECURITY;

-- 관리자만 조회 가능
CREATE POLICY "관리자는 모든 알림 로그를 조회할 수 있습니다"
ON notification_logs
FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.user_type = 'admin'
  )
);

-- 사용자는 자신의 알림 로그만 조회 가능
CREATE POLICY "사용자는 자신의 알림 로그를 조회할 수 있습니다"
ON notification_logs
FOR SELECT
TO authenticated
USING (
  user_id = auth.uid()
  OR auth.uid() = ANY(user_ids)
);

-- 시스템(서비스 롤)만 삽입 가능
CREATE POLICY "시스템만 알림 로그를 생성할 수 있습니다"
ON notification_logs
FOR INSERT
TO service_role
WITH CHECK (true);

-- FCM 토큰 갱신 시각 컬럼 추가 (profiles 테이블)
ALTER TABLE profiles
ADD COLUMN IF NOT EXISTS fcm_token_updated_at TIMESTAMPTZ;

-- FCM 토큰 인덱스 추가
CREATE INDEX IF NOT EXISTS idx_profiles_fcm_token ON profiles(fcm_token) WHERE fcm_token IS NOT NULL;