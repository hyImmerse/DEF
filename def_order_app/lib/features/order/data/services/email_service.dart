import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/order_entity.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/logger.dart';

/// 이메일 발송 서비스
class EmailService {
  final SupabaseClient _supabase;
  
  EmailService({SupabaseClient? supabaseClient})
      : _supabase = supabaseClient ?? Supabase.instance.client;

  /// 거래명세서 이메일 발송
  Future<void> sendTransactionStatement({
    required Order order,
    required String pdfUrl,
    required String recipientEmail,
  }) async {
    try {
      // Supabase Edge Function 호출
      final response = await _supabase.functions.invoke(
        'send-email',
        body: {
          'to': recipientEmail,
          'subject': '[요소컴케이엠] 거래명세서 - 주문번호 ${order.orderNumber}',
          'html': _generateEmailHtml(order, pdfUrl),
          'attachments': [
            {
              'filename': 'statement_${order.orderNumber}.pdf',
              'path': pdfUrl,
              'contentType': 'application/pdf',
            }
          ],
        },
      );

      if (response.error != null) {
        throw ServerException('이메일 발송 실패: ${response.error!.message}');
      }

      logger.i('이메일 발송 성공: $recipientEmail');
    } catch (e) {
      logger.e('이메일 발송 실패', error: e);
      if (e is ServerException) rethrow;
      throw ServerException('이메일 발송 중 오류가 발생했습니다');
    }
  }

  /// 주문 확정 알림 이메일 발송
  Future<void> sendOrderConfirmationEmail({
    required Order order,
    required String recipientEmail,
  }) async {
    try {
      final response = await _supabase.functions.invoke(
        'send-email',
        body: {
          'to': recipientEmail,
          'subject': '[요소컴케이엠] 주문이 확정되었습니다 - 주문번호 ${order.orderNumber}',
          'html': _generateOrderConfirmationHtml(order),
        },
      );

      if (response.error != null) {
        throw ServerException('이메일 발송 실패: ${response.error!.message}');
      }

      logger.i('주문 확정 이메일 발송 성공: $recipientEmail');
    } catch (e) {
      logger.e('이메일 발송 실패', error: e);
      if (e is ServerException) rethrow;
      throw ServerException('이메일 발송 중 오류가 발생했습니다');
    }
  }

  /// 거래명세서 이메일 HTML 생성
  String _generateEmailHtml(Order order, String pdfUrl) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      line-height: 1.6;
      color: #333;
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
    }
    .header {
      background-color: #2563eb;
      color: white;
      padding: 20px;
      text-align: center;
      border-radius: 8px 8px 0 0;
    }
    .content {
      background-color: #f8f9fa;
      padding: 30px;
      border: 1px solid #e9ecef;
      border-radius: 0 0 8px 8px;
    }
    .info-table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
    }
    .info-table th {
      background-color: #e9ecef;
      padding: 10px;
      text-align: left;
      border: 1px solid #dee2e6;
    }
    .info-table td {
      padding: 10px;
      border: 1px solid #dee2e6;
    }
    .button {
      display: inline-block;
      padding: 12px 24px;
      background-color: #2563eb;
      color: white;
      text-decoration: none;
      border-radius: 6px;
      margin: 20px 0;
    }
    .footer {
      margin-top: 30px;
      padding-top: 20px;
      border-top: 1px solid #dee2e6;
      font-size: 12px;
      color: #6c757d;
      text-align: center;
    }
  </style>
</head>
<body>
  <div class="header">
    <h1>거래명세서 발송 안내</h1>
  </div>
  
  <div class="content">
    <p>안녕하세요, ${order.userProfile?.companyName ?? '고객'}님</p>
    
    <p>주문하신 제품의 거래명세서를 보내드립니다.</p>
    
    <table class="info-table">
      <tr>
        <th>주문번호</th>
        <td>${order.orderNumber}</td>
      </tr>
      <tr>
        <th>제품</th>
        <td>${order.productType == ProductType.box ? '요소수 박스(10L)' : '요소수 벌크(1,000L)'}</td>
      </tr>
      <tr>
        <th>수량</th>
        <td>${order.quantity}</td>
      </tr>
      <tr>
        <th>출고예정일</th>
        <td>${order.deliveryDate.toString().split(' ')[0]}</td>
      </tr>
      <tr>
        <th>총 금액</th>
        <td>${_formatCurrency(order.totalPrice)}원</td>
      </tr>
    </table>
    
    <p>첨부된 PDF 파일에서 거래명세서를 확인하실 수 있습니다.</p>
    
    <center>
      <a href="$pdfUrl" class="button">거래명세서 다운로드</a>
    </center>
    
    <p>문의사항이 있으시면 언제든지 연락 주시기 바랍니다.</p>
    
    <p>감사합니다.</p>
  </div>
  
  <div class="footer">
    <p>요소컴케이엠(주)</p>
    <p>경기도 김포시 고촌읍 아라육로 16</p>
    <p>TEL: 031-998-1234</p>
    <p>본 메일은 발신전용입니다.</p>
  </div>
</body>
</html>
''';
  }

  /// 주문 확정 이메일 HTML 생성
  String _generateOrderConfirmationHtml(Order order) {
    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body {
      font-family: 'Noto Sans KR', sans-serif;
      line-height: 1.6;
      color: #333;
      max-width: 600px;
      margin: 0 auto;
      padding: 20px;
    }
    .header {
      background-color: #10b981;
      color: white;
      padding: 20px;
      text-align: center;
      border-radius: 8px 8px 0 0;
    }
    .content {
      background-color: #f8f9fa;
      padding: 30px;
      border: 1px solid #e9ecef;
      border-radius: 0 0 8px 8px;
    }
    .status-badge {
      display: inline-block;
      padding: 6px 12px;
      background-color: #10b981;
      color: white;
      border-radius: 20px;
      font-weight: bold;
    }
    .info-list {
      list-style: none;
      padding: 0;
      margin: 20px 0;
    }
    .info-list li {
      padding: 8px 0;
      border-bottom: 1px solid #e9ecef;
    }
    .footer {
      margin-top: 30px;
      padding-top: 20px;
      border-top: 1px solid #dee2e6;
      font-size: 12px;
      color: #6c757d;
      text-align: center;
    }
  </style>
</head>
<body>
  <div class="header">
    <h1>주문이 확정되었습니다!</h1>
  </div>
  
  <div class="content">
    <p>안녕하세요, ${order.userProfile?.companyName ?? '고객'}님</p>
    
    <p>주문이 정상적으로 확정되었음을 알려드립니다.</p>
    
    <center>
      <span class="status-badge">주문 확정</span>
    </center>
    
    <ul class="info-list">
      <li><strong>주문번호:</strong> ${order.orderNumber}</li>
      <li><strong>제품:</strong> ${order.productType == ProductType.box ? '요소수 박스(10L)' : '요소수 벌크(1,000L)'}</li>
      <li><strong>수량:</strong> ${order.quantity}</li>
      <li><strong>출고예정일:</strong> ${order.deliveryDate.toString().split(' ')[0]}</li>
      <li><strong>배송방법:</strong> ${order.deliveryMethod == DeliveryMethod.delivery ? '배송' : '직접수령'}</li>
      <li><strong>총 금액:</strong> ${_formatCurrency(order.totalPrice)}원</li>
    </ul>
    
    <p>출고일에 맞춰 제품을 준비하겠습니다.</p>
    
    <p>거래명세서는 출고 완료 후 별도로 발송될 예정입니다.</p>
    
    <p>문의사항이 있으시면 언제든지 연락 주시기 바랍니다.</p>
    
    <p>감사합니다.</p>
  </div>
  
  <div class="footer">
    <p>요소컴케이엠(주)</p>
    <p>경기도 김포시 고촌읍 아라육로 16</p>
    <p>TEL: 031-998-1234</p>
    <p>본 메일은 발신전용입니다.</p>
  </div>
</body>
</html>
''';
  }

  /// 통화 포맷
  String _formatCurrency(double amount) {
    return amount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}