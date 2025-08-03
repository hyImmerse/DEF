import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface ValidationRequest {
  businessNumber: string
}

// 사업자번호 검증 알고리즘 (한국 사업자등록번호)
function validateBusinessNumber(businessNumber: string): boolean {
  // 하이픈 제거 및 숫자만 추출
  const cleaned = businessNumber.replace(/[^0-9]/g, '')
  
  // 10자리 확인
  if (cleaned.length !== 10) {
    return false
  }
  
  // 숫자만 있는지 확인
  if (!/^\d{10}$/.test(cleaned)) {
    return false
  }
  
  // 사업자번호 검증 알고리즘
  const checksum = [1, 3, 7, 1, 3, 7, 1, 3, 5]
  let sum = 0
  
  for (let i = 0; i < 9; i++) {
    sum += parseInt(cleaned[i]) * checksum[i]
  }
  
  sum += Math.floor((parseInt(cleaned[8]) * 5) / 10)
  const result = (10 - (sum % 10)) % 10
  
  return result === parseInt(cleaned[9])
}

// 국세청 API 호출 (실제 구현 시 사용)
async function verifyWithNTS(businessNumber: string): Promise<{valid: boolean, businessName?: string}> {
  // TODO: 실제 국세청 API 연동
  // 현재는 더미 데이터 반환
  const dummyBusinesses: Record<string, string> = {
    '1234567890': '요소컴케이엠(주)',
    '2345678901': '테스트상사',
    '3456789012': '샘플유통',
  }
  
  const cleaned = businessNumber.replace(/[^0-9]/g, '')
  if (dummyBusinesses[cleaned]) {
    return {
      valid: true,
      businessName: dummyBusinesses[cleaned]
    }
  }
  
  // 개발 환경에서는 유효한 체크섬이면 통과
  if (validateBusinessNumber(businessNumber)) {
    return {
      valid: true,
      businessName: '테스트 사업자'
    }
  }
  
  return { valid: false }
}

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { businessNumber } = await req.json() as ValidationRequest

    if (!businessNumber) {
      return new Response(
        JSON.stringify({ error: '사업자번호를 입력해주세요' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // 체크섬 검증
    const isValidFormat = validateBusinessNumber(businessNumber)
    
    if (!isValidFormat) {
      return new Response(
        JSON.stringify({ 
          isValid: false,
          error: '유효하지 않은 사업자번호 형식입니다'
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200
        }
      )
    }

    // 국세청 API 검증 (또는 더미 데이터)
    const ntsResult = await verifyWithNTS(businessNumber)
    
    if (!ntsResult.valid) {
      return new Response(
        JSON.stringify({ 
          isValid: false,
          error: '등록되지 않은 사업자번호입니다'
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200
        }
      )
    }

    // 이미 등록된 사업자번호인지 확인
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const { data: existingProfile } = await supabaseClient
      .from('profiles')
      .select('id, status')
      .eq('business_number', businessNumber.replace(/[^0-9]/g, ''))
      .single()

    if (existingProfile) {
      return new Response(
        JSON.stringify({ 
          isValid: false,
          error: '이미 등록된 사업자번호입니다',
          status: existingProfile.status
        }),
        { 
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200
        }
      )
    }

    return new Response(
      JSON.stringify({ 
        isValid: true,
        businessName: ntsResult.businessName,
        message: '사용 가능한 사업자번호입니다'
      }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 200
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { 
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        status: 500
      }
    )
  }
})