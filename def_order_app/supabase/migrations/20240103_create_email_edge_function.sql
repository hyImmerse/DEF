-- Edge Function: send-email
-- 이메일 발송을 위한 Edge Function
-- 
-- 사용법:
-- await supabase.functions.invoke('send-email', {
--   body: {
--     to: 'recipient@example.com',
--     subject: '제목',
--     html: '<html>내용</html>',
--     attachments: [
--       {
--         filename: 'file.pdf',
--         path: 'https://url-to-file.pdf',
--         contentType: 'application/pdf'
--       }
--     ]
--   }
-- });

-- Note: 실제 Edge Function 코드는 Supabase Dashboard에서 생성해야 합니다.
-- 또는 supabase CLI를 사용하여 배포할 수 있습니다.

-- supabase/functions/send-email/index.ts 파일 생성:
/*
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { SmtpClient } from "https://deno.land/x/smtp@v0.7.0/mod.ts"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { to, subject, html, attachments } = await req.json()

    // SMTP 설정 (환경변수 사용)
    const client = new SmtpClient()
    await client.connectTLS({
      hostname: Deno.env.get('SMTP_HOST')!,
      port: parseInt(Deno.env.get('SMTP_PORT')!),
      username: Deno.env.get('SMTP_USER')!,
      password: Deno.env.get('SMTP_PASS')!,
    })

    // 이메일 발송
    await client.send({
      from: Deno.env.get('SMTP_FROM')!,
      to: to,
      subject: subject,
      content: html,
      html: html,
      attachments: attachments,
    })

    await client.close()

    return new Response(
      JSON.stringify({ success: true }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { 
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})
*/

-- Storage bucket 생성 (거래명세서 저장용)
INSERT INTO storage.buckets (id, name, public, avif_autodetection, file_size_limit, allowed_mime_types)
VALUES (
  'transaction-statements',
  'transaction-statements',
  false, -- 비공개 버킷
  false,
  10485760, -- 10MB
  ARRAY['application/pdf']::text[]
)
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  public = EXCLUDED.public,
  file_size_limit = EXCLUDED.file_size_limit,
  allowed_mime_types = EXCLUDED.allowed_mime_types;

-- Storage 정책 설정
CREATE POLICY "Users can upload their own transaction statements"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
  bucket_id = 'transaction-statements' 
  AND (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "Users can view their own transaction statements"
ON storage.objects
FOR SELECT
TO authenticated
USING (
  bucket_id = 'transaction-statements' 
  AND (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "Users can delete their own transaction statements"
ON storage.objects
FOR DELETE
TO authenticated
USING (
  bucket_id = 'transaction-statements' 
  AND (storage.foldername(name))[1] = auth.uid()::text
);

-- 관리자는 모든 거래명세서 접근 가능
CREATE POLICY "Admins can access all transaction statements"
ON storage.objects
FOR ALL
TO authenticated
USING (
  bucket_id = 'transaction-statements'
  AND EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.id = auth.uid()
    AND profiles.user_type = 'admin'
  )
);