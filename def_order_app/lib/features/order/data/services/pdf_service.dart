import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../domain/entities/order_entity.dart';
import '../models/order_model.dart';
import '../../../../core/utils/logger.dart';

/// 거래명세서 PDF 생성 서비스
class PdfService {
  static const String _companyName = '요소컴케이엠(주)';
  static const String _companyAddress = '경기도 김포시 고촌읍 아라육로 16';
  static const String _companyPhone = '031-998-1234';
  static const String _companyRegNo = '123-45-67890';
  
  // 한글 폰트 캐시
  static pw.Font? _koreanFont;
  static pw.Font? _koreanBoldFont;

  /// 한글 폰트 로드 (웹 환경 개선 버전)
  Future<void> _loadKoreanFonts() async {
    try {
      if (_koreanFont == null || _koreanBoldFont == null) {
        logger.i('한글 폰트 로딩 시작...');
        
        // 웹 환경에서는 다른 폰트 로딩 전략 사용
        if (kIsWeb) {
          logger.i('웹 환경 감지: 브라우저 기본 폰트 폴백 사용');
          // 웹 환경에서는 브라우저의 시스템 폰트를 사용하도록 null로 설정
          _koreanFont = null;
          _koreanBoldFont = null;
          logger.i('웹 환경: 브라우저 시스템 폰트 사용으로 설정 완료');
          return;
        }
        
        // 로컬 폰트 파일 로드 시도
        try {
          logger.i('로컬 폰트 파일 로드 시도...');
          final regularFontData = await rootBundle.load('assets/fonts/NotoSansKR-Regular.ttf');
          final boldFontData = await rootBundle.load('assets/fonts/NotoSansKR-Bold.ttf');
          
          _koreanFont = pw.Font.ttf(regularFontData);
          _koreanBoldFont = pw.Font.ttf(boldFontData);
          
          logger.i('로컬 한글 폰트 로드 완료: NotoSansKR');
        } catch (e) {
          logger.e('로컬 폰트 파일 로드 실패: $e');
          throw e;
        }
      }
    } catch (e) {
      logger.e('모든 한글 폰트 로드 실패, 폴백 모드로 전환: $e');
      _koreanFont = null;
      _koreanBoldFont = null;
      
      // 웹 환경에서 추가 에러 정보 출력
      if (kIsWeb) {
        logger.e('웹 환경 폰트 로드 실패 - 가능한 원인:');
        logger.e('1. assets/fonts/ 폴더에 폰트 파일이 없음');
        logger.e('2. pubspec.yaml assets 설정 누락');
        logger.e('3. 웹에서 Google Fonts API 접근 제한');
      }
    }
  }

  /// 거래명세서 PDF 생성
  Future<Uint8List> generateTransactionStatement(OrderEntity order) async {
    try {
      // 한글 폰트 로드
      await _loadKoreanFonts();
      
      final pdf = pw.Document();

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // 헤더
                _buildHeader(),
                pw.SizedBox(height: 30),
                
                // 거래처 정보
                _buildCustomerInfo(order),
                pw.SizedBox(height: 20),
                
                // 주문 정보
                _buildOrderInfo(order),
                pw.SizedBox(height: 30),
                
                // 주문 상세
                _buildOrderDetails(order),
                pw.SizedBox(height: 30),
                
                // 가격 정보
                _buildPriceInfo(order),
                pw.SizedBox(height: 50),
                
                // 푸터
                _buildFooter(),
              ],
            );
          },
        ),
      );

      return pdf.save();
    } catch (e) {
      logger.e('PDF 생성 실패', e);
      rethrow;
    }
  }

  /// 헤더 생성
  pw.Widget _buildHeader() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.black, width: 2),
      ),
      child: pw.Column(
        children: [
          _buildText(
            '거 래 명 세 서',
            fontSize: 24,
            isBold: true,
            letterSpacing: 5,
            align: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 20),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  _buildText(_companyName, fontSize: 16, isBold: true),
                  _buildText(_companyAddress, fontSize: 12),
                  _buildText('TEL: $_companyPhone', fontSize: 12),
                  _buildText('사업자번호: $_companyRegNo', fontSize: 12),
                ],
              ),
              pw.Container(
                width: 80,
                height: 80,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.black),
                ),
                child: pw.Center(
                  child: _buildText('직인', fontSize: 14),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 거래처 정보
  pw.Widget _buildCustomerInfo(OrderEntity order) {
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
              _buildText('거래처명: ', isBold: true),
              _buildText(order.userProfile?.businessName ?? '데모회사'),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              _buildText('발행일: ', isBold: true),
              _buildText(dateFormat.format(DateTime.now())),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            children: [
              _buildText('주문번호: ', isBold: true),
              _buildText(order.orderNumber),
            ],
          ),
        ],
      ),
    );
  }

  /// 주문 정보
  pw.Widget _buildOrderInfo(OrderEntity order) {
    final dateFormat = DateFormat('yyyy년 MM월 dd일');
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildText('주문 정보', fontSize: 16, isBold: true),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              children: [
                _buildTableCell('출고일', isHeader: true),
                _buildTableCell(dateFormat.format(order.deliveryDate)),
                _buildTableCell('배송방법', isHeader: true),
                _buildTableCell(
                  order.deliveryMethod == DeliveryMethod.delivery
                      ? '배송'
                      : '직접수령',
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// 주문 상세
  pw.Widget _buildOrderDetails(OrderEntity order) {
    final numberFormat = NumberFormat('#,###');
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildText('주문 상세', fontSize: 16, isBold: true),
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
                _buildTableCell('품목', isHeader: true),
                _buildTableCell('수량', isHeader: true),
                _buildTableCell('단가', isHeader: true),
                _buildTableCell('금액', isHeader: true),
              ],
            ),
            // 주문 내역
            pw.TableRow(
              children: [
                _buildTableCell(
                  order.productType == ProductType.box
                      ? '요소수 (박스 10L)'
                      : '요소수 (벌크 1,000L)',
                ),
                _buildTableCell('${numberFormat.format(order.quantity)}'),
                _buildTableCell('${numberFormat.format(order.unitPrice)}원'),
                _buildTableCell('${numberFormat.format(order.unitPrice * order.quantity)}원'),
              ],
            ),
            // 자바라 수량 (있는 경우)
            if (order.javaraQuantity != null && order.javaraQuantity! > 0)
              pw.TableRow(
                children: [
                  _buildTableCell('자바라'),
                  _buildTableCell('${numberFormat.format(order.javaraQuantity)}'),
                  _buildTableCell('-'),
                  _buildTableCell('-'),
                ],
              ),
            // 반납통 수량 (있는 경우)
            if (order.returnTankQuantity != null && order.returnTankQuantity! > 0)
              pw.TableRow(
                children: [
                  _buildTableCell('반납통'),
                  _buildTableCell('${numberFormat.format(order.returnTankQuantity)}'),
                  _buildTableCell('-'),
                  _buildTableCell('-'),
                ],
              ),
          ],
        ),
      ],
    );
  }

  /// 가격 정보
  pw.Widget _buildPriceInfo(OrderEntity order) {
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
                _buildTableCell('공급가액', isHeader: true),
                _buildTableCell(
                  '${numberFormat.format(subtotal)}원',
                  align: pw.TextAlign.right,
                ),
              ],
            ),
            if (shippingCost > 0)
              pw.TableRow(
                children: [
                  _buildTableCell('배송비', isHeader: true),
                  _buildTableCell(
                    '${numberFormat.format(shippingCost)}원',
                    align: pw.TextAlign.right,
                  ),
                ],
              ),
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey100),
              children: [
                _buildTableCell('합계금액', isHeader: true),
                _buildTableCell(
                  '${numberFormat.format(order.totalPrice)}원',
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
  pw.Widget _buildFooter() {
    return pw.Container(
      alignment: pw.Alignment.center,
      child: pw.Column(
        children: [
          _buildText(
            '상기와 같이 거래함을 확인합니다.',
            fontSize: 12,
            align: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 10),
          _buildText(
            '본 거래명세서는 세금계산서가 아니므로 세무처리에 사용할 수 없습니다.',
            fontSize: 10,
            color: PdfColors.grey600,
            align: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// 한글 텍스트 생성 헬퍼
  pw.Widget _buildText(
    String text, {
    double fontSize = 12,
    bool isBold = false,
    PdfColor? color,
    pw.TextAlign align = pw.TextAlign.left,
    double letterSpacing = 0,
  }) {
    // 웹 환경에서의 폰트 처리
    if (kIsWeb) {
      // 웹 환경에서는 fontFallback을 통해 시스템 폰트 사용
      return pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color ?? PdfColors.black,
          letterSpacing: letterSpacing,
          // 웹 환경에서 한글 폰트 폴백 설정
          fontFallback: [
            // 시스템에서 사용 가능한 한글 폰트들
            pw.Font.helvetica(), // 기본 폰트
          ],
        ),
        textAlign: align,
      );
    }
    
    // 네이티브 환경에서의 한글 폰트 적용
    pw.Font? selectedFont = isBold ? _koreanBoldFont : _koreanFont;
    
    if (selectedFont == null) {
      // 폰트가 없는 경우 기본 텍스트 스타일 사용
      return pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: fontSize,
          fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color ?? PdfColors.black,
          letterSpacing: letterSpacing,
        ),
        textAlign: align,
      );
    }
    
    return pw.Text(
      text,
      style: pw.TextStyle(
        font: selectedFont,
        fontSize: fontSize,
        color: color ?? PdfColors.black,
        letterSpacing: letterSpacing,
      ),
      textAlign: align,
    );
  }

  /// 테이블 셀 생성 헬퍼
  pw.Widget _buildTableCell(
    String text, {
    bool isHeader = false,
    pw.TextAlign align = pw.TextAlign.center,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      child: _buildText(
        text,
        fontSize: isHeader ? 12 : 11,
        isBold: isHeader,
        align: align,
      ),
    );
  }

  /// PDF 파일명 생성
  String generateFileName(OrderEntity order) {
    final dateFormat = DateFormat('yyyyMMdd');
    final date = dateFormat.format(DateTime.now());
    return 'statement_${order.orderNumber}_$date.pdf';
  }
}