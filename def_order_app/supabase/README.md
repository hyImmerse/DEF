# Supabase 백엔드 설정 가이드

## 1. Supabase 프로젝트 생성

1. [Supabase Dashboard](https://app.supabase.com)에 접속
2. "New Project" 클릭
3. 프로젝트 정보 입력:
   - Project name: `def-order-app`
   - Database Password: 안전한 비밀번호 설정
   - Region: `Northeast Asia (Seoul)` 선택
   - Pricing Plan: 필요에 따라 선택

## 2. 데이터베이스 스키마 설정

1. Supabase Dashboard > SQL Editor로 이동
2. `migrations/20250803_initial_schema.sql` 파일의 내용을 복사
3. SQL Editor에 붙여넣고 "Run" 클릭
4. 성공 메시지 확인

## 3. Edge Functions 배포

### 3.1 Supabase CLI 설치
```bash
npm install -g supabase
```

### 3.2 로그인 및 프로젝트 연결
```bash
supabase login
supabase link --project-ref your-project-ref
```

### 3.3 환경 변수 설정
```bash
# functions/.env 파일 생성 (functions/.env.example 참고)
cp functions/.env.example functions/.env
# 실제 값으로 수정
```

### 3.4 Functions 배포
```bash
# process-order function 배포
supabase functions deploy process-order

# send-notification function 배포
supabase functions deploy send-notification
```

## 4. Storage 버킷 생성

1. Supabase Dashboard > Storage로 이동
2. "Create Bucket" 클릭
3. 다음 버킷들 생성:
   - `invoices` (Private) - PDF 거래명세서 저장용
   - `product-images` (Public) - 제품 이미지 저장용
   - `announcements` (Public) - 공지사항 첨부파일용

## 5. 인증 설정

1. Supabase Dashboard > Authentication > Providers로 이동
2. Email 인증 활성화 확인
3. Authentication > Email Templates로 이동
4. 한국어 템플릿으로 수정:

### 회원가입 확인 이메일
```html
<h2>요소수 주문관리 시스템 회원가입</h2>
<p>안녕하세요,</p>
<p>요소수 주문관리 시스템에 가입해 주셔서 감사합니다.</p>
<p>아래 버튼을 클릭하여 이메일을 인증해 주세요:</p>
<p><a href="{{ .ConfirmationURL }}">이메일 인증하기</a></p>
<p>관리자 승인 후 서비스를 이용하실 수 있습니다.</p>
```

### 비밀번호 재설정 이메일
```html
<h2>비밀번호 재설정</h2>
<p>안녕하세요,</p>
<p>비밀번호를 재설정하려면 아래 버튼을 클릭해 주세요:</p>
<p><a href="{{ .ConfirmationURL }}">비밀번호 재설정</a></p>
<p>이 요청을 하지 않으셨다면 이 이메일을 무시해 주세요.</p>
```

## 6. Row Level Security (RLS) 확인

SQL Editor에서 다음 쿼리로 RLS 상태 확인:
```sql
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';
```

모든 테이블의 `rowsecurity`가 `true`여야 합니다.

## 7. Flutter 앱 연결

1. Supabase Dashboard > Settings > API로 이동
2. 다음 정보를 복사:
   - Project URL
   - Anon public key

3. Flutter 프로젝트의 `.env` 파일에 추가:
```env
SUPABASE_URL=your-project-url
SUPABASE_ANON_KEY=your-anon-key
```

## 8. 관리자 계정 생성

SQL Editor에서 직접 관리자 계정 생성:
```sql
-- 먼저 Supabase Auth에서 사용자 생성 후
-- 생성된 user_id로 프로필 업데이트
UPDATE profiles 
SET 
  grade = 'dealer',
  status = 'approved',
  approved_at = NOW()
WHERE id = 'user-id-here';
```

## 9. 실시간 기능 테스트

```dart
// Flutter 앱에서 실시간 구독 테스트
final channel = SupabaseConfig.client
  .channel('orders')
  .onPostgresChanges(
    event: PostgresChangeEvent.all,
    schema: 'public',
    table: 'orders',
    callback: (payload) {
      print('Change received: ${payload.toString()}');
    },
  )
  .subscribe();
```

## 10. 모니터링

1. Supabase Dashboard > Database > Query Performance
2. Edge Functions > Logs
3. Authentication > Logs

## 주의사항

- **Service Role Key**는 절대 클라이언트 앱에 포함하지 마세요
- Edge Functions는 Service Role Key를 사용합니다
- 프로덕션 환경에서는 반드시 환경 변수를 사용하세요
- RLS 정책을 항상 확인하고 테스트하세요