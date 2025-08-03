import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface OrderRequest {
  orderId: string
  action: 'confirm' | 'ship' | 'complete' | 'cancel'
  reason?: string
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

    const { orderId, action, reason } = await req.json() as OrderRequest
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

    // Get order details
    const { data: order, error: orderError } = await supabaseClient
      .from('orders')
      .select('*, profiles(business_name, phone)')
      .eq('id', orderId)
      .single()

    if (orderError || !order) {
      return new Response(
        JSON.stringify({ error: 'Order not found' }),
        { status: 404, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Process action
    let updateData: any = {}
    let notificationTitle = ''
    let notificationMessage = ''

    switch (action) {
      case 'confirm':
        if (order.status !== 'pending') {
          return new Response(
            JSON.stringify({ error: 'Invalid order status for confirmation' }),
            { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }
        updateData = {
          status: 'confirmed',
          confirmed_at: new Date().toISOString(),
          confirmed_by: user.id
        }
        notificationTitle = '주문 확정'
        notificationMessage = `주문번호 ${order.order_number}이(가) 확정되었습니다.`
        break

      case 'ship':
        if (order.status !== 'confirmed') {
          return new Response(
            JSON.stringify({ error: 'Invalid order status for shipping' }),
            { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }
        
        // Check inventory
        const location = 'warehouse' // or 'factory' based on business logic
        const { data: inventoryResult } = await supabaseClient.rpc('deduct_inventory', {
          p_location: location,
          p_product_type: order.product_type,
          p_quantity: order.quantity,
          p_order_id: orderId
        })

        if (!inventoryResult) {
          return new Response(
            JSON.stringify({ error: 'Insufficient inventory' }),
            { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }

        updateData = {
          status: 'shipped',
          shipped_at: new Date().toISOString()
        }
        notificationTitle = '배송 시작'
        notificationMessage = `주문번호 ${order.order_number}의 배송이 시작되었습니다.`
        break

      case 'complete':
        if (order.status !== 'shipped') {
          return new Response(
            JSON.stringify({ error: 'Invalid order status for completion' }),
            { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }
        updateData = {
          status: 'completed',
          completed_at: new Date().toISOString()
        }
        notificationTitle = '배송 완료'
        notificationMessage = `주문번호 ${order.order_number}의 배송이 완료되었습니다.`
        break

      case 'cancel':
        if (order.status === 'completed' || order.status === 'cancelled') {
          return new Response(
            JSON.stringify({ error: 'Cannot cancel completed or already cancelled order' }),
            { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }
        updateData = {
          status: 'cancelled',
          cancelled_at: new Date().toISOString(),
          cancelled_reason: reason || '관리자 취소'
        }
        notificationTitle = '주문 취소'
        notificationMessage = `주문번호 ${order.order_number}이(가) 취소되었습니다.`
        break

      default:
        return new Response(
          JSON.stringify({ error: 'Invalid action' }),
          { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
        )
    }

    // Update order
    const { error: updateError } = await supabaseClient
      .from('orders')
      .update(updateData)
      .eq('id', orderId)

    if (updateError) {
      return new Response(
        JSON.stringify({ error: 'Failed to update order' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Create notification
    await supabaseClient
      .from('notifications')
      .insert({
        user_id: order.user_id,
        type: 'order_status',
        title: notificationTitle,
        message: notificationMessage,
        reference_id: orderId,
        reference_type: 'order'
      })

    // Send FCM notification (TODO: Implement FCM sending)
    // await sendFCMNotification(order.user_id, notificationTitle, notificationMessage)

    return new Response(
      JSON.stringify({ 
        success: true, 
        message: `Order ${action} successful`,
        order: { ...order, ...updateData }
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