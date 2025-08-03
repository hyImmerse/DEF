import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface NotificationRequest {
  userId?: string
  userIds?: string[]
  title: string
  message: string
  type: 'order_status' | 'announcement' | 'system'
  data?: Record<string, any>
}

serve(async (req) => {
  // Handle CORS
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const supabaseClient = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    const authHeader = req.headers.get('Authorization')
    const token = authHeader?.replace('Bearer ', '')

    // Verify user
    const { data: { user }, error: authError } = await supabaseClient.auth.getUser(token)
    if (authError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Check if user is admin
    const { data: profile } = await supabaseClient
      .from('profiles')
      .select('grade, status')
      .eq('id', user.id)
      .single()

    if (profile?.grade !== 'dealer' || profile?.status !== 'approved') {
      return new Response(
        JSON.stringify({ error: 'Insufficient permissions' }),
        { status: 403, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const { userId, userIds, title, message, type, data } = await req.json() as NotificationRequest

    // Determine target users
    let targetUserIds: string[] = []
    if (userId) {
      targetUserIds = [userId]
    } else if (userIds && userIds.length > 0) {
      targetUserIds = userIds
    } else {
      return new Response(
        JSON.stringify({ error: 'No target users specified' }),
        { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Create notifications in database
    const notifications = targetUserIds.map(uid => ({
      user_id: uid,
      type,
      title,
      message,
      reference_id: data?.referenceId,
      reference_type: data?.referenceType
    }))

    const { error: insertError } = await supabaseClient
      .from('notifications')
      .insert(notifications)

    if (insertError) {
      return new Response(
        JSON.stringify({ error: 'Failed to create notifications' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Get FCM tokens for target users
    const { data: fcmTokens } = await supabaseClient
      .from('fcm_tokens')
      .select('token, platform')
      .in('user_id', targetUserIds)

    if (fcmTokens && fcmTokens.length > 0) {
      // Prepare FCM messages
      const fcmMessages = fcmTokens.map(tokenData => ({
        token: tokenData.token,
        notification: {
          title,
          body: message
        },
        data: {
          type,
          ...data
        },
        android: {
          priority: 'high',
          notification: {
            sound: 'default',
            clickAction: 'FLUTTER_NOTIFICATION_CLICK'
          }
        },
        apns: {
          payload: {
            aps: {
              alert: {
                title,
                body: message
              },
              sound: 'default',
              badge: 1
            }
          }
        }
      }))

      // TODO: Implement actual FCM sending using Firebase Admin SDK
      // This requires setting up Firebase Admin SDK with service account credentials
      /*
      const messaging = getMessaging()
      const response = await messaging.sendAll(fcmMessages)
      console.log(`Successfully sent ${response.successCount} messages`)
      */

      // For now, we'll just log that we would send FCM
      console.log(`Would send FCM to ${fcmMessages.length} devices`)
    }

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: `Notifications sent to ${targetUserIds.length} users`,
        userCount: targetUserIds.length
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