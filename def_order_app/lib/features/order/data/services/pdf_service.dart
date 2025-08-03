import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/order_entity.dart';
import '../../../../core/utils/logger.dart';

/// 거래명세서 PDF 생성 서비스
class PdfService {
  static const String _companyName = '요소컴케이엠(주)';
  static const String _companyAddress = '경기도 김포시 고촌읍 아라육로 16';
  static const String _companyPhone = '031-998-1234';
  static const String _companyRegNo = '123-45-67890';

  /// 거래명세서 PDF 생성
  Future<Uint8List> generateTransactionStatement(Order order) async {
    try {
      final pdf = pw.Document();
      
      // 한글 폰트 로드
      final font = await PdfGoogleFonts.notoSansKR();
      final boldFont = await PdfGoogleFonts.notoSansKRBold();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // 헤더
                _buildHeader(font, boldFont),
                pw.SizedBox(height: 30),
                
                // 거래처 정보
                _buildCustomerInfo(order, font, boldFont),
                pw.SizedBox(height: 20),
                
                // 주문 정보
                _buildOrderInfo(order, font, boldFont),
                pw.SizedBox(height: 30),
                
                // 주문 상세
                _buildOrderDetails(order, font, boldFont),
                pw.SizedBox(height: 30),
                
                // 가격 정보
                _buildPriceInfo(order, font, boldFont),
                pw.SizedBox(height: 50),
                
                // 푸터
                _buildFooter(font),
              ],
            );
          },
        ),
      );

      return pdf.save();
    } catch (e) {
      logger.e('PDF 생성 실패', error: e);
      rethrow;
    }
  }

  /// 헤더 생성
  pw.Widget _buildHeader(pw.Font font, pw.Font boldFont) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 2),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            '거 래 명 세 서',
            style: pw.TextStyle(
              font: boldFont,
              fontSize: 24,
              letterSpacing: 5,
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    _companyName,
                    style: pw.TextStyle(font: boldFont, fontSize: 16),
                  ),
                  pw.Text(
                    _companyAddress,
                    style: pw.TextStyle(font: font, fontSize: 12),
                  ),
                  pw.Text(
                    'TEL: $_companyPhone',
                    style: pw.TextStyle(font: font, fontSize: 12),
                  ),
                  pw.Text(
                    '사업자번호: $_companyRegNo',
                    style: pw.TextStyle(font: font, fontSize: 12),
                  ),
                ],
              ),
              pw.Container(
                width: 80,
                height: 80,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Center(
                  child: pw.Text(
                    '직인',
                    style: pw.TextStyle(font: font, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 거래처 정보
  pw.Widget _buildCustomerInfo(Order order, pw.Font font, pw.Font boldFont) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');
    
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Text('거래처명: ', style: pw.TextStyle(font: boldFont)),
              pw.Text(
                order.userProfile?.companyName ?? '',
                style: pw.TextStyle(font: font),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              pw.Text('발행일: ', style: pw.TextStyle(font: boldFont)),
              pw.Text(
                dateFormat.format(DateTime.now()),
                style: pw.TextStyle(font: font),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              pw.Text('주문번호: ', style: pw.TextStyle(font: boldFont)),
              pw.Text(
                order.orderNumber,
                style: pw.TextStyle(font: font),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 주문 정보
  pw.Widget _buildOrderInfo(Order order, pw.Font font, pw.Font boldFont) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '주문 정보',
          style: pw.TextStyle(font: boldFont, fontSize: 16),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              children: [
                _buildTableCell('출고일', font, boldFont, isHeader: true),
                _buildTableCell(
                  dateFormat.format(order.deliveryDate),
                  font,
                  boldFont,
                ),
                _buildTableCell('배송방법', font, boldFont, isHeader: true),
                _buildTableCell(
                  order.deliveryMethod == DeliveryMethod.delivery
                      ? '배송'
                      : '직접수령',
                  font,
                  boldFont,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 주문 상세
  pw.Widget _buildOrderDetails(Order order, pw.Font font, pw.Font boldFont) {
    final numberFormat = NumberFormat('#,###');
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '주문 상세',
          style: pw.TextStyle(font: boldFont, fontSize: 16),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          columnWidths: {
            0: const pw.FlexColumnWidth(2),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1),
            3: const pw.FlexColumnWidth(2),
          },
          children: [
            // 헤더
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('품목', font, boldFont, isHeader: true),
                _buildTableCell('수량', font, boldFont, isHeader: true),
                _buildTableCell('단가', font, boldFont, isHeader: true),
                _buildTableCell('금액', font, boldFont, isHeader: true),
              ],
            ),
            // 주문 내역
            pw.TableRow(
              children: [
                _buildTableCell(
                  order.productType == ProductType.box
                      ? '요소수 (박스 10L)'
                      : '요소수 (벌크 1,000L)',
                  font,
                  boldFont,
                ),
                _buildTableCell(
                  '${numberFormat.format(order.quantity)}',
                  font,
                  boldFont,
                ),
                _buildTableCell(
                  '${numberFormat.format(order.unitPrice)}원',
                  font,
                  boldFont,
                ),
                _buildTableCell(
                  '${numberFormat.format(order.unitPrice * order.quantity)}원',
                  font,
                  boldFont,
                ),
              ],
            ),
            // 자바라 수량 (있는 경우)
            if (order.javaraQuantity != null && order.javaraQuantity! > 0)
              pw.TableRow(
                children: [
                  _buildTableCell('자바라', font, boldFont),
                  _buildTableCell(
                    '${numberFormat.format(order.javaraQuantity)}',
                    font,
                    boldFont,
                  ),
                  _buildTableCell('-', font, boldFont),
                  _buildTableCell('-', font, boldFont),
                ],
              ),
            // 반납통 수량 (있는 경우)
            if (order.returnTankQuantity != null && order.returnTankQuantity! > 0)
              pw.TableRow(
                children: [
                  _buildTableCell('반납통', font, boldFont),
                  _buildTableCell(
                    '${numberFormat.format(order.returnTankQuantity)}',
                    font,
                    boldFont,
                  ),
                  _buildTableCell('-', font, boldFont),
                  _buildTableCell('-', font, boldFont),
                ],
              ),
          ],
        ),
      ],
    );
  }

  /// 가격 정보
  pw.Widget _buildPriceInfo(Order order, pw.Font font, pw.Font boldFont) {
    final numberFormat = NumberFormat('#,###');
    final subtotal = order.unitPrice * order.quantity;
    final shippingCost = order.calculateEstimatedShippingCost();
    
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Container(
        width: 250,
        child: pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              children: [
                _buildTableCell('공급가액', font, boldFont, isHeader: true),
                _buildTableCell(
                  '${numberFormat.format(subtotal)}원',
                  font,
                  boldFont,
                  align: pw.TextAlign.right,
                ),
              ],
            ),
            if (shippingCost > 0)
              pw.TableRow(
                children: [
                  _buildTableCell('배송비', font, boldFont, isHeader: true),
                  _buildTableCell(
                    '${numberFormat.format(shippingCost)}원',
                    font,
                    boldFont,
                    align: pw.TextAlign.right,
                  ),
                ],
              ),
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _buildTableCell('합계금액', font, boldFont, isHeader: true),
                _buildTableCell(
                  '${numberFormat.format(order.totalPrice)}원',
                  font,
                  boldFont,
                  align: pw.TextAlign.right,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 푸터
  pw.Widget _buildFooter(pw.Font font) {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Column(
        children: [
          pw.Text(
            '상기와 같이 거래함을 확인합니다.',
            style: pw.TextStyle(font: font, fontSize: 12),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            '본 거래명세서는 세금계산서가 아니므로 세무처리에 사용할 수 없습니다.',
            style: pw.TextStyle(
              font: font,
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  /// 테이블 셀 생성 헬퍼
  pw.Widget _buildTableCell(
    String text,
    pw.Font font,
    pw.Font boldFont, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.center,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: isHeader ? boldFont : font,
          fontSize: isHeader ? 12 : 11,
        ),
        textAlign: align,
      ),
    );
  }

  /// PDF 파일명 생성
  String generateFileName(Order order) {
    final dateFormat = DateFormat('yyyyMMdd');
    final date = dateFormat.format(DateTime.now());
    return 'statement_${order.orderNumber}_$date.pdf';
  }
}