import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.1'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface NotificationPayload {
  userId?: string;
  userIds?: string[];
  topic?: string | string[];
  notification: {
    title: string;
    body: string;
    data?: Record<string, any>;
  };
  options?: {
    priority?: 'high' | 'normal';
    channelId?: string;
  };
}

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const fcmServerKey = Deno.env.get('FCM_SERVER_KEY')!
    
    const supabase = createClient(supabaseUrl, supabaseServiceKey)
    
    const payload: NotificationPayload = await req.json()
    
    // FCM 토큰 수집
    let fcmTokens: string[] = []
    
    // userId로 발송
    if (payload.userId) {
      const { data: profile } = await supabase
        .from('profiles')
        .select('fcm_token')
        .eq('id', payload.userId)
        .single()
        
      if (profile?.fcm_token) {
        fcmTokens.push(profile.fcm_token)
      }
    }
    
    // userIds로 발송
    if (payload.userIds && payload.userIds.length > 0) {
      const { data: profiles } = await supabase
        .from('profiles')
        .select('fcm_token')
        .in('id', payload.userIds)
        
      if (profiles) {
        fcmTokens.push(...profiles.map(p => p.fcm_token).filter(Boolean))
      }
    }
    
    // 주제로 발송 (전체 공지 등)
    if (payload.topic) {
      // FCM 주제 구독 관리는 클라이언트에서 처리
      // 여기서는 주제별 사용자 조회
      const topics = Array.isArray(payload.topic) ? payload.topic : [payload.topic]
      
      for (const topic of topics) {
        if (topic === 'all') {
          // 전체 사용자
          const { data: profiles } = await supabase
            .from('profiles')
            .select('fcm_token')
            .not('fcm_token', 'is', null)
            
          if (profiles) {
            fcmTokens.push(...profiles.map(p => p.fcm_token))
          }
        } else if (topic === 'dealer' || topic === 'general') {
          // 사용자 타입별
          const { data: profiles } = await supabase
            .from('profiles')
            .select('fcm_token')
            .eq('user_type', topic)
            .not('fcm_token', 'is', null)
            
          if (profiles) {
            fcmTokens.push(...profiles.map(p => p.fcm_token))
          }
        }
      }
    }
    
    // 중복 제거
    fcmTokens = [...new Set(fcmTokens)]
    
    if (fcmTokens.length === 0) {
      return new Response(
        JSON.stringify({ 
          success: true, 
          message: '발송할 FCM 토큰이 없습니다' 
        }),
        { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }
    
    // FCM 메시지 생성
    const fcmMessage = {
      registration_ids: fcmTokens,
      notification: {
        title: payload.notification.title,
        body: payload.notification.body,
        sound: 'default',
        ...(payload.options?.channelId && {
          android_channel_id: payload.options.channelId
        })
      },
      data: payload.notification.data || {},
      priority: payload.options?.priority || 'normal',
      content_available: true, // iOS 백그라운드 알림
    }
    
    // FCM API 호출
    const fcmResponse = await fetch('https://fcm.googleapis.com/fcm/send', {
      method: 'POST',
      headers: {
        'Authorization': `key=${fcmServerKey}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(fcmMessage),
    })
    
    const fcmResult = await fcmResponse.json()
    
    if (!fcmResponse.ok) {
      throw new Error(`FCM 오류: ${JSON.stringify(fcmResult)}`)
    }
    
    // 알림 기록 저장
    await supabase.from('notification_logs').insert({
      user_id: payload.userId,
      user_ids: payload.userIds,
      topic: payload.topic,
      title: payload.notification.title,
      body: payload.notification.body,
      data: payload.notification.data,
      fcm_response: fcmResult,
      success_count: fcmResult.success || 0,
      failure_count: fcmResult.failure || 0,
    })
    
    return new Response(
      JSON.stringify({ 
        success: true,
        fcmResult,
        sentCount: fcmTokens.length
      }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  } catch (error) {
    return new Response(
      JSON.stringify({ 
        success: false,
        error: error.message 
      }),
      { 
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' }
      }
    )
  }
})