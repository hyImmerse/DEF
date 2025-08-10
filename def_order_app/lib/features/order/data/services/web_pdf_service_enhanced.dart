import 'dart:html' as html;
import 'dart:typed_data';
import 'package:intl/intl.dart';
import '../../domain/entities/order_entity.dart';
import '../../../../core/utils/logger.dart';

/// 웹 환경 전용 PDF 생성 서비스
/// HTML을 통한 PDF 생성으로 한글 폰트 문제 해결
class WebPdfServiceEnhanced {
  static const String _companyName = '요소컴케이엠(주)';
  static const String _companyAddress = '경기도 김포시 고촌읍 아라육로 16';
  static const String _companyPhone = '031-998-1234';
  static const String _companyRegNo = '123-45-67890';

  /// 거래명세서 HTML 생성 및 PDF 다운로드
  Future<void> generateAndDownloadTransactionStatement(OrderEntity order) async {
    try {
      logger.i('웹 환경: HTML 기반 거래명세서 생성 시작');
      
      // HTML 문서 생성
      final htmlContent = _generateStatementHtml(order);
      
      // 새 윈도우에서 HTML 표시
      final newWindow = html.window.open('', '_blank', 'width=800,height=600');
      if (newWindow != null) {
        newWindow.document?.write(htmlContent);
        newWindow.document?.close();
        
        // 잠시 기다린 후 프린트 다이얼로그 열기
        await Future.delayed(const Duration(milliseconds: 500));
        newWindow.print();
        
        logger.i('HTML 거래명세서 생성 완료 - 프린트 대화상자 호출');
      } else {
        logger.e('새 윈도우 열기 실패 - 팝업 차단됨');
        // 팝업 차단된 경우 현재 윈도우에 HTML 표시
        _showHtmlInCurrentWindow(htmlContent, order);
      }
    } catch (e) {
      logger.e('웹 HTML PDF 생성 실패', e);
      rethrow;
    }
  }

  /// 현재 윈도우에서 HTML 표시
  void _showHtmlInCurrentWindow(String htmlContent, OrderEntity order) {
    // Blob URL 생성
    final blob = html.Blob([htmlContent], 'text/html');
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    // 새 탭에서 열기
    html.window.open(url, '_blank');
    
    // 메모리 정리
    html.Url.revokeObjectUrl(url);
  }

  /// 거래명세서 HTML 생성
  String _generateStatementHtml(OrderEntity order) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');
    final numberFormat = NumberFormat('#,###');
    final now = DateTime.now();
    final subtotal = order.unitPrice * order.quantity;
    final shippingCost = order.calculateEstimatedShippingCost();

    return '''
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>거래명세서 - ${order.orderNumber}</title>
    <style>
        @media print {
            body { margin: 0; }
            .no-print { display: none; }
        }
        
        body {
            font-family: 'Malgun Gothic', '맑은 고딕', 'Noto Sans KR', 'Apple SD Gothic Neo', sans-serif;
            margin: 20px;
            font-size: 14px;
            line-height: 1.4;
            color: #333;
        }
        
        .document {
            max-width: 800px;
            margin: 0 auto;
            padding: 30px;
            border: 2px solid #333;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
        }
        
        .header h1 {
            font-size: 28px;
            font-weight: bold;
            margin: 0 0 20px 0;
            letter-spacing: 8px;
        }
        
        .company-info {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 30px;
        }
        
        .company-details {
            text-align: left;
        }
        
        .company-details div {
            margin-bottom: 5px;
        }
        
        .seal-box {
            width: 100px;
            height: 100px;
            border: 2px solid #333;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            font-size: 16px;
        }
        
        .order-info {
            background-color: #f9f9f9;
            padding: 15px;
            margin-bottom: 20px;
            border: 1px solid #ddd;
        }
        
        .info-row {
            display: flex;
            margin-bottom: 8px;
        }
        
        .info-label {
            font-weight: bold;
            width: 100px;
            display: inline-block;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        
        th, td {
            border: 1px solid #333;
            padding: 10px;
            text-align: center;
        }
        
        th {
            background-color: #e9e9e9;
            font-weight: bold;
        }
        
        .price-summary {
            width: 300px;
            margin-left: auto;
            margin-bottom: 30px;
        }
        
        .price-summary table {
            width: 100%;
        }
        
        .price-summary .total-row {
            background-color: #f0f0f0;
            font-weight: bold;
        }
        
        .footer {
            text-align: center;
            margin-top: 50px;
        }
        
        .footer-note {
            margin-top: 15px;
            font-size: 12px;
            color: #666;
        }
        
        .no-print {
            margin: 20px 0;
            text-align: center;
        }
        
        .btn {
            background-color: #007bff;
            color: white;
            border: none;
            padding: 10px 20px;
            margin: 0 5px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 14px;
        }
        
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
</head>
<body>
    <div class="no-print">
        <button class="btn" onclick="window.print()">PDF로 저장/출력</button>
        <button class="btn" onclick="window.close()">창 닫기</button>
    </div>
    
    <div class="document">
        <div class="header">
            <h1>거 래 명 세 서</h1>
            
            <div class="company-info">
                <div class="company-details">
                    <div style="font-size: 18px; font-weight: bold;">${_companyName}</div>
                    <div>${_companyAddress}</div>
                    <div>TEL: ${_companyPhone}</div>
                    <div>사업자번호: ${_companyRegNo}</div>
                </div>
                
                <div class="seal-box">
                    직인
                </div>
            </div>
        </div>
        
        <div class="order-info">
            <div class="info-row">
                <span class="info-label">거래처명:</span>
                <span>${order.userProfile?.businessName ?? '데모회사'}</span>
            </div>
            <div class="info-row">
                <span class="info-label">발행일:</span>
                <span>${dateFormat.format(now)}</span>
            </div>
            <div class="info-row">
                <span class="info-label">주문번호:</span>
                <span>${order.orderNumber}</span>
            </div>
        </div>
        
        <h3>주문 정보</h3>
        <table>
            <tr>
                <th>출고일</th>
                <td>${dateFormat.format(order.deliveryDate)}</td>
                <th>배송방법</th>
                <td>${order.deliveryMethod == DeliveryMethod.delivery ? '배송' : '직접수령'}</td>
            </tr>
        </table>
        
        <h3>주문 상세</h3>
        <table>
            <thead>
                <tr>
                    <th style="width: 40%">품목</th>
                    <th style="width: 15%">수량</th>
                    <th style="width: 20%">단가</th>
                    <th style="width: 25%">금액</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>${order.productType == ProductType.box ? '요소수 (박스 10L)' : '요소수 (벌크 1,000L)'}</td>
                    <td>${numberFormat.format(order.quantity)}</td>
                    <td>${numberFormat.format(order.unitPrice)}원</td>
                    <td>${numberFormat.format(order.unitPrice * order.quantity)}원</td>
                </tr>
                ${order.javaraQuantity != null && order.javaraQuantity! > 0 ? '''
                <tr>
                    <td>자바라</td>
                    <td>${numberFormat.format(order.javaraQuantity)}</td>
                    <td>-</td>
                    <td>-</td>
                </tr>
                ''' : ''}
                ${order.returnTankQuantity != null && order.returnTankQuantity! > 0 ? '''
                <tr>
                    <td>반납통</td>
                    <td>${numberFormat.format(order.returnTankQuantity)}</td>
                    <td>-</td>
                    <td>-</td>
                </tr>
                ''' : ''}
            </tbody>
        </table>
        
        <div class="price-summary">
            <table>
                <tr>
                    <th>공급가액</th>
                    <td style="text-align: right;">${numberFormat.format(subtotal)}원</td>
                </tr>
                ${shippingCost > 0 ? '''
                <tr>
                    <th>배송비</th>
                    <td style="text-align: right;">${numberFormat.format(shippingCost)}원</td>
                </tr>
                ''' : ''}
                <tr class="total-row">
                    <th>합계금액</th>
                    <td style="text-align: right;">${numberFormat.format(order.totalPrice)}원</td>
                </tr>
            </table>
        </div>
        
        <div class="footer">
            <div style="font-size: 16px; margin-bottom: 15px;">
                상기와 같이 거래함을 확인합니다.
            </div>
            
            <div class="footer-note">
                본 거래명세서는 세금계산서가 아니므로 세무처리에 사용할 수 없습니다.
            </div>
        </div>
    </div>
</body>
</html>
''';
  }

  /// 파일명 생성
  String generateFileName(OrderEntity order) {
    final dateFormat = DateFormat('yyyyMMdd');
    final date = dateFormat.format(DateTime.now());
    return 'statement_${order.orderNumber}_$date.pdf';
  }
}