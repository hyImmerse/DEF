-- 공지사항 테이블
CREATE TABLE IF NOT EXISTS notices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  title TEXT NOT NULL,
  content TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT '일반',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_by UUID REFERENCES auth.users(id),
  is_important BOOLEAN NOT NULL DEFAULT FALSE,
  is_active BOOLEAN NOT NULL DEFAULT TRUE,
  image_url TEXT,
  start_date TIMESTAMPTZ,
  end_date TIMESTAMPTZ,
  view_count INTEGER NOT NULL DEFAULT 0,
  tags TEXT[] DEFAULT '{}',
  meta_data JSONB DEFAULT '{}'
);

-- 공지사항 첨부파일 테이블
CREATE TABLE IF NOT EXISTS notice_attachments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  notice_id UUID NOT NULL REFERENCES notices(id) ON DELETE CASCADE,
  file_name TEXT NOT NULL,
  file_url TEXT NOT NULL,
  file_size INTEGER,
  mime_type TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- 공지사항 읽음 상태 테이블
CREATE TABLE IF NOT EXISTS notice_read_status (
  notice_id UUID NOT NULL REFERENCES notices(id) ON DELETE CASCADE,
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  read_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  PRIMARY KEY (notice_id, user_id)
);

-- 인덱스 생성
CREATE INDEX idx_notices_category ON notices(category);
CREATE INDEX idx_notices_created_at ON notices(created_at DESC);
CREATE INDEX idx_notices_is_active ON notices(is_active);
CREATE INDEX idx_notices_is_important ON notices(is_important);
CREATE INDEX idx_notice_read_status_user_id ON notice_read_status(user_id);

-- RLS 정책 설정
ALTER TABLE notices ENABLE ROW LEVEL SECURITY;
ALTER TABLE notice_attachments ENABLE ROW LEVEL SECURITY;
ALTER TABLE notice_read_status ENABLE ROW LEVEL SECURITY;

-- 공지사항 조회 권한 (모든 사용자)
CREATE POLICY "Anyone can view active notices" ON notices
  FOR SELECT USING (is_active = TRUE);

-- 공지사항 생성/수정/삭제 권한 (관리자만)
CREATE POLICY "Only admins can insert notices" ON notices
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND role = 'admin'
    )
  );

CREATE POLICY "Only admins can update notices" ON notices
  FOR UPDATE WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND role = 'admin'
    )
  );

CREATE POLICY "Only admins can delete notices" ON notices
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM profiles 
      WHERE id = auth.uid() 
      AND role = 'admin'
    )
  );

-- 첨부파일 조회 권한 (해당 공지사항이 활성화된 경우)
CREATE POLICY "Anyone can view attachments of active notices" ON notice_attachments
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM notices 
      WHERE id = notice_attachments.notice_id 
      AND is_active = TRUE
    )
  );

-- 읽음 상태 관리 권한 (본인 것만)
CREATE POLICY "Users can manage their own read status" ON notice_read_status
  FOR ALL USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());

-- 공지사항 카테고리 가져오기 함수
CREATE OR REPLACE FUNCTION get_notice_categories()
RETURNS TABLE (category TEXT, count BIGINT)
LANGUAGE sql
STABLE
AS $$
  SELECT DISTINCT 
    category,
    COUNT(*) as count
  FROM notices
  WHERE is_active = TRUE
  GROUP BY category
  ORDER BY category;
$$;

-- 공지사항 조회수 증가 함수
CREATE OR REPLACE FUNCTION increment_notice_view_count(notice_uuid UUID)
RETURNS void
LANGUAGE sql
AS $$
  UPDATE notices
  SET view_count = view_count + 1
  WHERE id = notice_uuid;
$$;

-- 사용자별 읽지 않은 공지사항 수 가져오기 함수
CREATE OR REPLACE FUNCTION get_unread_notice_count(user_uuid UUID)
RETURNS BIGINT
LANGUAGE sql
STABLE
AS $$
  SELECT COUNT(*)
  FROM notices n
  WHERE n.is_active = TRUE
  AND NOT EXISTS (
    SELECT 1 
    FROM notice_read_status nrs 
    WHERE nrs.notice_id = n.id 
    AND nrs.user_id = user_uuid
  );
$$;

-- updated_at 자동 업데이트 트리거
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_notices_updated_at
  BEFORE UPDATE ON notices
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- 샘플 데이터 삽입
INSERT INTO notices (title, content, category, is_important) VALUES
  ('시스템 점검 안내', '2024년 1월 15일 오전 2시부터 4시까지 시스템 점검이 예정되어 있습니다. 이 시간 동안 서비스 이용이 제한될 수 있습니다.', '시스템', TRUE),
  ('요소수 가격 인상 안내', '원자재 가격 상승으로 인해 1월 20일부터 요소수 가격이 5% 인상됩니다. 양해 부탁드립니다.', '가격', TRUE),
  ('신규 거래처 추가', '강원도 지역에 새로운 거래처가 추가되었습니다. 자세한 내용은 영업팀에 문의해주세요.', '일반', FALSE),
  ('배송 지연 안내', '폭설로 인해 일부 지역의 배송이 지연되고 있습니다. 고객님의 양해 부탁드립니다.', '배송', TRUE),
  ('설 연휴 배송 일정', '설 연휴 기간 동안의 배송 일정을 안내드립니다. 1월 20일부터 1월 25일까지는 배송이 중단됩니다.', '배송', FALSE);